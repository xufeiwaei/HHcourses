/*
Computes the 3D gradient dx, dy, dt of image pairs.
This function uses a static piece of memory to store the previous image (as well as a gaussian pyramid of it).
This memory is equal to roughly 4 times the size of a single video frame.

IMPORTANT: THIS FUNCTION USES UNDOCUMMENTED MATLAB MXFUNCTIONS. Verified to work on windows versions of matlab, 2010a, and 2011b
*/
#include "Grad2D.h"
#include <omp.h>

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
	static int hasAllocated = 0;
	static	progData pD;
	int		status;
   if( nrhs == 0 ){
       if(hasAllocated){
        	deAllocateMem(&pD);
			hasAllocated = 0;
        }
		return;
    }
    if (!hasAllocated){//then allocate
        if (allocateMem(&pD,&prhs[0], nrhs) == MALLOCFAIL){
            mexWarnMsgTxt("grad im malloc failed 2...\n");
            return;
        }
        hasAllocated = 1;
    }

   if( nrhs == 1 ){
		if( (status = getData(plhs,&prhs[0], &pD, nrhs)) != SUCCESS ){
			 return;
		}
   }
   else{ // if nrhs > 1
	   assert(nlhs==0);
		if( (status = getData_ip(plhs,&prhs[0], &pD, nrhs)) != SUCCESS ){
			 return;
		}
   }

    if( gradCalc(plhs, &pD) != SUCCESS ){
        mexWarnMsgTxt("error gradCalc\n");
        return;
     }
    return;
}

void __forceinline getDerivs(const int X,const int Y,	const uint8 * restrict im1,	const uint8 * restrict im2, const int H, int &dx,int &dy,int &sumT1,int &sumT2)
{
	int k;
	k = (X-1)*H + Y-1;///	int ii = -1;	int jj = -1;
	dx = -3*im1[k];	dy  = -3*im1[k];//sumT1 = 2*im1[k];sumT2  =  2*im2[k];

	k = (X-1)*H + Y;/// ii = -1;	 jj = 0;
	dy += -10*im1[k];//sumT1 +=  4*im1[k];sumT2 +=  4*im2[k];

	k = (X-1)*H + Y+1;///	ii = -1;	 jj = 1;
	dx +=  3*im1[k];dy+=-3*im1[k];//sumT1 += 2*im1[k]; sumT2 +=  2*im2[k];

	k = X*H + Y-1;/// ii = 0;	 jj = -1;
	dx+= -10*im1[k];//sumT1 +=  4*im1[k];sumT2 +=  4*im2[k];

	k = X*H + Y;/// ii = 0;	 jj = 0;
	///observe!!! =, not +=
	sumT1 =  8*im1[k];	sumT2 =  8*im2[k];

	k = X*H + Y+1;/// ii = 0;	 jj = 1;
	dx +=  10*im1[k];//sumT1 +=  4*im1[k];sumT2 +=  4*im2[k];

	k = (X+1)*H + Y-1;/// ii = 1;	 jj = -1;
	dx    +=  -3*im1[k];dy += 3*im1[k];//sumT1 += 2*im1[k];sumT2 +=  2*im2[k];

	k = (X+1)*H + Y;/// ii = 1;	 jj = 0;
	dy    +=  10*im1[k];//sumT1 +=  4*im1[k];sumT2 +=  4*im2[k];

	k = (X+1)*H + Y+1;///	 ii = 1;	 jj = 1;
	dx    +=  3*im1[k];	dy  += 3*im1[k];	//sumT1 += 2*im1[k];sumT2 +=  2*im2[k];
}

int	gradCalc(mxArray *plhs[], progData *pD)
{
    int X, Y, H, W, HC, WC, ii, jj;
    int	sumX, sumY, sumT1,sumT2;
    uint8 *im1, *im2;
    uint8 *im1C, *im2C;
    PREC *dx, *dy, *dt, *dxC, *dyC, *dtC;
// for changing the filter masks, I need to also change the macros:    
// #define FW  5
// #define HFW  2
// int at_mask[]=  { 3,  15,  27,  15,  3, 
//                  15,  82, 145,  82, 15,
//                  27, 145, 255, 145, 27,
//                  15,  82, 145,  82, 15,
//                   3,  15,  27,  15,  3};
// int d_mask[]=    {-10,  -53,  -93,  -53, -10, 
//                   -27, -145, -255, -145, -27,
//                     0,    0,    0,    0,   0,
//                    27,  145,  255,  145,  27, 
//                    10,   53,   93,   53,  10};
    
     const int d_mask[]= {-3, -10, -3,
                     0,   0,  0,
                     3,  10,  3};
     const int at_mask[]= {2,  4, 2,
                     4, 8, 4,
                     2,  4, 2};
	 const int sumOfMask = 32;

     im1  = pD->bw_im1.im;     im2  = pD->bw_im2.im;    dx   = pD->dx_im.im;     dy   = pD->dy_im.im;     dt   = pD->dt_im.im;
     im1C = pD->bw_im1C.im;    im2C = pD->bw_im2C.im;	dxC  = pD->dx_imC.im;    dyC  = pD->dy_imC.im;    dtC  = pD->dt_imC.im;     
    
    W = pD->bw_im1.dims[1];    H = pD->bw_im1.dims[0];
    WC = pD->bw_im1C.dims[1];  HC = pD->bw_im1C.dims[0];

	assert(sumOfMask == 32);//if a change is to be done on the averaging mask, then division by sumOfMask is no longer <<5 (see in loop below)
    // 1st Convolution starts here
	//#pragma omp parallel for private(Y, X, sumX, sumY, sumT1,sumT2)
    for(Y=HFW; Y<H-HFW; Y++)  {
        for(X=HFW; X<W-HFW; X++)  {
			getDerivs(X,Y,	im1,im2,H, sumX,sumY,sumT1,sumT2);
/*			sumX = 0;  sumY = 0;  sumT1 = 0;sumT2 = 0;
			for (ii = -HFW; ii <= HFW;ii++){
				for (jj = -HFW; jj <= HFW;jj++){
///////////  first image:
					sumX  += (*(im1+(X+ii)*H + (Y+jj))) * d_mask[ (ii+HFW)%FW + (jj+HFW)*FW];//d_mask[1+ii]*a_mask[1+jj]; //*a_mask[1-1];
					sumY  += (*(im1+(X+ii)*H + (Y+jj))) * d_mask[ (jj+HFW)%FW + (ii+HFW)*FW];//a_mask[1+ii]*d_mask[1+jj]; //*a_mask[1-1];
					sumT1 += (*(im1+(X+ii)*H + (Y+jj))) * at_mask[(ii+HFW)%FW + (jj+HFW)*FW];//a_mask[1+ii]*a_mask[1+jj];   //*d_mask[1-1];
///////////  second image:					
  					sumX  += (*(im2+(X+ii)*H + (Y+jj))) *  d_mask[(ii+HFW)%FW + (jj+HFW)*FW];//d_mask[1+ii]*a_mask[1+jj];//*a_mask[1-1];
  					sumY  += (*(im2+(X+ii)*H + (Y+jj))) *  d_mask[(jj+HFW)%FW + (ii+HFW)*FW];//a_mask[1+ii]*d_mask[1+jj];//*a_mask[1-1];
					sumT2 += (*(im2+(X+ii)*H + (Y+jj))) * at_mask[(ii+HFW)%FW + (jj+HFW)*FW];//a_mask[1+ii]*a_mask[1+jj]; //d_mask[1+1];	 //notice the subtraction!	
				}
			}
	*/		
#if defined (PRECISCION_DOUBLE) || defined (PRECISCION_FLOAT)
            *(dx+(X-HFW)*(H-HFW*2)+(Y-HFW)) = (PREC)(sumX)/(PREC)(1<<16);
            *(dy+(X-HFW)*(H-HFW*2)+(Y-HFW)) = (PREC)(sumY)/(PREC)(1<<16);
            *(dt+(X-HFW)*(H-HFW*2)+(Y-HFW)) = (PREC)(sumT1 -sumT2)/(PREC)(1<<16);
#else
			*(dx+(X-HFW)*(H-HFW*2)+(Y-HFW)) = (PREC)(sumX);
            *(dy+(X-HFW)*(H-HFW*2)+(Y-HFW)) = (PREC)(sumY);
            *(dt+(X-HFW)*(H-HFW*2)+(Y-HFW)) = (PREC)(sumT1 -sumT2);
#endif

            if((X%2) && (Y%2)){
//                 *(im1C+(X/2)*HC+Y/2) = (uint8)(sumT1/sumOfMask);
				   *(im1C+(X/2)*HC+Y/2) = (uint8)(sumT1>>5);//for sumOfMask = 32
//                 *(im2C+(Y/2)*WC+X/2) = (int32)(sumT2);
            }
//			if((X%M) && (Y%M)){
	//			   //gather moment pixel
      //      }
        }
    }
	
    // Coarse Convolution starts here
	//#pragma omp parallel for private(Y, X, sumX, sumY, sumT1,sumT2)
    for(Y=HFW; Y<HC-HFW; Y++)  {
        for(X=HFW; X<WC-HFW; X++)  {
			getDerivs(X,Y,	im1C,im2C,HC, sumX,sumY,sumT1,sumT2);
/*			sumX = 0;  sumY = 0;  sumT1 = 0;sumT2 = 0;
			for (ii = -HFW; ii <= HFW;ii++){
				for (jj = -HFW; jj <= HFW;jj++){
///////////  first image:
					sumX  += (*(im1C+(X+ii)*HC + (Y+jj))) * d_mask[ (ii+HFW)%FW + (jj+HFW)*FW];//d_mask[1+ii]*a_mask[1+jj]; //*a_mask[1-1];
					sumY  += (*(im1C+(X+ii)*HC + (Y+jj))) * d_mask[ (jj+HFW)%FW + (ii+HFW)*FW];//a_mask[1+ii]*d_mask[1+jj]; //*a_mask[1-1];
					sumT1 += (*(im1C+(X+ii)*HC + (Y+jj))) * at_mask[(ii+HFW)%FW + (jj+HFW)*FW];//a_mask[1+ii]*a_mask[1+jj];   //*d_mask[1-1];
///////////  second image:					
  					sumX  += (*(im2C+(X+ii)*HC + (Y+jj))) *  d_mask[(ii+HFW)%FW + (jj+HFW)*FW];//d_mask[1+ii]*a_mask[1+jj];//*a_mask[1-1];
  					sumY  += (*(im2C+(X+ii)*HC + (Y+jj))) *  d_mask[(jj+HFW)%FW + (ii+HFW)*FW];//a_mask[1+ii]*d_mask[1+jj];//*a_mask[1-1];
					sumT1 -= (*(im2C+(X+ii)*HC + (Y+jj))) * at_mask[(ii+HFW)%FW + (jj+HFW)*FW];//a_mask[1+ii]*a_mask[1+jj]; //d_mask[1+1];	 //notice the subtraction!	
				}
			}
			*/
#if defined (PRECISCION_DOUBLE) || defined (PRECISCION_FLOAT)
            *(dxC+(X-HFW)*(HC-HFW*2)+(Y-HFW)) = (PREC)(sumX)/(PREC)(1<<16);
            *(dyC+(X-HFW)*(HC-HFW*2)+(Y-HFW)) = (PREC)(sumY)/(PREC)(1<<16);
            *(dtC+(X-HFW)*(HC-HFW*2)+(Y-HFW)) = (PREC)(sumT1 -sumT2)/(PREC)(1<<16);
#else
            *(dxC+(X-HFW)*(HC-HFW*2)+(Y-HFW)) = (PREC)(sumX);
            *(dyC+(X-HFW)*(HC-HFW*2)+(Y-HFW)) = (PREC)(sumY);
            *(dtC+(X-HFW)*(HC-HFW*2)+(Y-HFW)) = (PREC)(sumT1);
#endif


//             if((X%2) && (Y%2)){
//                  *(im1C+(Y/2)*WC+X/2) = (int32)(sumT1);
//                  *(im2C+(Y/2)*WC+X/2) = (int32)(sumT2);
//             }
        }
    }	
	return SUCCESS;
}

/*
 *  getData:  Gets data from a Matlab argument.
 *  Inputs: 
 *      const mxArray **prhs: Right hand side argument with RGB image
 *		(image *) Pointer to the black and white image struct.
 *
 *  Returns:
 *      int: 0 is successful run. -1 is a bad malloc. -2 is improper dims. 
 */
int getData(mxArray *plhs[], const mxArray **prhs, progData *pD, int nrhs)
{ 
    static image bufIm;
    static image bufImC;
	//if debug, check that we have correct size of input
	#ifndef  NDEBUG
		int W, H;
		W = (int)mxGetN(prhs[0]);
		H = (int)mxGetM(prhs[0]);
		assert(pD->bw_im1.dims[0] == H);
		assert(pD->bw_im1.dims[1] == W);
		if (pD->bw_im1.dims[0] != H || pD->bw_im1.dims[1] != W)
			mexErrMsgTxt("returning from assert fail");
	#endif

    //Interchange im1 and im2
    bufIm      = pD->bw_im2;
    pD->bw_im2 = pD->bw_im1;
    pD->bw_im1 = bufIm;
    bufImC      = pD->bw_im2C;
    pD->bw_im2C = pD->bw_im1C;
    pD->bw_im1C = bufImC;

    
	memcpy(pD->bw_im1.im, (uint8 *)mxGetData(prhs[0]), sizeof(uint8)*pD->bw_im1.dims[0]*pD->bw_im1.dims[1]);
    if (nrhs > 1  ){
        memcpy(pD->bw_im2.im, (uint8 *)mxGetData(prhs[1]), sizeof(uint8)*pD->bw_im2.dims[0]*pD->bw_im2.dims[1]);
    }
//    int bytes_to_copy;
//    int32 *start_of_pr;

    plhs[0] = mxCreateNumericArray(NDIMS,pD->dx_im.dims ,PRECMX,mxREAL); 
    pD->dx_im.im =(PREC *)mxGetData(plhs[0]);
	plhs[1] = mxCreateNumericArray(NDIMS,pD->dy_im.dims ,PRECMX,mxREAL); 
    pD->dy_im.im =(PREC *)mxGetData(plhs[1]);
	plhs[2] = mxCreateNumericArray(NDIMS,pD->dt_im.dims ,PRECMX,mxREAL); 
    pD->dt_im.im =(PREC *)mxGetData(plhs[2]);
    plhs[3] = mxCreateNumericArray(NDIMS,pD->dx_imC.dims,PRECMX,mxREAL); 
    pD->dx_imC.im =(PREC *)mxGetData(plhs[3]);
	plhs[4] = mxCreateNumericArray(NDIMS,pD->dy_imC.dims,PRECMX,mxREAL); 
    pD->dy_imC.im =(PREC *)mxGetData(plhs[4]);
	plhs[5] = mxCreateNumericArray(NDIMS,pD->dt_imC.dims,PRECMX,mxREAL); 
    pD->dt_imC.im =(PREC *)mxGetData(plhs[5]);
    
	//We are int the case of regular call, ie. no in-place data handling. thus:
	pD ->gradInd = 1;

    return SUCCESS;
}
//same as getData, but assigns output to the last input args, in-place fashion
int getData_ip(mxArray *plhs[], const mxArray **prhs, progData *pD, int nrhs)
{ 
    static image bufIm;
    static image bufImC;
	int W,Wc,H,Hc,nofDims;
	int *dims;

	//if debug, check that we have correct size of input
	#ifndef  NDEBUG
		assert(nrhs==7 || nrhs==8);

		int Wx,Wy,Wt,WxC,WyC,WtC,Hx,Hy,Ht,HxC,HyC,HtC;
		W   = (int)mxGetN(prhs[0]);	H   = (int)mxGetM(prhs[0]);	
		Wx  = (int)mxGetN(prhs[1]);	Hx  = (int)mxGetM(prhs[1]);	Wy  = (int)mxGetN(prhs[2]);	Hy  = (int)mxGetM(prhs[2]); Wt  = (int)mxGetN(prhs[3]);	Ht  = (int)mxGetM(prhs[3]);		
		WxC = (int)mxGetN(prhs[4]);	HxC = (int)mxGetM(prhs[4]);	WyC = (int)mxGetN(prhs[5]);	HyC = (int)mxGetM(prhs[5]);	WtC = (int)mxGetN(prhs[6]);	HtC = (int)mxGetM(prhs[6]);

//		mexPrintf("%d",pD->bw_im1.dims[1]);

		nofDims = (int)mxGetNumberOfDimensions(prhs[1]);
		dims =  (int*)mxGetDimensions(prhs[1]);

		if (nofDims > 2){
			Wx  = Wx/dims[2]; Wy  = Wy/dims[2]; Wt  = Wt/dims[2];
			WxC = WxC/dims[2];WyC = WyC/dims[2];WtC = WtC/dims[2];
		}

		assert(pD->bw_im1.dims[1]== W);  assert(pD->bw_im1.dims[0]== H);


		assert(pD->dx_im.dims[1]  == Wx);	assert(pD->dx_im.dims[0]  == Hx);		assert(pD->dy_im.dims[1]  == Wy);  assert(pD->dy_im.dims[0]  == Hy);
		assert(pD->dt_im.dims[1]  == Wt);	assert(pD->dt_im.dims[0]  == Ht);

		assert(pD->dx_imC.dims[1] == WxC);	assert(pD->dx_imC.dims[0] == HxC);		assert(pD->dy_imC.dims[1] == WyC); assert(pD->dy_imC.dims[0] == HyC);
		assert(pD->dt_imC.dims[1] == WtC);	assert(pD->dt_imC.dims[0] == HtC);
		if (nrhs==8){
			assert(mxGetN(prhs[7]) == 1); 
			assert(mxGetM(prhs[7]) == 1);
			assert( *(double*)mxGetData(prhs[7])    > 0);
		}

	#endif


    //Interchange im1 and im2
    bufIm      = pD->bw_im2;
    pD->bw_im2 = pD->bw_im1;
    pD->bw_im1 = bufIm;
    bufImC      = pD->bw_im2C;
    pD->bw_im2C = pD->bw_im1C;
    pD->bw_im1C = bufImC;

    
	memcpy(pD->bw_im1.im, (uint8 *)mxGetData(prhs[0]), sizeof(uint8)*pD->bw_im1.dims[0]*pD->bw_im1.dims[1]);
    
	  mxUnshareArray((mxArray*) prhs[1], true);
	  mxUnshareArray((mxArray*) prhs[2], true);
	  mxUnshareArray((mxArray*) prhs[3], true);
	  mxUnshareArray((mxArray*) prhs[4], true);
	  mxUnshareArray((mxArray*) prhs[5], true);
	  mxUnshareArray((mxArray*) prhs[6], true);
	  
	if (nrhs==8)
	  pD ->gradInd = (int)(*(double*)mxGetData(prhs[7]));
	else
	  pD ->gradInd = 1;
	
	W  = (int)mxGetN(prhs[1]);	H  = (int)mxGetM(prhs[1]);	
	Wc = (int)mxGetN(prhs[4]);	Hc = (int)mxGetM(prhs[4]);	
	nofDims = (int)mxGetNumberOfDimensions(prhs[1]);
	dims =  (int*)mxGetDimensions(prhs[1]);


    pD->dx_im.im  =(PREC *)mxGetData((mxArray*) prhs[1]) + (pD->gradInd-1)*W*H/dims[2];
    pD->dy_im.im  =(PREC *)mxGetData((mxArray*) prhs[2]) + (pD->gradInd-1)*W*H/dims[2];
    pD->dt_im.im  =(PREC *)mxGetData((mxArray*) prhs[3]) + (pD->gradInd-1)*W*H/dims[2];
    pD->dx_imC.im =(PREC *)mxGetData((mxArray*) prhs[4]) + (pD->gradInd-1)*Wc*Hc/dims[2];
    pD->dy_imC.im =(PREC *)mxGetData((mxArray*) prhs[5]) + (pD->gradInd-1)*Wc*Hc/dims[2];
    pD->dt_imC.im =(PREC *)mxGetData((mxArray*) prhs[6]) + (pD->gradInd-1)*Wc*Hc/dims[2];
    
    return SUCCESS;

}

int allocateMem(progData *pD, const mxArray **prhs, int nrhs)
{

	int W, H, WC, HC;

	#ifndef NDEBUG
	//will print typically only once per run of program
	mexPrintf("running debug-build \n");
	#endif
	//setup image sizes:

    W = (int)mxGetN(prhs[0]);
    H = (int)mxGetM(prhs[0]);
    
    pD->bw_im1.dims[1] = W;
    pD->bw_im1.dims[0] = H;
    pD->bw_im2.dims[1] = W;
    pD->bw_im2.dims[0] = H;    
    
    pD->dx_im.dims[1] = W-HFW*2;
    pD->dx_im.dims[0] = H-HFW*2;
    pD->dy_im.dims[1] = W-HFW*2;
    pD->dy_im.dims[0] = H-HFW*2;
    pD->dt_im.dims[1] = W-HFW*2;
    pD->dt_im.dims[0] = H-HFW*2;    

    WC = pD->bw_im1.dims[1]/2-1;
    HC = pD->bw_im1.dims[0]/2-1;
    
    pD->bw_im1C.dims[1] = WC;
    pD->bw_im1C.dims[0] = HC;
    pD->bw_im2C.dims[1] = WC;
    pD->bw_im2C.dims[0] = HC;
    
    pD->dx_imC.dims[1] = WC-HFW*2;
    pD->dx_imC.dims[0] = HC-HFW*2;
    pD->dy_imC.dims[1] = WC-HFW*2;
    pD->dy_imC.dims[0] = HC-HFW*2;
    pD->dt_imC.dims[1] = WC-HFW*2;
    pD->dt_imC.dims[0] = HC-HFW*2;    

	//allocate mem
	if (((pD->bw_im1.im  = (uint8 *)malloc(sizeof(uint8)*W*H)) == NULL )||
	   ( (pD->bw_im2.im  = (uint8 *)malloc(sizeof(uint8)*W*H)) == NULL )||
	   ( (pD->bw_im1C.im = (uint8 *)malloc(sizeof(uint8)*WC*HC)) == NULL )||
	   ( (pD->bw_im2C.im = (uint8 *)malloc(sizeof(uint8)*WC*HC)) == NULL ))
            return MALLOCFAIL;
	return SUCCESS;
}
int deAllocateMem(progData *pD)
{
    free(pD->bw_im1.im);
    free(pD->bw_im2.im);
    free(pD->bw_im1C.im);
    free(pD->bw_im2C.im);
    return 1;
}

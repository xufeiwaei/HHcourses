/*
% Authors:
% Stefan M. Karlsson AND Josef Bigun 

% Please reference the following publication:
% Stefan M. Karlsson AND Josef Bigun, Lip-motion events analysis and lip segmentation using optical flow. CVPR Workshops 2012: 138-145)
*/


#include "mex.h"
#include <assert.h>
#include <string.h>             // Needed for memcpy() 

//begin unshare.h from Peter Li
/* unshare.h
 * Ver 0.84
 * Peter H. Li 2011 FreeBSD License 
 */
extern "C" int mxUnshareArray(mxArray *array_ptr, int level);
//end unshare.h

// to change the precision, have one of these macros defined
#define PRECISCION_DOUBLE
//#define PRECISCION_FLOAT
//#define PRECISCION_INT32
// 	#define PRECISCION_INT16

//#ifdef PRECISCION_DOUBLE (default to double)
#define PREC   double
#define PRECMX mxDOUBLE_CLASS  //mxSINGLE_CLASS - float, mxDOUBLE_CLASS - double
#define OUTIM  imageD            //imageD, imageF

#ifdef PRECISCION_FLOAT
#define PREC   float 
#define PRECMX mxSINGLE_CLASS  //mxSINGLE_CLASS - float, mxDOUBLE_CLASS - double
#define OUTIM  imageF            //imageD, imageF
#endif

#ifdef PRECISCION_INT32
#define PREC   int32
#define PRECMX mxINT32_CLASS  //mxSINGLE_CLASS - float, mxDOUBLE_CLASS - double
#define OUTIM  image32            //imageD, imageF
#endif

#ifdef PRECISCION_INT16
#define PREC   int16
#define PRECMX mxINT16_CLASS  //mxSINGLE_CLASS - float, mxDOUBLE_CLASS - double
#define OUTIM  image16            //imageD, imageF
#endif


#define NDIMS           2       //X * Y

#define	SUCCESS			0
#define	MALLOCFAIL		-1
#define IMPROPERDIMS	-2

//#define INWIDTH         128
#define FW              3       //filterwidth, deriv
#define HFW             1       //half filterwidth, deriv

typedef unsigned char   uint8;
typedef int  			int32;
typedef short int  		int16;

typedef struct image{
	uint8	*im;
	int     dims[NDIMS];
}image;

typedef struct image16{
	int16	*im;
	int     dims[NDIMS];    
}image16;


typedef struct image32{
	int32	*im;
	int     dims[NDIMS];    
}image32;

typedef struct imageF{
	float	*im;
	int     dims[NDIMS];
}imageF;

typedef struct imageD{
	double	*im;
	int     dims[NDIMS];
}imageD;

typedef struct progData{
        image bw_im1;
        image bw_im2; 
        image bw_im1C; 
        image bw_im2C; 
        OUTIM dx_im; 
        OUTIM dy_im; 
        OUTIM dt_im; 
        OUTIM dx_imC; 
        OUTIM dy_imC; 
        OUTIM dt_imC;
		int gradInd;
}progData;

int	gradCalc(mxArray *plhs[],progData *pD);  
int getData   (mxArray *plhs[], const mxArray **prhs, progData *pD, int nrhs);
int getData_ip(mxArray *plhs[], const mxArray **prhs, progData *pD, int nrhs);
int allocateMem(progData *pD, const mxArray **prhs, int nrhs);
int deAllocateMem(progData *pD);

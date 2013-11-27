load ChemTrainNew.mat;
X=XtrainDS;
Y=YtrainDS;

for i=1:65,

    CovXY = corrcoef(X(:,i),Y(:,1));
    Cov_XY(i,2) = CovXY(1,2);
    Cov_XY(i,1) = i;
    
end

[Corr_XY_rank index] = sortrows(abs(Cov_XY(:,2)),1);
Corr_XY_rank(:,2)=Corr_XY_rank;
Corr_XY_rank(:,1)=index;


for j=1:4
    n=index(66-j);
    figure, scatter(X(:,n),Y,10,[0 0 5],'b','filled');
    title(n);
    xlabel('Input');
    ylabel('Output');
end

index = flipdim(index,1);

%to fit the model use all features
mdl=LinearModel.fit(X,Y,'linear','robust','on');  
[B,SE,PVAL,INMODEL,STATS,NEXTSTEP,HISTORY]=stepwisefit(X,Y);
tbl=anova(mdl);
figure,plotDiagnostics(mdl,'cookd');

Xindex=double(INMODEL);
newXcount=0;
for loop1=1:65
    if(Xindex(loop1)==1)
        newXcount=newXcount+1;
        newX(newXcount)=loop1;
    end
end


for loop2=1:newXcount
    newXDS(:,loop2)=X(:,newX(loop2));
end

mdln=LinearModel.fit(newXDS,Y,'linear','robust','on');
tbln=anova(mdln);
figure,plotDiagnostics(mdln,'cookd');


%find the outlier with the Cook's Distance
figure,plotResiduals(mdln);
figure,plotResiduals(mdln,'probability');
figure,plotResiduals(mdln,'lagged');
figure,plotResiduals(mdln,'fitted');
outl1=find(mdln.Diagnostics.CooksDistance>0.004); 
outl2=find(mdln.Residuals.Raw>10);
outl3=find(mdln.Residuals.Raw<-10);
sizeoutl1=size(outl1,1);
sizeoutl2=size(outl2,1);
sizeoutl3=size(outl3,1);
sizeoutl=sizeoutl1+sizeoutl2+sizeoutl3;
for loop7=1:sizeoutl
    if(loop7==sizeoutl3)
        for loop8=1:sizeoutl2
            outl3(sizeoutl3+loop8)=outl2(loop8);
        end
    end
    if(loop7==sizeoutl3+sizeoutl2)
        for loop9=1:sizeoutl1
            outl3(sizeoutl3+loop9+sizeoutl2)=outl1(loop9);
        end
    end
end
outl3=sortrows(outl3,-1);
mdlf1=LinearModel.fit(newXDS,Y,'linear','robust','on','Exclude',outl3);
outl4=find(mdlf1.Diagnostics.CooksDistance>0.004); 
sizeoutl4=size(outl4,1);
sizeoutl3=size(outl3,1);
for loop14=1:sizeoutl4;
    outl3(sizeoutl3+loop14)=outl4(loop14);
end
outl3=sortrows(outl3,-1);
mdlf=LinearModel.fit(newXDS,Y,'linear','robust','on','Exclude',outl3);
tbln=anova(mdlf);
figure,plotDiagnostics(mdlf,'cookd');
axis([0 8*10^-3 0 4500])
figure,plotResiduals(mdlf);
figure,plotResiduals(mdlf,'probability');
figure,plotResiduals(mdlf,'lagged');
figure,plotResiduals(mdlf,'fitted');

%test model
testcount=0;
ncoefficients=double(mdlf.Coefficients);
for loop4=1:65
    if(Xindex(loop4)==1)
        testcount=testcount+1;
        newtest(testcount)=loop4;
    end
end
for loop5=1:testcount
    newtestDS(:,loop5)=XtestDS(:,newtest(loop5));
end
for loop6=1:2971
    Yresult(loop6)=ncoefficients(1,1)+newtestDS(loop6,:)*ncoefficients(2:35,1);
end
Yresult=Yresult';

%get the final Xtrain for the model

XtrainFDS=newXDS;
YtrainFDS=YtrainDS;
outl3count=1;
for loop10=4466:-1:1
    if(loop10==outl3(outl3count))
        XtrainFDS(loop10,:)=[];
        YtrainFDS(loop10,:)=[];        
        outl3count=outl3count+1;
    end
end

for loopfit=1:size(XtrainFDS(:,1))
    Yfitlinear(loopfit)=ncoefficients(1,1)+XtrainFDS(loopfit,:)*ncoefficients(2:35,1);
end
figure,plot(1:size(XtrainFDS(:,1)),Yfitlinear,'o',1:size(XtrainFDS(:,1)),YtrainFDS,'r.');
LinearMSE = CalMSE(Yfitlinear,YtrainFDS);

%cross validation
sizenewDS=size(newXDS,1);
ssef=crossval(@critfun1,XtrainFDS,YtrainFDS);
msef=sum(ssef)/sizenewDS;


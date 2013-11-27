%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%假设某种水泥在凝固时所释放的热量与水泥中的四种成分x1,x2,x3,x4有关，一共有13组观测数据，最小二乘法进行回归 
%求得x1,x2,x3,x4与y之间的关系
function [bk,yk,xz]=linghuigui(Y,X,K)
%获得未经中心化和标准化（单位化）处理的数据
x=X;
y=Y;
k=K;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%对数据进行中心化和标准化
[n,p]=size(x);
rmx=mean(x);rmy=mean(y);
rstdx=std(x);rstdy=std(y);
for i=1:1:n
    mx(i,:)=rmx;
    %my(i,:)=rmy;
    stdx(i,:)=rstdx;
    %stdy(i,:)=rstdy;
end
xz=(x-mx)./stdx;
%yz=(y-my)./stdy
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%xz=x;
yz=y;


xzt=xz';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%用矩阵变换的方法来求拟合系数bk, 
%pseudo = sqrt(k) * eye(p);
%Zplus  = [xz;pseudo];
%yplus  = [yz;zeros(p,1)];
%bk = Zplus\yplus;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
bk=inv(xzt*xz+k*eye(p))*xzt*yz;    %直接求拟合系数，与上面的方法等效
syms x1 x2 x3 x4 yn
yk=mean(y)+bk(1)*x1+bk(2)*x2+bk(3)*x3+bk(4)*x4 ;               %拟合后的表达式
yk=vpa(yn,5);                                           %设置拟合后的表达式的有效数字位数
%H=x*inv(xt*x)*xt;          %帽子矩阵
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
    
    


    
        
        
    
     




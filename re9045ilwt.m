
function X=re9045ilwt(aL,aH,hL,hH,vL,vH,dL,dH)

 a=finaliftidwt1b33(aL,aH) ;

h=finaliftidwt1b33(hL,hH) ;

v=finaliftidwt1b33(vL,vH) ;
d=finaliftidwt1b33(dL,dH) ;
 a=a';
h=h';
v=v';d=d';x =  liftup0451b33(a,h);
   
         x1 =  liftup0451b33(v,d);x =x';
x1=x1';
X=finaliftidwt1b33(x,x1) ;

X=imrotate(X,-90);

%      X=X(7:14,7:14);     
  
        


function X=re045ilwt(aL,aH,hL,hH,vL,vH,dL,dH)


   a=finaliftidwt1b33(aL,aH) ;

h=finaliftidwt1b33(hL,hH) ;

v=finaliftidwt1b33(vL,vH) ;
d=finaliftidwt1b33(dL,dH) ;

% a=imrotate(a,90);
% h=imrotate(h,90);
% v=imrotate(v,90);
% d=imrotate(d,90);

   x =  liftup0451b33(a,h);
   
         x1 =  liftup0451b33(v,d);
          
         
         X=finaliftidwt1b33(x,x1) ;
         
         X=X';
     X=imrotate(X,-90);
%      X=X(7:14,7:14);
         
% x=x(3:19,3:19);
%  jj=zeros(sii,sii);
%             s=size(jj);
%              x = wkeep2(x,s);
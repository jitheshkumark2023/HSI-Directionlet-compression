function X=finaliftidwt1b33(zL,zH)
[rowp,colp]=size(zL);

for i=1:rowp
    xx=(colp/2)+1;
   if (rem(i,2)==0 )
       
     ZLL1(2:1:xx)=  zL(i,2:2:colp);
     ZLL1(1)=  zL(i,1);
       ZHH1(1)=  zH(i,1);
       ZHH1(2:1:xx)=  zH(i,2:2:colp);
       xx=ilwtt2b33(ZLL1,ZHH1);
       X(i,1:1:colp)=xx(2:1:colp+1);
   else
 zoL1(1:1:colp/2)=zL(i,1:2:colp);
 zoH1(1:1:colp/2)=zH(i,1:2:colp);
X(i,1:1:colp)=ilwtt2b33(zoL1,zoH1);
   end
end
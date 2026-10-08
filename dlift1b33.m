function [zL,zH]=dlift1b33(patchin)

[ rowp,colp]=size(patchin);

xx=colp;
 for i=1:rowp
     zL(i,1:xx)=0;
     zH(i,1:xx)=0;
     if (rem(i,2)==0 )
     patchin2(2:xx+1)=patchin(i,1:xx);
     patchin2(xx+2)=0;
   [ezL1,ezH1] =lwtt2b33(patchin2);
    xxx=(xx/2)+1;
    
     zH(i,2:2:xx)=ezH1(2:1:xxx);
   zL(i,2:2:xx)=ezL1(2:1:xxx);
   zH(i,1)=ezH1(1);
    zL(i,1)=ezL1(1);
     else
      [zL1(i,:),zH1(i,:)] =lwtt2b33(patchin(i,:));
      zH(i,1:2:xx)=zH1(i,1:1:xx/2);
      zL(i,1:2:xx)=zL1(i,1:1:xx/2); 
      
     end
    
 end
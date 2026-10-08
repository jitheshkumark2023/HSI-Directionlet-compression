function [aL,aH,hL,hH,vL,vH,dL,dH]=subdwt090lift11b33(A)

patchin=A;
 [ rowp,colp]=size(patchin);
 
 for i=1:rowp
   [ zL(i,:),zH(i,:)] = lwtt2b33(patchin(i,:));
 end
 
 [o,u]=size(zH);
   
    tzL=zL'; 
%     
     [ rowzL,colzL]=size(tzL);
    
     for i=1:rowzL
   [zLL(i,:),zLH(i,:)] = lwtt2b33(tzL(i,:));
     end
 
     
   a=zLL'   ; 
  
      
  h=zLH';  
%   
%   
  tzH=zH'; 
%     
   [ rowzH,colzH]=size(tzH);
%     
     for i=1:rowzH
   [zHL(i,:),zHH(i,:)] = lwtt2b33(tzH(i,:));
     end
 
      
   v=zHL'; 
 
   d=zHH'; 
    
 
%   find next filtering a
[rowa,cola]=size(a);
 for i=1:rowa
  [ aL(i,:),aH(i,:)] =lwtt2b33(a(i,:));
  [hL(i,:),hH(i,:)] =lwtt2b33(h(i,:));
  [vL(i,:),vH(i,:)] =lwtt2b33(v(i,:));
  [dL(i,:),dH(i,:)] =lwtt2b33(d(i,:));
 end
 [row1,col1]=size(aH);
 
 
  if rem(row1,2)==1
      
   aH(:,col1+1)=0;
 hH(:,col1+1)=0;
    vH(:,col1+1)=0;
 dH(:,col1+1)=0;
  end
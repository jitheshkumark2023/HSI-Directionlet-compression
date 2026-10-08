function  [aL,aH,hL,hH,vL,vH,dL,dH] =dirdwt0m45lift11b33(A)
patchin=A;
%  [ rowp,colp]=size(patchin);
 
 
 
[zL,zH]=dlift1b33(patchin);

  [a,h]=lift045ah1b33(zL);
 [v,d]=lift045ah1b33(zH);
 

   
 [aL,aH]=dlift1b33(a);
  [hL,hH]=dlift1b33(h);
  
  [vL,vH]=dlift1b33(v);
  [dL,dH]=dlift1b33(d);

   
    
      
      

       
       
       
    

     
     
     
 
  
  
  
  
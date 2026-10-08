function x=nsubidwt090liftb33(aL,aH,hL,hH,vL,vH,dL,dH)
  a=  waveupsliftb33(aL,aH) ;
   h =  waveupsliftb33(hL,hH) ;
   
   v =  waveupsliftb33(vL,vH); 
   d =  waveupsliftb33(dL,dH); 

   x5 =  waveupsliftb33(a',h') ;
   x6 =  waveupsliftb33(v',d') ;
   
   x=waveupsliftb33(x5',x6') ;
   
%    x=x(7:14,7:14);
  
  
   
   
%    x=x(7:14,7:14);

 
% x=x(3:19,3:19);
%  jj=zeros(sii,sii);
%             s=size(jj);
%              x = wkeep2(x,s);
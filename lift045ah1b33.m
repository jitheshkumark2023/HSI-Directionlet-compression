function[a,h]=lift045ah1b33(zL)


zL=imrotate(zL,90);
       
     [ ro,co]=size(zL);
    
      
       SIZ=[ ro,co];
     
     [output,X1,nol] = zigzag1(zL);
    [ rowzL,colzL]=size(X1);
   
     f=1;
     
    
  
    lll=1;
      for i=1:1:rowzL
      le= nol(f); 
     
    
     
   [zLL1,zHH1] = lwtt2b33(X1(i,1:le));
   zzLL1=zLL1;
   zzHH1=zHH1;
    zz1(1:le)=0;
   bb=length(zzLL1);
   oo=length(zHH1);
   zz1(1:2:le)=zzLL1(1:1:bb);
   zz2(1:le)=0;
   if oo>0
   zz2(1:2:2*oo)=zHH1(1:1:oo);
   end      
    
   
     f=f+1;

    
    
    
    if (rem(i,2)==0)
    
    rec(lll:lll+le-1)=zz1(1+le-1:-1:1);
rec1(lll:lll+le-1)=zz2(1+le-1:-1:1);

   else

    rec(lll:lll+le-1)=zz1(1:1+le-1);
 rec1(lll:lll+le-1)=zz2(1:1+le-1);
   end   
     lll=lll+le;
    
    clear zz1 zz2 
   end
      
%  rec ;    
    a= izigzag(rec,ro, co);
    h= izigzag(rec1,ro, co);
    a=imrotate(a,-90);
    h=imrotate(h,-90);
    
function y = liftup0451b33(x1,x2)

ny=imrotate(x1,90);
   ny1=imrotate(x2,90);
 
 
           [rowy,coly]=size(ny);
           
             [output,y,ol1] = zigzag1(ny);
             
             [output,y1,ol2] = zigzag1(ny1);
             
         
             
             
%              [z1,z2]=size(X2);
             
%              
%              y=X2;
% y1=X3;
 
 
 
        lll=1;
       
       
       
       
            [ rowp,colp]=size(y);
         
         
             for i=1:1:rowp
                 
               
               op=ol1(i) ;
               ke= ol2(i);
               if (rem(i,2)==0)
               CL=y(i,1:2:op);
               CH=y1(i,1:2:ke);
             
%                 z1L(1:lenn)=0;
   z1L = ilwtt2b33(CL,CH);
               else
                   
%                    ro=round(op/2);
                   CL=y(i,1:2:op);
                   CH=y1(i,1:2:op-1);
                   z1L = ilwtt2b33(CL,CH);
                   
               
               
               
               
               end
   
   if (rem(i,2)==0)
   
   recc(lll:lll+op-1)=z1L(1+op-1:-1:1);
   else
       
    recc(lll:lll+op-1)=z1L(1:1+op-1);
   end  
   lll=lll+op;
 
             end
%               kll1=length(recc);
             
%             ro=rowy;
%             co=coly;
     out = izigzag(recc,rowy, coly);
       
         y=out ;
         
%          
      y=imrotate(y,-90);  
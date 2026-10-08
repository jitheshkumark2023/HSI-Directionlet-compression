% Zigzag scan of a matrix
% Argument is a two-dimensional matrix of any size,
% not strictly a square one.
% Function returns a 1-by-(m*n) array,
% where m and n are sizes of an input matrix,
% consisting of its items scanned by a zigzag method.
%
% Alexey S. Sokolov a.k.a. nICKEL, Moscow, Russia
% June 2007
% alex.nickel@gmail.com

function [output,X1,nol] = zigzag1(in)

% initializing the variables
%----------------------------------
h = 1;
v = 1;

vmin = 1;
hmin = 1;

vmax = size(in, 1);
hmax = size(in, 2);

i = 1;
sd=hmax+vmax-1;
X=zeros(sd,sd);
X1=zeros(sd,vmax);
nol(1,sd)=0;
st=1;
output = zeros(1, vmax * hmax);
%----------------------------------
nn=0;
while ((v <= vmax) & (h <= hmax))
 
    if (mod(h + v, 2) == 0)                 % going up

        if (v == vmin)      
            output(i) = in(v, h);        % if we got to the first line
nn=nn+1;
ele(nn)=in(v, h);

gg=round(nn/2);
    vb=round(sd/2);
    fg=vb-gg+1;
     
      X(st,fg:(fg+nn-1))=ele(1:nn);
        X1(st,1:nn)=ele(1:nn);
       nol(st)=nn;
      st=st+1;
     
nn=0;
            if (h == hmax)
           
     v = v + 1;
   else
              h = h + 1;
             
            end;

            i = i + 1;
           
        elseif ((h == hmax) & (v < vmax))   % if we got to the last column
            output(i) = in(v, h);
             nn=nn+1;
            ele(nn)=in(v, h);
           
            gg=round(nn/2);
    vb=round(sd/2);
    fg=vb-gg+1;
     
      X(st,fg:(fg+nn-1))=ele(1:nn);
      X1(st,1:nn)=ele(1:nn);
      nol(st)=nn;
      st=st+1;
nn=0;
           
           
            v = v + 1;
            i = i + 1;
           

        elseif ((v > vmin) & (h < hmax))    % all other cases
            output(i) = in(v, h);
              nn=nn+1;
            ele(nn)=in(v, h);
            v = v - 1;
            h = h + 1;
            i = i + 1;
     end;
     
   
    else                                    % going down

       if ((v == vmax) & (h <= hmax))
       
           % if we got to the last line
            output(i) = in(v, h);
             nn=nn+1;
            ele(nn)=in(v, h);
            h = h + 1;
            i = i + 1;
            ele(1:nn);
            j=0;
    for b=nn:-1:1
       j=j+1;
     ele1(j)=ele(b);
    end
           
              gg=round(nn/2);
    vb=round(sd/2);
    fg=vb-gg+1;
     
      X(st,fg:(fg+nn-1))=ele1(1:nn);
      X1(st,1:nn)=ele1(1:nn);
      nol(st)=nn;
      st=st+1;
     
     
    ele(1:nn) ;
    nn=0;
       
       elseif (h == hmin)  
           
           % if we got to the first column
            output(i) = in(v, h);
 nn=nn+1;
            ele(nn)=in(v, h);
           
            j=0;
    for b=nn:-1:1
       j=j+1;
     ele1(j)=ele(b);
    end
           
            gg=round(nn/2);
    vb=round(sd/2);
    fg=vb-gg+1;
     
      X(st,fg:(fg+nn-1))=ele1(1:nn);
     
      X1(st,1:nn)=ele1(1:nn);
      nol(st)=nn;
      st=st+1;
     
     
    ele(1:nn) ;
    nn=0;
           
            if (v == vmax)
               
     h = h + 1;
            else
           
              v = v + 1;
            end;

            i = i + 1;

       elseif ((v < vmax) & (h > hmin))     % all other cases
            output(i) = in(v, h);
             nn=nn+1;
            ele(nn)=in(v, h);
            v = v + 1;
            h = h - 1;
            i = i + 1;
        end;

    end;

    if ((v == vmax) & (h == hmax))          % bottom right element
        output(i) = in(v, h);
        nn=nn+1;
             ele(nn)=in(v, h);

gg=round(nn/2);
    vb=round(sd/2);
    fg=vb-gg+1;
    j=0;
    for b=nn:-1:1
       j=j+1;
     ele1(j)=ele(b);
    end
      X(st,fg:(fg+nn-1))=ele1(1:nn);
      X1(st,1:nn)=ele1(1:nn);
      nol(st)=nn;
     
      st=st+1;
nn=0;
        break
    end;
 
     
end;
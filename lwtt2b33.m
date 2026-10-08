function varargout = lwtt2b33(x,varargin)
LS = liftwave('bior3.3');
 NBL = size(LS,1);
lx = length(x);
% firstIdxAPP = 1;
% firstIdxDET = 1+mod(firstIdxAPP,2)
idxAPP = 1:2:lx;
idxDET = 2:2:lx;
lenAPP = length(idxAPP);
lenDET = length(idxDET);
% Lifting.

LStype = LS{NBL,3};
for k = 1:NBL-1
    liftTYPE = LS{k,1};
    liftFILT = LS{k,2};
    DF       = LS{k,3};
     
    
    switch liftTYPE
       case 'p' , 
           lF = length(liftFILT);
sx = size(x(idxDET));
y  = zeros(sx);

lx = length(x(idxDET));
      for j=1:lF
          
          t = liftFILT(j)*x(idxDET);
          k = DF-j+1 ;
          if     k>0 , t = t(1+k:end);
          
              t(end+k)= 0;
          elseif k<0 , t(1-k:end) = t(1:end+k); t(1:-k) = 0;
          end
           
          y = y + t(1:lx);
      end
      d = lenAPP-lx;
      if d>0 , y(end+d) = 0; elseif d<0 , y = y(1:lenAPP); end
    if ~isempty(LStype) , y = fix(y); end

           x(idxAPP) = x(idxAPP) + y;
           clear y liftFILT  
       case 'd' , 
         lF = length(liftFILT);
sx = size(x(idxAPP));
y1  = zeros(sx);
% switch option
%   case 'v'
      
      lx = length(x(idxAPP));
      for j=1:lF
          
          t = liftFILT(j)*x(idxAPP);
          k = DF-j+1 ;
          if     k>0 , t = t(1+k:end);
          
              t(end+k)= 0;
          elseif k<0 , t(1-k:end) = t(1:end+k); t(1:-k) = 0;
          end
           
          y1 = y1 + t(1:lx);
      end
      d = lenDET-lx;
      if d>0 , y1(end+d) = 0; elseif d<0 , y1 = y1(1:lenDET); end
      if ~isempty(LStype) , y1 = fix(y1); end
           
           x(idxDET) = x(idxDET) + y1;
      clear y1 liftFILT         
    end
     
end

% Normalization.
if isempty(LStype)
   
    x(idxAPP) = LS{NBL,1}*x(idxAPP);
    x(idxDET) = LS{NBL,2}*x(idxDET);
end

 varargout = {x(idxAPP),x(idxDET)};
%   case 3 , varargout = {x,x(idxAPP),x(idxDET)};
% end

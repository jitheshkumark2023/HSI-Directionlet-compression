function y = waveupsliftb33(z1,z2)
        % Compute Upsampling and Convolution.
       
           
            [ rowp,colp]=size(z1);
             
           
            for i=1:rowp
%            
           Ky1(i,:) = ilwtt2b33(z1(i,:),z2(i,:));
           
            end
             y = Ky1;
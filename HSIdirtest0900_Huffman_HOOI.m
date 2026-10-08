clc;
clear;
close all;

%  HSI input

dataPath = ['D:\NEW FILES\image covariance sample\Cuprite.mat'];

S  = load(dataPath);
fn = fieldnames(S);

HSI3 = double(S.(fn{1}));

HSI = HSI3(1:128,1:128,1:20);
[S1,S2,S3] = size(HSI);

fprintf('Original HSI size: %d x %d x %d\n',S1,S2,S3);

bitsPerSample = 16;

orig_bits = S1*S2*S3*bitsPerSample;

%   START COMPRESSION TIMER

tic;

%  INITIAL LDWT 

img0 = HSI(:,:,1);
[DirVar, dominant_angles] = covariance_function_hsi(img0);
dominant_angle=dominant_angles(1)+dominant_angles(2);
fprintf('%d degree\n', dominant_angle);
switch dominant_angle
    case 45
        [ll0,ll1,lh0,lh1,hl0,hl1,hh0,hh1] = dirlift045dwtt1b33(img0);
    case 90
         [ll0,ll1,lh0,lh1,hl0,hl1,hh0,hh1] = subdwt090lift11b33(img0);
    case 135
        [ll0,ll1,lh0,lh1,hl0,hl1,hh0,hh1] = dirdwt9045lift11b33(img0);
    case 315
        [ll0,ll1,lh0,lh1,hl0,hl1,hh0,hh1] = dirdwt0m45lift11b33(img0);
    case 355
        [ll0,ll1,lh0,lh1,hl0,hl1,hh0,hh1] = subdwt090lift11b33(img0);
    case 405
        [ll0,ll1,lh0,lh1,hl0,hl1,hh0,hh1] = dirdwt90m45lift11b33(img0);
end

[r2,c2] = size(ll0)
[r3,c3] = size(ll1)

%  Allocate Memory

AL = zeros(r2,c2,S3);
AH = zeros(r3,c3,S3);

HL = zeros(r2,c2,S3);
HH = zeros(r3,c3,S3);

VL = zeros(r2,c2,S3);
VH = zeros(r3,c3,S3);

DL = zeros(r2,c2,S3);
DH = zeros(r3,c3,S3);

%  Store First Band

AL(1:r2,1:c2,1) = ll0;
AH(1:r3,1:c3,1) = ll1;

HL(1:r2,1:c2,1) = lh0;
HH(1:r3,1:c3,1) = lh1;

VL(1:r3,1:c3,1) = hl0;
VH(1:r3,1:c3,1) = hl1;

DL(1:r3,1:c3,1) = hh0;
DH(1:r3,1:c3,1) = hh1;


%  Remaining Bands

for k = 2:S3

    img = HSI(:,:,k);
 switch dominant_angle
    case 45
        [aL0,aH0,hL0,hH0,vL0,vH0,dL0,dH0] = dirlift045dwtt1b33(img);
    case 90
         [aL0,aH0,hL0,hH0,vL0,vH0,dL0,dH0] = subdwt090lift11b33(img);
    case 135
        [aL0,aH0,hL0,hH0,vL0,vH0,dL0,dH0] = dirdwt9045lift11b33(img);
    case 315
        [aL0,aH0,hL0,hH0,vL0,vH0,dL0,dH0] = dirdwt0m45lift11b33(img);
    case 355
        [aL0,aH0,hL0,hH0,vL0,vH0,dL0,dH0] = subdwt090lift11b33(img);
    case 405
        [aL0,aH0,hL0,hH0,vL0,vH0,dL0,dH0] = dirdwt90m45lift11b33(img);
end 

    % Dimension Checks
    assert(isequal(size(aL0),[r2 c2]),'aL size mismatch');
    assert(isequal(size(hL0),[r2 c2]),'hL size mismatch');
    assert(isequal(size(vL0),[r3 c3]),'vL size mismatch');
    assert(isequal(size(dL0),[r3 c3]),'dL size mismatch');

    AL(1:r2,1:c2,k) = aL0;
    AH(1:r3,1:c3,k) = aH0;

    HL(1:r2,1:c2,k) = hL0;
    HH(1:r3,1:c3,k) = hH0;

    VL(1:r3,1:c3,k) = vL0;
    VH(1:r3,1:c3,k) = vH0;

    DL(1:r3,1:c3,k) = dL0;
    DH(1:r3,1:c3,k) = dH0;

end

disp('2D directional LWT completed');
%  Tucker Parameters
%% =========================================================

% QaL = [35 30 12];
% QhL = [25 25 10];
% QvL = [25 25 10];
% QdL =[30 30 12];
% 
% QaH = [35 30 12];
% QhH = [25 25 10];
% QvH =  [25 25 10];
% QdH = [30 30 12];

QaL = [45 25 10];
QhL = [20 20 8];
QvL = [20 20 8];
QdL =[30 25 10];

QaH = [45 25 10];
QhH = [20 20 8];
QvH =  [20 20 8];
QdH = [30 25 10];
% QaL = [40 40 15];
% QhL = [25 25 10];
% QvL = [25 25 10];
% QdL =[30 30 12];
% 
% QaH = [35 35 15];
% QhH = [25 25 10];
% QvH =  [25 25 10];
% QdH = [30 30 12];
maxIter = 25;
tol = 1e-4;


%  Tucker Decomposition via HOOI

[Acore2,UA1,UA2,UA3] = tucker_hooi(AL,QaL,maxIter,tol);

[Hcore2,UH1,UH2,UH3] = tucker_hooi(HL,QhL,maxIter,tol);

[Vcore2,UV1,UV2,UV3] = tucker_hooi(VL,QvL,maxIter,tol);

[Dcore2,UD1,UD2,UD3] = tucker_hooi(DL,QdL,maxIter,tol);

[Acore3,UA4,UA5,UA6] = tucker_hooi(AH,QaH,maxIter,tol);

[Hcore3,UH4,UH5,UH6] = tucker_hooi(HH,QhH,maxIter,tol);

[Vcore3,UV4,UV5,UV6] = tucker_hooi(VH,QvH,maxIter,tol);

[Dcore3,UD4,UD5,UD6] = tucker_hooi(DH,QdH,maxIter,tol);

%  Quantization

qStep = 1;

Aq2 = round(Acore2/qStep);
Hq2 = round(Hcore2/qStep);
Vq2 = round(Vcore2/qStep);
Dq2 = round(Dcore2/qStep);

Aq3 = round(Acore3/qStep);
Hq3 = round(Hcore3/qStep);
Vq3 = round(Vcore3/qStep);
Dq3 = round(Dcore3/qStep);

%  Huffman Encoding

[Astream,   Asym,   Acodes]   = huffman_encode(Aq2(:)');
[Hstream,   Hsym,   Hcodes]   = huffman_encode(Hq2(:)');
[Vstream,   Vsym,   Vcodes]   = huffman_encode(Vq2(:)');
[Dstream,   Dsym,   Dcodes]   = huffman_encode(Dq2(:)');

[Astream2,  Asym2,  Acodes2]  = huffman_encode(Aq3(:)');
[Hstream2,  Hsym2,  Hcodes2]  = huffman_encode(Hq3(:)');
[Vstream2,  Vsym2,  Vcodes2]  = huffman_encode(Vq3(:)');
[Dstream2,  Dsym2,  Dcodes2]  = huffman_encode(Dq3(:)');

%  Compression Bit Estimation

comp_bits = ...
    numel(Astream ) + numel(Hstream ) + numel(Vstream ) + numel(Dstream ) + ...
    numel(Astream2) + numel(Hstream2) + numel(Vstream2) + numel(Dstream2);

%  Huffman Decoding

Aq2 = reshape(huffman_decode(Astream, Asym, Acodes, numel(Aq2)), size(Aq2))*qStep;
Hq2 = reshape(huffman_decode(Hstream, Hsym, Hcodes, numel(Hq2)), size(Hq2))*qStep;
Vq2 = reshape(huffman_decode(Vstream, Vsym, Vcodes, numel(Vq2)), size(Vq2))*qStep;
Dq2 = reshape(huffman_decode(Dstream, Dsym, Dcodes, numel(Dq2)), size(Dq2))*qStep;

Aq3 = reshape(huffman_decode(Astream2, Asym2, Acodes2, numel(Aq3)), size(Aq3))*qStep;
Hq3 = reshape(huffman_decode(Hstream2, Hsym2, Hcodes2, numel(Hq3)), size(Hq3))*qStep;
Vq3 = reshape(huffman_decode(Vstream2, Vsym2, Vcodes2, numel(Vq3)), size(Vq3))*qStep;
Dq3 = reshape(huffman_decode(Dstream2, Dsym2, Dcodes2, numel(Dq3)), size(Dq3))*qStep;

%  Tucker Reconstruction

Arec = tucker_reconstruct(Aq2,UA1,UA2,UA3,[r2 c2 S3]);

Hrec = tucker_reconstruct(Hq2,UH1,UH2,UH3,[r2 c2 S3]);

Vrec = tucker_reconstruct(Vq2,UV1,UV2,UV3,[r2 c2 S3]);

Drec = tucker_reconstruct(Dq2,UD1,UD2,UD3,[r2 c2 S3]);

Arec2 = tucker_reconstruct(Aq3,UA4,UA5,UA6,[r2 c2 S3]);

Hrec2 = tucker_reconstruct(Hq3,UH4,UH5,UH6,[r2 c2 S3]);

Vrec2 = tucker_reconstruct(Vq3,UV4,UV5,UV6,[r2 c2 S3]);

Drec2 = tucker_reconstruct(Dq3,UD4,UD5,UD6,[r2 c2 S3]);


%  Inverse DWT Reconstruction


HSI_rec = zeros(S1,S2,S3);

for k = 1:S3
switch dominant_angle
    case 45
        band_full = re045ilwt( ...
        Arec(:,:,k),  Arec2(:,:,k), ...
        Hrec(:,:,k),  Hrec2(:,:,k), ...
        Vrec(:,:,k),  Vrec2(:,:,k), ...
        Drec(:,:,k),  Drec2(:,:,k));
    case 90
         band_full = nsubidwt090liftb33( ...
        Arec(:,:,k),  Arec2(:,:,k), ...
        Hrec(:,:,k),  Hrec2(:,:,k), ...
        Vrec(:,:,k),  Vrec2(:,:,k), ...
        Drec(:,:,k),  Drec2(:,:,k));
    case 135
        band_full = re9045ilwt( ...
        Arec(:,:,k),  Arec2(:,:,k), ...
        Hrec(:,:,k),  Hrec2(:,:,k), ...
        Vrec(:,:,k),  Vrec2(:,:,k), ...
        Drec(:,:,k),  Drec2(:,:,k));
    case 315
        band_full = re0m45ilwt( ...
        Arec(:,:,k),  Arec2(:,:,k), ...
        Hrec(:,:,k),  Hrec2(:,:,k), ...
        Vrec(:,:,k),  Vrec2(:,:,k), ...
        Drec(:,:,k),  Drec2(:,:,k));
    case 355
        band_full = nsubidwt090liftb33( ...
        Arec(:,:,k),  Arec2(:,:,k), ...
        Hrec(:,:,k),  Hrec2(:,:,k), ...
        Vrec(:,:,k),  Vrec2(:,:,k), ...
        Drec(:,:,k),  Drec2(:,:,k));
    case 405
        band_full  = re90m45ilwtb33( ...
        Arec(:,:,k),  Arec2(:,:,k), ...
        Hrec(:,:,k),  Hrec2(:,:,k), ...
        Vrec(:,:,k),  Vrec2(:,:,k), ...
        Drec(:,:,k),  Drec2(:,:,k));
end
    

    HSI_rec(:,:,k) = band_full(1:S1,1:S2);

end

%  Metrics

mse = mean((HSI(:)-HSI_rec(:)).^2);

MAX_I = max(HSI(:));

psnr_val = 10*log10((MAX_I^2)/mse);

% %% =========================================================
% % SSIM
% %% =========================================================
% 
% ssim_vals = zeros(S3,1);
% 
% for k = 1:S3
%     ssim_vals(k) = ssim(HSI_rec(:,:,k),HSI(:,:,k));
% end
% 
% mean_ssim = mean(ssim_vals);
% 
% %% =========================================================
% % SAM
% %% =========================================================
% 
% sam_sum = 0;
% count = 0;
% 
% for i = 1:S1
%     for j = 1:S2
% 
%         orig_spec = squeeze(HSI(i,j,:));
%         rec_spec  = squeeze(HSI_rec(i,j,:));
% 
%         num = dot(orig_spec,rec_spec);
%         den = norm(orig_spec)*norm(rec_spec);
% 
%         if den > 0
% 
%             angle = acos(max(min(num/den,1),-1));
% 
%             sam_sum = sam_sum + angle;
%             count = count + 1;
% 
%         end
%     end
% end
% 
% SAM_rad = sam_sum/count;
% SAM_deg = SAM_rad*180/pi;

CR = orig_bits/comp_bits;
bpp = comp_bits/(S1*S2*S3);

comp_time = toc;

%  Display Results

fprintf('\n==== PERFORMANCE METRICS ====\n');

fprintf('MSE                      : %.6f\n',mse);

fprintf('PSNR (dB)                : %.3f\n',psnr_val);

% fprintf('Average SSIM             : %.6f\n',mean_ssim);
% 
% fprintf('SAM (degrees)            : %.6f\n',SAM_deg);

fprintf('Original bits            : %.0f\n',orig_bits);

fprintf('Compressed bits          : %.0f\n',comp_bits);

fprintf('Compression Ratio (CR)   : %.4f\n',CR);

fprintf('Bits per pixel per band  : %.5f\n',bpp);

fprintf('Compression time (s)     : %.4f\n',comp_time);

%  Visualization

% band_show = 1;
%
% figure;

% subplot(1,2,1);
% imagesc(HSI(:,:,band_show));
% axis image off;
% % colormap gray;
% title('Original');
%
% subplot(1,2,2);
% imagesc(HSI_rec(:,:,band_show));
% axis image off;
% colormap gray;
% title('Reconstructed');
R = 20;
G = 10;
B = 5;

RGB_original = cat(3, HSI(:,:,R), HSI(:,:,G), HSI(:,:,B));
RGB_reconstructed = cat(3, HSI_rec(:,:,R), HSI_rec(:,:,G), HSI_rec(:,:,B));

% Normalize for display
RGB_original = mat2gray(RGB_original);
RGB_reconstructed = mat2gray(RGB_reconstructed);

figure;

subplot(1,2,1)
imshow(RGB_original)
title('Original RGB Image')

subplot(1,2,2)
imshow(RGB_reconstructed)
title('Reconstructed RGB Image')

%% =========================================================
%  FUNCTIONS
%% =========================================================

function [G,U1,U2,U3] = tucker_hooi(X,Q,maxIter,tol)
% Tucker decomposition via Higher-Order Orthogonal Iteration (HOOI).


[I1,I2,I3] = size(X);

Q1 = min(Q(1),I1);
Q2 = min(Q(2),I2);
Q3 = min(Q(3),I3);

%% Initialization

X1 = reshape(X,I1,[]);
[U1,~,~] = svd(X1,'econ');
U1 = U1(:,1:Q1);

X2 = reshape(permute(X,[2 1 3]),I2,[]);
[U2,~,~] = svd(X2,'econ');
U2 = U2(:,1:Q2);

X3 = reshape(permute(X,[3 1 2]),I3,[]);
[U3,~,~] = svd(X3,'econ');
U3 = U3(:,1:Q3);

prevErr = inf;

for it = 1:maxIter

    Z = nmode_prod(nmode_prod(X,U2',2),U3',3);

    [U1,~,~] = svd(reshape(Z,I1,[]),'econ');
    U1 = U1(:,1:Q1);

    Z = nmode_prod(nmode_prod(X,U1',1),U3',3);

    [U2,~,~] = svd(reshape(permute(Z,[2 1 3]),I2,[]),'econ');
    U2 = U2(:,1:Q2);

    Z = nmode_prod(nmode_prod(X,U1',1),U2',2);

    [U3,~,~] = svd(reshape(permute(Z,[3 1 2]),I3,[]),'econ');
    U3 = U3(:,1:Q3);

    G = nmode_prod( ...
        nmode_prod( ...
        nmode_prod(X,U1',1),U2',2),U3',3);

    Xhat = nmode_prod( ...
           nmode_prod( ...
           nmode_prod(G,U1,1),U2,2),U3,3);

    err = norm(X(:)-Xhat(:))/norm(X(:));

    if abs(prevErr-err) < tol
        break;
    end

    prevErr = err;

end

end

% =========================================================

function Xrec = tucker_reconstruct(G,U1,U2,U3,sz)

Xrec = nmode_prod( ...
       nmode_prod( ...
       nmode_prod(G,U1,1),U2,2),U3,3);

Xrec = reshape(Xrec,sz);

end

% =========================================================

function Y = nmode_prod(X,U,mode)

[I1,I2,I3] = size(X);

switch mode

    case 1

        Y = reshape(U*reshape(X,I1,[]),[],I2,I3);

    case 2

        Y = permute( ...
            reshape(U*reshape(permute(X,[2 1 3]),I2,[]), ...
            [],I1,I3), ...
            [2 1 3]);

    case 3

        Y = permute( ...
            reshape(U*reshape(permute(X,[3 1 2]),I3,[]), ...
            [],I1,I2), ...
            [2 3 1]);

end

end

% =========================================================

function [bits, symbols_unique, codewords] = huffman_encode(x)

    x = x(:);
    n = numel(x);

    if n == 0
        bits = false(0,1);
        symbols_unique = zeros(0,1);
        codewords = cell(0,1);
        return;
    end

    % Unique symbols and their frequencies
    [symbols_unique, ~, first_idx] = unique(x);
    counts_unique = accumarray(first_idx,1);
    num_syms = numel(symbols_unique);

    if num_syms == 1
        % Only one symbol present: assign a single-bit code (0)
        codewords = {false(1,1)};
        bits = false(n,1);
        return;
    end

    % Build Huffman tree by iteratively merging the two smallest nodes
    total_nodes = 2*num_syms - 1;
    wt   = zeros(total_nodes,1);   % weight
    par  = zeros(total_nodes,1);   % parent
    lch  = zeros(total_nodes,1);   % left child
    rch  = zeros(total_nodes,1);   % right child

    wt(1:num_syms) = counts_unique;

    active = (1:num_syms)';
    next_node = num_syms + 1;

    while numel(active) > 1

        [~, order] = sort(wt(active));
        active = active(order);

        n1 = active(1);
        n2 = active(2);

        par(n1) = next_node;
        par(n2) = next_node;
        lch(next_node) = n1;   % smaller weight as left child
        rch(next_node) = n2;
        wt(next_node) = wt(n1) + wt(n2);

        active = active(3:end);
        active(end+1,1) = next_node;

        next_node = next_node + 1;

    end

   % Derive codewords by walking each leaf up to the root 
    codewords = cell(num_syms,1);
    for i = 1:num_syms
        code = false(1,0);   % empty logical ROW vector
        node = i;
        while par(node) ~= 0
            p = par(node);
            if lch(p) == node
                code = [false code];   % 0 for left child
            else
                code = [true  code];   % 1 for right child
            end
            node = p;
        end
        codewords{i} = code;
    end

    % Encode the symbol stream 
    total_bits = 0;
    for i = 1:num_syms
        total_bits = total_bits + counts_unique(i)*numel(codewords{i});
    end

    bits = false(total_bits,1);
    bit_pos = 1;
    for i = 1:n
        sym_idx = first_idx(i);
        code = codewords{sym_idx};
        code_len = numel(code);
        for k = 1:code_len
            bits(bit_pos) = code(k);
            bit_pos = bit_pos + 1;
        end
    end

end

% =========================================================

function x = huffman_decode(bits, symbols_unique, codewords, n)

    if n == 0
        x = zeros(0,1);
        return;
    end

    num_syms = numel(symbols_unique);

    if num_syms == 1
        x = repmat(symbols_unique, n, 1);
        return;
    end

    % Pre-compute code lengths and sort codes by length (ascending).
    code_lens = zeros(num_syms,1);
    for j = 1:num_syms
        code_lens(j) = numel(codewords{j});
    end
    [sorted_lens, sort_idx] = sort(code_lens);
    sorted_codes   = codewords(sort_idx);
    sorted_symbols = symbols_unique(sort_idx);

    x = zeros(n,1);
    bit_pos = 1;
    num_bits = numel(bits);

    for out_idx = 1:n
        matched = false;
        for j = 1:num_syms
            code = sorted_codes{j};
            code_len = sorted_lens(j);

            if bit_pos + code_len - 1 > num_bits
                continue;   % not enough bits left for this code
            end

            % Compare slices element-by-element
            ok = true;
            for k = 1:code_len
                if bits(bit_pos + k - 1) ~= code(k)
                    ok = false;
                    break;
                end
            end
            if ok
                x(out_idx) = sorted_symbols(j);
                bit_pos = bit_pos + code_len;
                matched = true;
                break;
            end
        end

        if ~matched
            error('huffman_decode: no code matched at output index %d (bit_pos=%d, num_bits=%d)', ...
                  out_idx, bit_pos, num_bits);
        end
    end

end

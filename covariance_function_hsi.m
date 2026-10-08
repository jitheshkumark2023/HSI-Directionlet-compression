function [DirVar, dominant_angles] = covariance_function_hsi(img)

% IMAGE SIZE
[rows, cols] = size(img);

% DIGITAL LINE DIRECTIONS  (dy, dx) and matching angles
dirs = [
     1   0;   % Horizontal Right      (0°)
     0   1;   % Vertical Down         (90°)
     1   1;   % Main Diagonal         (45°)
     1  -1;   % Anti-Diagonal         (-45° degree represented as 315 for calculation of at main program)
    %  2   1;   % Shallow Slope         (26.56°)
    %  1   2;   % Steep Slope           (63.43°)
    % -2   1;   % Reverse Shallow       (153.43°)
    %  1  -2    % Reverse Steep         (296.56°)
];
angles = [0, 90, 45, 315]; 
% [26.56, 63.43, 153.43, 296.56]

% DIRECTIONAL VARIANCE
DirVar = zeros(1, size(dirs, 1));

% PROCESS EACH DIRECTION
for d = 1:size(dirs, 1)
    dy = dirs(d, 1);
    dx = dirs(d, 2);
    total_sum = 0;
    N = 0;
    visited = false(rows, cols);

    % GENERATE DIGITAL LINES
    for r = 1:rows
        for c = 1:cols
            if ~visited(r, c)
                line_pixels = [];
                y = r;
                x = c;
                while (y >= 1 && y <= rows && x >= 1 && x <= cols)
                    line_pixels = [line_pixels, img(y, x)];
                    visited(y, x) = true;
                    y = y + dy;
                    x = x + dx;
                end

                % COMPUTE VARIANCE FOR THIS LINE
                if length(line_pixels) > 1
                    line_mean    = mean(line_pixels);
                    variance_line = sum((line_pixels - line_mean).^2);
                    total_sum     = total_sum + variance_line;
                    N             = N + length(line_pixels);
                end
            end
        end
    end

    % AVERAGE DIRECTIONAL VARIANCE
    if N > 0
        DirVar(d) = total_sum / N;
    end
end

% TWO DIRECTIONS WITH SMALLEST VARIANCE
[~, sort_idx]      = sort(DirVar);
dominant_angles    = angles(sort_idx(1:2));
end

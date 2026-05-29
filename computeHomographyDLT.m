function H = computeHomographyDLT(srcPts, dstPts)
% COMPUTEHOMOGRAPHYDLT  Compute 3×3 homography via Direct Linear Transform.
%   srcPts : N×2 source points
%   dstPts : N×2 destination points
%   H      : 3×3 homography (column-vector convention)
%
%   Uses normalised DLT for numerical stability.

    n = size(srcPts, 1);
    assert(n >= 4, 'Need at least 4 point pairs.');

    % Normalise source points
    [srcNorm, Tsrc] = normalisePoints(srcPts);
    [dstNorm, Tdst] = normalisePoints(dstPts);

    % Build the 2N × 9 matrix A
    A = zeros(2*n, 9);
    for i = 1:n
        x  = srcNorm(i,1);  y  = srcNorm(i,2);
        xp = dstNorm(i,1);  yp = dstNorm(i,2);
        A(2*i-1, :) = [-x -y -1  0  0  0  xp*x  xp*y  xp];
        A(2*i,   :) = [ 0  0  0 -x -y -1  yp*x  yp*y  yp];
    end

    % Solve Ah = 0 via SVD
    [~, ~, V] = svd(A, 'econ');
    h = V(:, end);
    Hn = reshape(h, [3, 3])';

    % De-normalise
    H = Tdst \ Hn * Tsrc;
    H = H / H(3,3);  % normalise so H(3,3) = 1
end
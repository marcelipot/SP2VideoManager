function ptsOut = transformPointsH(H, ptsIn)
% TRANSFORMPOINTSH  Apply 3×3 homography (column-vector convention) to 2D points.
%   ptsIn  : N×2 matrix [u, v]
%   H      : 3×3 homography (column-vector: p' = H * [u; v; 1])
%   ptsOut : N×2 matrix [u', v']

    n = size(ptsIn, 1);
    ptsH = [ptsIn, ones(n, 1)]';   % 3×N
    proj = H * ptsH;                % 3×N
    ptsOut = (proj(1:2,:) ./ proj(3,:))';  % N×2
end
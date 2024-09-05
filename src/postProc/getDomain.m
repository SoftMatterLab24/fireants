function [N] = getDomain(XY1,midPoints)

[m, ~] = size(midPoints);
for ii = 1:m
    indomain = midPoints(ii,1) > XY1(:,1) & midPoints(ii,1) < XY1(:,2) & midPoints(ii,2) > XY1(:,3) & midPoints(ii,2) < XY1(:,4);
    n = find(indomain);
    if isempty(n)
        N(ii) = length(XY1)+1;
        warning('Could not find subdomain, assigning to ghost domain. Try increasing the grid')
    else
        N(ii) = n;
    end
end

end

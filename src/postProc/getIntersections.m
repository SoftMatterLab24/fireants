function [srtd] = getIntersections(xgrid,ygrid,coord)

    %get the domain boundaries
    xmin = min([coord(1) coord(3)]);
    xmax = max([coord(1) coord(3)]);
    ymin = min([coord(2) coord(4)]);
    ymax = max([coord(2) coord(4)]);

    %coord = [0 1 2 3];
    %coord = [x1 y1 x2 y2]
    m = (coord(4)-coord(2))/(coord(3)-coord(1));  % Slope (or slope array)
    b = coord(2) - m*coord(1);                    % Intercept (or intercept array)                       
    mb = [m b];                                   % Matrix of [slope intercept] values
    
    lxmb = @(xgrid,mb) mb(1).*xgrid + mb(2);
    % Calculate Line #1 = y(x,m,b)
    L1 = lxmb(xgrid,mb);
    % Calculate intercepts
    hix = @(ygrid,mb) [(ygrid-mb(2))./mb(1);  ygrid];   % horizontal
    vix = @(xgrid,mb) [xgrid;  lxmb(xgrid,mb)];         % vertical

    hrz = hix(xgrid(1:end),mb)';           % [X Y] Matrix of horizontal intercepts
    vrt = vix(ygrid(1:end),mb)';           % [X Y] Matrix of vertical intercepts

    hvix = [hrz; vrt];                     % Concatanated  hrz’ and ‘vrt’ arrays
    
    % Remove points outside domain
    ioutside = hvix(:,1) < xmin | hvix(:,1) > xmax | hvix(:,2) < ymin | hvix(:,2) > ymax;
    hvix(ioutside,:) = [];
    
    % Remove repeats and sort ascending by ‘x’
    srtd = unique(hvix,'rows');       

end
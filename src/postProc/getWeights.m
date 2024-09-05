function [w,xgrid,ygrid,NXY,X,Y] = getWeights(px2meter,int_area,domainlengths,coords,pairlist)
tic
%DEBUG
% num = 3000;
% coords = 10*rand(num,2);
% pairlist = ones(length(coords)/2,2);
% pairlist = [2*(1:length(coords)/2)-1 ;2*(1:length(coords)/2)]';

iplot = 1;

xlength = domainlengths(1);
ylength = domainlengths(2);

%number of domains
nx = floor(xlength/(int_area*2));
ny = floor(ylength/(int_area*2));

NXY = [nx,ny];

%spacing between center points and grid
cptx = floor(xlength/2);
cpty = floor(ylength/2);

% domain center points
xlin = [(cptx-int_area*(nx+0.5)):int_area:(cptx+int_area*(nx+0.5))];
ylin = [(cpty-int_area*(ny+0.5)):int_area:(cpty+int_area*(ny+0.5))];

%grid values
xgrid = [xlin(1)-int_area/2 xlin+int_area/2]*px2meter;
ygrid = [ylin(1)-int_area/2 ylin+int_area/2]*px2meter;

[X, Y] = meshgrid(xlin,ylin);

%Build array of boundary vectors
XY1 = [];
for nn = 1:numel(X)
    cptx_sub = X(nn);
    cpty_sub = Y(nn);

    xmin_sub = (cptx_sub - int_area/2)*px2meter;
    xmax_sub = (cptx_sub + int_area/2)*px2meter;
    ymin_sub = (cpty_sub - int_area/2)*px2meter;
    ymax_sub = (cpty_sub + int_area/2)*px2meter;
    boundaries = [xmin_sub xmax_sub ymin_sub ymax_sub];

    XY1 = [XY1; boundaries];
    
    %%% PLOTTING %%%
    if iplot
    in = coords(:,1) >= xmin_sub & coords(:,1) < xmax_sub & coords(:,2) >= ymin_sub & coords(:,2) < ymax_sub;
    itemp = find(in);
    iclose(1:length(itemp)) = itemp;

        try
            iloc = iclose(~isnan(iclose));
            scatter(coords(itemp,2)/px2meter,coords(itemp,1)/px2meter,'filled')
            hold on
        catch
        end
    end
    %%%%%%%%%%%%%%%%
end

%intialize the weight array
w = zeros([length(pairlist),numel(X)+1]);

%loop through bonds
for mm = 1:length(pairlist)
    
    aatom = pairlist(mm,1);
    batom = pairlist(mm,2);

    %get coordinate points
    coord = [coords(aatom,1) coords(aatom,2) coords(batom,1) coords(batom,2)];
    
    %get intersection points
    [srtd] = getIntersections(xgrid,ygrid,coord);
    
    %cat and select the unique points
    uniqueSearchPoints = unique([coords(batom,1) coords(batom,2);srtd;coords(aatom,1) coords(aatom,2)],'rows','stable');
    
    %order the points
    [xvec, I] = sort(uniqueSearchPoints(:,1));
    yvec = uniqueSearchPoints(I,2);
    searchPoints = [xvec yvec];  

    if isempty(srtd)
        %if empty, bond is fully in domain
        midPoints = [(searchPoints(1,1) + searchPoints(2,1))/2 (searchPoints(1,2) + searchPoints(2,2))/2];
        w_temp = 1;
        [N] = getDomain(XY1,midPoints);
    else
        nn = 1:length(searchPoints)-1;
        searchPoint12 = [searchPoints(nn,:) searchPoints(nn+1,:)];
        midPoints = [(searchPoint12(:,1) + searchPoint12(:,3))/2 (searchPoint12(:,2) + searchPoint12(:,4))/2];
        dist2 = (searchPoint12(:,3) - searchPoint12(:,1)).^2 + (searchPoint12(:,4) - searchPoint12(:,2)).^2;
        w_temp = dist2/sum(dist2);
        [N] = getDomain(XY1,midPoints);
    end
    w(mm,N) = w_temp;
end

%%% PLOTTING %%%
if iplot
for mm = 1:length(pairlist)
    xp = [coords(pairlist(mm,1),1) coords(pairlist(mm,2),1)]/px2meter;
    yp = [coords(pairlist(mm,1),2) coords(pairlist(mm,2),2)]/px2meter;
    plot(yp,xp,'k-')
end
    xline(xgrid/px2meter)
    yline(ygrid/px2meter)
end
%%%%%%%%%%%%%%%%
toc
end
function [coords,limits] = BWtoNodes(BW,Rmean)
tic
[m n] = size(BW);
Ntry = 1e8;

xmin = 0;
xmax = m;

ymin = 0;
ymax = n;

limits = [xmin xmax;
          ymin ymax];
%% Fill

%Rvo2  = xv.^2 + yv.^2 + zv.^2;
%Rmax2 = max(Rvo2);

Xg = zeros(Ntry,1);
Yg = zeros(Ntry,1);


% Place first point
in  = 0;
while ~in
    xg = (xmax-xmin).*rand(1,1) + xmin;
    yg = (ymax-ymin).*rand(1,1) + ymin;
    
    if xg >= xmin && xg<=xmax && yg >= ymin && yg<=ymax && ~BW(floor(xg)+1,floor(yg)+1)
        in = true;
    end
end

Xg(1) = xg;
Yg(1) = yg;

Dmax = (2.05*Rmean);
ng = 1;
icount = 0;
while ng < Ntry

    icount = icount+1;
    if icount > 5
        fprintf('Filled %d particles in %g seconds\n',ng,toc)
        break
    end

        xg = (xmax-xmin).*rand(200,1) + xmin;
        yg = (ymax-ymin).*rand(200,1) + ymin;

        in  = (xg >= xmin).*(xg<=xmax).*(yg >= ymin).*(yg<=ymax); 
        xg(in) = [];
        yg(in) = [];
        
        clear in
        for ii = 1:length(xg)
            in(ii) = ~BW(floor(xg(ii))+1,floor(yg(ii))+1);
        end

        xg(~in) = [];
        yg(~in) = [];
      
        if isempty(xg)
            continue
        end

        Idx = rangesearch([xg yg],[xg yg],Dmax);
        for II = 1:length(Idx)
            if Idx{II}(1) == II
                Idx{II}(1) = [];
            end
        end
        i_overlap = ~(cellfun('length',Idx)) == 0;
        if sum(i_overlap~=0)
            Idx = Idx{i_overlap};
            if ~isempty(Idx)
                xg(Idx) = [];
                yg(Idx) = [];
            end
        end

        if isempty(xg)
            continue
        end

    % Get the distance btw ith point and rest all points
    Idx = rangesearch([Xg(1:ng) Yg(1:ng)],[xg yg],Dmax);
    idelete = ~(cellfun('isempty',Idx));
    if ~isempty(idelete)
        xg(idelete) = [];
        yg(idelete) = [];

    end

    if isempty(xg)
        continue
    end

    n_add = length(xg);

    Xg((ng+1):(ng+n_add)) = xg;
    Yg((ng+1):(ng+n_add)) = yg;

    ng = ng+n_add;

    icount = 0;
end

coords = [Xg(1:ng) Yg(1:ng)];


end
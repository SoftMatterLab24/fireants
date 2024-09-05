function [coords,limits,rho_network] = BWtoNodes(BW,px2meter,xi)

%% Parameters
%%% Density of ants %%%
rho = 0.304*1e6;           % (ants/m2)
dr  = xi*(1/sqrt(rho));    % Critical overlap distance

%%% Single ant parameters %%%
Lr = 2.93*1e-3;            % Length of one ant (m)
dia = .7*dr;               % Diameter of one body segment (m)


%%% Size of domain (m) %%%
[m, n] = size(BW);
Lx  = m*px2meter;   % Length of x dimension
Ly  = n*px2meter;   % Length of y dimension

% Option to plot the network (don't use for large systems..)
iplot = 0;

% Option to display packing density
ioutput = 0;

%% Randomly placing

%%% Limits for x and y cps %%%
xmin = 0;
xmax = Lx;

ymin = 0;
ymax = Ly;

limits = [xmin xmax;
          ymin ymax];

%Rvo2  = xv.^2 + yv.^2 + zv.^2;
%Rmax2 = max(Rvo2);
%Xg = zeros(Ntry,1);
%Yg = zeros(Ntry,1);

%%% Place first point %%%
in  = 0;
while ~in
    xg = (xmax-xmin).*rand(1,1) + xmin;
    yg = (ymax-ymin).*rand(1,1) + ymin;

    if xg >= xmin && xg<=xmax && yg >= ymin && yg<=ymax && ~BW(floor(xg/px2meter)+1,floor(yg/px2meter)+1)
        in = true;
    end
end

%%% Initialize structure %%%
cps = [xg, yg];

tic
itry = 1;
while 1 == 1

    %icount = icount+1;
    if itry > 500
        fprintf('Filled %d particles in %g seconds\n',length(cps),toc)
        break
    end

        %Randomly select points
        xg = (xmax-xmin).*rand(1,1) + xmin;
        yg = (ymax-ymin).*rand(1,1) + ymin;
        
        %Remove any points outside the domain
        in  = (xg >= xmin).*(xg<=xmax).*(yg >= ymin).*(yg<=ymax); 
        xg(~in) = [];
        yg(~in) = [];

        if isempty(xg)
            continue
        end
        
        %check to see if part of raft
        clear in
        for ii = 1:length(xg)
            in(ii) = ~BW(floor(xg(ii)/px2meter)+1,floor(yg(ii)/px2meter)+1);
        end
        
        %Remove points that dont belong to the raft
        xg(~in) = [];
        yg(~in) = [];
        
        %If no points remain continue
        if isempty(xg)
            continue
        end
        
        % Get the distance btw randomly chosen cp and rest of cps
        cp = [xg, yg];
        data = repmat(cp,[size(cps,1),1])-cps;
        dist2 = data(:,1).^2+data(:,2).^2;

        iclose = find(dist2 < dr^2);
        
        if isempty(iclose)
            cps = [cps; cp];
            itry = 1;
            continue
        end
    %     Idx = rangesearch([xg yg],[xg yg],Dmax);
    %     for II = 1:length(Idx)
    %         if Idx{II}(1) == II
    %             Idx{II}(1) = [];
    %         end
    %     end
    %     i_overlap = ~(cellfun('length',Idx)) == 0;
    %     if sum(i_overlap~=0)
    %         Idx = Idx{i_overlap};
    %         if ~isempty(Idx)
    %             xg(Idx) = [];
    %             yg(Idx) = [];
    %         end
    %     end
    % 
    %     if isempty(xg)
    %         continue
    %     end
    % 
    % % Get the distance btw ith point and rest all points
    % Idx = rangesearch([Xg(1:ng) Yg(1:ng)],[xg yg],Dmax);
    % idelete = ~(cellfun('isempty',Idx));
    % if ~isempty(idelete)
    %     xg(idelete) = [];
    %     yg(idelete) = [];
    % 
    % end
    % 
    % if isempty(xg)
    %     continue
    % end
    % 
    % n_add = length(xg);
    % 
    % Xg((ng+1):(ng+n_add)) = xg;
    % Yg((ng+1):(ng+n_add)) = yg;
    % 
    % ng = ng+n_add
    itry = itry + 1;
end


    nants = length(cps);
    Afrac = sum(~BW,'all')/numel(BW);
    rho_network = nants/(Afrac*Lx*Ly);
if ioutput
    fprintf('True Raft Density: %4.4f ants m^-2. Artifical Raft Density: %4.4f ants m^-2',rho,rho_network)
end

if iplot
    scatter(cps(:,1),cps(:,2))
end

coords = cps;

end
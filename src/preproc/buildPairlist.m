function [pairlist,avgconn] = buildPairlist(coords,xi)    
    %clearvars -except coords
    %% Parameters
    %%% Density of ants %%%
    rho = 0.304*1e6;             % (ants/m2)
    dr  = xi*(1/sqrt(rho));         % Critical overlap distance
    
    %%% Bond Parameters %%%
    Lmax = 1.8919*dr;           % Bond Cuttoff
    maxbond = 6;                % Max number of bonds
    Pattach = 0.5;              % Probability to attach

    %%% Single ant parameters %%%
    % Lr = 2.93*1e-3;            % Length of one ant (m)
    % dia = .7*dr;               % Diameter of one body segment (m)

    %%% Size of domain (m) %%%
    % [m, n] = size(BW);
    % Lx  = m*px2meter;   % Length of x dimension
    % Ly  = n*px2meter;   % Length of y dimension

    nants = length(coords);

    % Option to display connectivity
    ioutput = 0;

    %%% Initilize %%%
    bond_count = zeros(1,nants);
    tic
    itry = 1;
    pairlist = [];
    while 1 == 1

    if itry > 10
        fprintf('Created %d bonds in %g seconds\n',nbonds,toc)
        break
    end

        for ii = 1:nants
            
            %% See if atom at max count
            if bond_count(ii) == maxbond
                continue
            end

            %get distance between ants in reach
            cp = [coords(ii,1), coords(ii,2)];
            data = repmat(cp,[size(coords,1),1])-coords;
            dist2 = data(:,1).^2+data(:,2).^2;

            iclose = find(dist2 < Lmax^2);

            %% Remove self from list
            ibond = ii == iclose;
            iclose(ibond) = [];

            %% Check if neighbors %%
            if isempty(iclose)
                continue
            end
            
            %% See if neighbors at max count %%
            ifull = bond_count(iclose) == maxbond;
            iclose(ifull) = [];

            %% Check if remaining neighbors %%
            if isempty(iclose) 
                continue
            end
            
            %% See if they are alread bonded
            if isempty(pairlist)
                %if the pairlist is empty dont need to check this
            else
                [pairsize, ~] = size(pairlist);
                abond = ii;
                bbond = iclose;
                pairsl = repmat(abond,[1 2 length(bbond)]);
                pairsr = pairsl;

                pairsl(:,2,:) = bbond;
                pairsr(:,1,:) = bbond;

                if pairsize == 1
                    ibondl = reshape(sum(pairsl == pairlist,2)==2,[1 length(bbond)]);
                    ibondr = reshape(sum(pairsr == pairlist,2)==2,[1 length(bbond)]);
                    ibond = logical(ibondl + ibondr);
                else
                    ibondl = reshape(any(sum(pairsl == pairlist,2)==2),[1 length(bbond)]);
                    ibondr = reshape(any(sum(pairsr == pairlist,2)==2),[1 length(bbond)]);
                    ibond = logical(ibondl + ibondr);
                end
                iclose(ibond) = [];
            end

            %% Check if remaining neighbors %%
            if isempty(iclose) 
                continue
            end

            %% loop through and see if bond is created
            for jj = 1:length(iclose)
                a = ii;
                b = iclose(jj);
                
                %final check
                if bond_count(a) < maxbond && bond_count(b) < maxbond
                    if rand < Pattach
                     pair = [a b];
                     pairlist = [pairlist; pair];
                     bond_count(a) = bond_count(a) + 1;
                     bond_count(b) = bond_count(b) + 1;
                    end
                end
            end
        %done with sweeping through ants
        end

    nbonds = length(pairlist);
    itry = itry +1;
    end

    
        xmax = max(coords(:,1));
        ymax = max(coords(:,2));
        conn = [];
        counter = 1;
        for mm = 1:nants

            if coords(mm,1) < .0025 || coords(mm,1)  > xmax-.0025 ||  coords(mm,2) < .0025 || coords(mm,2) > ymax-.0025 
                continue
            end
            conn(counter) = length(find(pairlist==mm));
            counter = counter + 1;
        end
        %hist(conn,6)
        avgconn = mean(conn);
    if ioutput
        fprintf('Raft Coordination Number %4.4f. Network Coordination Number %4.4f',5.5,avgconn)
    end

end
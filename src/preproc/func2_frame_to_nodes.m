clear all
clf

TrialDir = 'D:\CU_Boulder\Research\Fields\1 - Fire Ants\Ants - Contraction\video\Trial1';

%% INPUTS
xi = 0.75; %0.78 good

%% Frame Locations
% Files in the directory
listing = dir(TrialDir);

% Find frame folders and store the location
jj = 0;
for ii = 1:length(listing)
    name = listing(ii).name;
    isdir = listing(ii).isdir;
    
    if contains(name,'frame') && isdir == true
        jj = jj + 1;
        names_frame{jj} = name;
    else
        continue
    end
end

%% Loop through every frame
for kk = 1:length(names_frame)
    
    %read the BW tiff
    frame_loc = strcat(TrialDir,'\',names_frame{kk});
    BW = imread(strcat(frame_loc,'\',names_frame{kk},'.tiff'));

    if kk ==1
        frame = imread(strcat(frame_loc,'\',names_frame{kk},'.png'));
        figure(1)
        imshow(frame)
        ax = gca;
        disp('waiting... press enter when done')
        roi = drawline(ax);
        pause
        try
            %length of an ant in pixels
            ant_length = sqrt((roi.Position(2)-roi.Position(1))^2 + (roi.Position(4)-roi.Position(3))^2);

            %length of an ant in m
            Lr = 2.93*1e-3;
            
            px2meter = Lr/ant_length;
            close(1)
            disp('calibrated')
        catch
            error('Failed to calibrate')
        end
    end

    % Find network folders and store the location
    listing = dir(frame_loc);
    mm = 0;
    for ll = 1:length(listing)
        name = listing(ll).name;
        isdir = listing(ll).isdir;
    
        if contains(name,'N') && isdir == true
            mm = mm + 1;
            names_network{mm} = name;
        else
            continue
        end
    end
    w = waitbar(0,'Generating Networks');

    %%% FOR DEBUG CALIBRATION
    BW = zeros(size(BW));
    %% Loop through and generate each network
   
    parfor nn = 1:length(names_network)
        %waitbar(nn/length(names_network),w)
        
        

        [coords,limits,rho_network] = BWtoNodes(BW,px2meter,xi);
        NetworkWriteLocation = strcat(frame_loc,'\',names_network{nn});
        writeATOMS(coords,limits,NetworkWriteLocation)
        %save(strcat(NetworkWriteLocation,'\','coords.mat'),'coords')

        %create bonds
        [pairlist,avgconn] = buildPairlist(coords,xi);
        writeBONDS(limits,pairlist,NetworkWriteLocation)
        writePAIRLIST(pairlist,NetworkWriteLocation)
        
        rho(nn) = rho_network;
        conn(nn) = avgconn;
    end

end
disp('done')
%% Visualization
% figure(1)
% boxchart(conn)
% ylim([0 6])
% hold on
% yline(5.5,'k--')
% xlabel('Frame 1')
% ylabel('Connectivity')
% disp('done')


% figure(2)
% boxchart(rho/1e6)
% ylim([0 .5])
% hold on
% yline(0.304,'k--')
% ylabel('Density (ants/mm^2)')
% xlabel('Frame 1')
% disp('done')
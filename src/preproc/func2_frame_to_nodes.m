clear all
clf

TrialDir = 'D:\CU_Boulder\Research\Fields\1 - Fire Ants\Ants - Contraction\video\Trial1';

%% INPUTS
Rmean = 6;

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

    %% Loop through and generate each network
    for nn = 1:length(names_network)

        %pack atoms
        [coords,limits] = BWtoNodes(BW,Rmean);
        NetworkWriteLocation = strcat(frame_loc,'\',names_network{nn});
        writeATOMS(coords,limits,NetworkWriteLocation)
        %save(strcat(NetworkWriteLocation,'\','coords.mat'),'coords')

        %create bonds
        [pairlist] = buildPairlist(coords,Rmean);
        writeBONDS(limits,pairlist,NetworkWriteLocation)
        writePAIRLIST(pairlist,NetworkWriteLocation)
    end

end

disp('done')
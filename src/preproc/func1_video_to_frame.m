clear all
clf

TrialDir = 'D:\CU_Boulder\Research\Fields\1 - Fire Ants\Ants - Contraction\video\Trial1';
videoName = 'B4_Bulk.mp4';

sampling_rate = 1;
end_frame = 60;
NetworkCount = 1;

%%
try
    v = VideoReader(strcat(TrialDir,'/',videoName));
catch
    error('Could not read video file')
end

FramestoRead = 1:sampling_rate:end_frame;%v.NumFrames;

warning('off', 'MATLAB:MKDIR:DirectoryExists');
w  = waitbar(0,'Reading Frames');
for ii = 1:length(FramestoRead)
    
    waitbar(ii/length(FramestoRead),w)
    
    %read frame
    frame = read(v,FramestoRead(ii));
    frameID = FramestoRead(ii);
    frameName = strcat('frame',num2str(frameID));

    %create frame dir
    mkdir(strcat(TrialDir,'\',frameName))
    
    %create network dir
    for jj = 1:NetworkCount
        NetworkdirName = strcat('N',num2str(jj));
        mkdir(strcat(TrialDir,'\',frameName,'\',NetworkdirName))
    end
    
    %save frame
    writeFrameName = strcat(TrialDir,'\',frameName,'\',frameName,'.png');
    imwrite(frame,writeFrameName)
    
    %save BW
    [BW] = getBW(frame);
    writeBWName = strcat(TrialDir,'\',frameName,'\',frameName,'.tiff');
    imwrite(BW,writeBWName)
    
end

disp('done')
function [J2] = getBW(frame)
    
    BW = imbinarize(im2gray(frame), 'adaptive', 'Sensitivity', 0.55000, 'ForegroundPolarity', 'dark');
    SE = strel('disk',1);
    J = imclose(~BW,SE);
    J2 = bwareafilt(J,[50 1e10]);
    J2 = ~J2;
    
    %% DEBUG
    % figure(2)
    % imshow(BW)
    % figure(3)
    % imshow(J2)
end
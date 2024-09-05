

%% External variables

%pairlist (for all N networks)
%frame
%m
%n

[xlength, ylength] = size(frame);

px_x = floor(xlength/m);
px_y = floor(ylength/n);

for mm = 1:m
    for nn = 1:n

        %get subdomain boundaries
        xmin = 1 + (mm-1)*px_x;
        xmax = 1 + (mm)*px_x;
        ymin = 1 + (nn-1)*px_y;
        ymax = 1 + (nn1)*px_y;

        


    end
end




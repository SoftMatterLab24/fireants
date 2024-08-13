function writeBONDS(limits,pairlist,NetworkWriteLocation)

nbonds = length(pairlist);

xlims = limits(1,:);
ylims = limits(2,:);
zlims = [-0.05 0.05];

fid = fopen(strcat(NetworkWriteLocation,'\','bonds.dump'),'w');

% bonds
fprintf(fid,'ITEM: TIMESTEP\n');
fprintf(fid,'0\n');
fprintf(fid,'ITEM: NUMBER OF ENTRIES\n');
fprintf(fid,'%d\n',nbonds);
fprintf(fid,'ITEM: BOX BOUNDS ss ss ss\n');

% Simulation boundaries
fprintf(fid,'%g %g \n',xlims(1),xlims(2));
fprintf(fid,'%g %g \n',ylims(1),ylims(2));
fprintf(fid,'%g %g \n',zlims(1),zlims(2));

% bond-type atom1 atom2
fprintf(fid,'ITEM: ENTRIES type atom1 atom2\n');
for ii = 1:nbonds
    fprintf(fid,'%d %d %d \n',1,pairlist(ii,1),pairlist(ii,2));
end

fclose(fid);

end
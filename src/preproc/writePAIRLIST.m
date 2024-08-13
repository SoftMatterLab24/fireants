function writePAIRLIST(pairlist,NetworkWriteLocation)

nbonds = length(pairlist);


fid = fopen(strcat(NetworkWriteLocation,'\','pairlist.in'),'w');

% Atoms and bonds
% fprintf(fid,'ITEM: TIMESTEP\n');
% fprintf(fid,'0\n');
% fprintf(fid,'ITEM: NUMBER OF ATOMS\n');
% fprintf(fid,'%d\n',natoms);
% fprintf(fid,'ITEM: BOX BOUNDS ss ss ss\n');

% Simulation boundaries
% fprintf(fid,'%g %g \n',xlims(1),xlims(2));
% fprintf(fid,'%g %g \n',ylims(1),ylims(2));
% fprintf(fid,'%g %g \n',zlims(1),zlims(2));

% atomID1 atomID2
for ii = 1:nbonds
    fprintf(fid,'%d %d\n',pairlist(ii,1),pairlist(ii,2));
end

fclose(fid);

end
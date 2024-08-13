function writeATOMS(coords,limits,NetworkLocation)

natoms = length(coords);

xlims = limits(1,:);
ylims = limits(2,:);
zlims = [-0.05 0.05];

fid = fopen(strcat(NetworkLocation,'\','atoms.dump'),'w');

% Atoms and bonds
fprintf(fid,'ITEM: TIMESTEP\n');
fprintf(fid,'0\n');
fprintf(fid,'ITEM: NUMBER OF ATOMS\n');
fprintf(fid,'%d\n',natoms);
fprintf(fid,'ITEM: BOX BOUNDS ss ss ss\n');

% Simulation boundaries
fprintf(fid,'%g %g \n',xlims(1),xlims(2));
fprintf(fid,'%g %g \n',ylims(1),ylims(2));
fprintf(fid,'%g %g \n',zlims(1),zlims(2));

% Atom type: hybrid bond sphere
% atom-ID atom-type x y z
fprintf(fid,'ITEM: ATOMS id type x y z\n');
for ii = 1:natoms
    fprintf(fid,'%d %d %g %g %g\n',ii,1,coords(ii,1),coords(ii,2),0);
end

fclose(fid);

end
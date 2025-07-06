function f_readvspgeom( fname )

%%% Lecture du fichier *.vspgeom
fp = fopen(fname,'r');

%%% Lecture du nombre de point pour le maillage
npt = fscanf(fp, '%d', 1);

%%% Coordonnées des points du maillage
ptdata = fscanf(fp, '%f', [3 npt]);
p = ptdata(1:3,:);

%%% Nombre de poly. à afficher
npoly = fscanf(fp, '%d', 1);

%%% Extraction de la connectivité entre les polys
condata = fscanf(fp, '%d', [4 npoly]);
con = condata(2:4,:);

%%% Lecture de l'ID de la surface (ou du poly)
tdata = fscanf(fp, '%f', [7 npoly]);
id = tdata(1,:);

%%% Fermeture du fichier *.vspgeom
fclose(fp);

%%% Affichage de la géométrie de l'avion
figure();
trisurf(con', p(1,:), p(2,:), p(3,:), id, ...
    'FaceColor', [0.8 0.8 0.8], 'EdgeColor','k');
axis equal; box on;

end

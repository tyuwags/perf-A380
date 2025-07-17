% Préparation de l'environement Matlab
close all; clear; clc

mkdir 'Outputs'

% Ajout des dossier pour le programme
addpath('Program files/', 'Outputs/')

%% % Configuration pour le programme
% Modèle de votre ordinateur MAC ou WIN
computer_type = 'MAC';     % Si vous êtes sur Mac
% àcomputer_type = 'WIN';  % Si vous êtes sur Windows

% Chemin où se trouve les fichiers *.history pour l'aile+fuselage, et pour
% l'empennage arrière. Notez que si vous laissez '' sur les champs, alors
% le programme vous demandera de chercher les fichiers avec une fenêtre.
% sindon, il cherchera le fichier en fonction du chemin spécifié dans la
% variable 'locataion_xx', et le nom du fichier 'filename_xx'.

% Pour l'aile et le fuselage:
location_wb = ''; % ou 'Airbus 380'
filename_wb = 'Avion_WB_VSPGeom.history';

% Pour l'empennage arrière
location_ht = 'Airbus 380';
filename_ht = 'Avion_HT_VSPGeom.history';

%% % Spécification des chemins pour les fichiers *.history
% Si l'utilisateur ne donne pas le chemin pour le fichier *.history, alors
% on lui demande de le chercher avec une fenêtre

if isempty(location_wb) || isempty(location_ht)
    fprintf('* Chemin pour les données d''OpenVSP:\n')
end

% Pour l'aile et le fuselage
if isempty(location_wb)
    % Demande à Matlab d'ouvrir une fenêtre pour trouver le fichier
    fprintf('  -> chemin pour les données de l''aile + fuselage.\n')
    [filename_wb, location_wb] = uigetfile('*.history', ...
        'Fichier pour l''aile + fuselage');
end

% Pour l'empennage arrière
if isempty(location_ht)
 % Demande à Matlab d'ouvrir une fenêtre pour trouver le fichier
    fprintf('  -> chemin pour les données pour l''empennage arrière.\n')
    [filename_ht, location_ht] = uigetfile('*.history', ...
        'Fichier pour l''empennage arrière');
end

%% % Affichage de la géométrie de l'avion
% Nom du fichier *.vspgeom à lire pour le modèle 3D de l'avion
file_vspgeom = 'Airbus 380/Avion_WBT_VSPGeom.vspgeom';
f_readvspgeom(file_vspgeom)

%% % Lecture des fichiers *.history
fprintf('* Lecture et importation des données dans Matlab:\n')

% Lecture du fichier *.history pour l'aile + fuselage (WB)
filename_wb = fullfile(location_wb, filename_wb);
fprintf('  -> données de l''aile + fuselage.\n')
if strcmp(computer_type, 'MAC')
    aero_wb = f_readOpenVSPfileMAC(filename_wb);
else
    aero_wb = f_readOpenVSPfileWIN(filename_wb); %#ok<UNRCH>
end

% Lecture du fichier *.history pour l'empennage arrière (HT)
filename_ht = fullfile(location_ht, filename_ht);
fprintf('  -> données de l''empennage arrière.\n')
if strcmp(computer_type, 'MAC')
    aero_ht = f_readOpenVSPfileMAC(filename_ht);
else
    aero_ht = f_readOpenVSPfileWIN(filename_ht); %#ok<UNRCH>
end

%% % Création d'une structure aérodynamique
fprintf('* Création de la structure ''aero_data''...\n')

f_clwb.x_alpha = unique(aero_wb.AoA);
f_cdwb.x_alpha = unique(aero_wb.AoA);
f_cmwb.x_alpha = unique(aero_wb.AoA);

f_clwb.y_mach = unique(aero_wb.Mach);
f_cdwb.y_mach = unique(aero_wb.Mach);
f_cmwb.y_mach = unique(aero_wb.Mach);

f_clwb.value = zeros(length(unique(aero_wb.AoA)), length(unique(aero_wb.Mach)));
f_cdwb.value = zeros(length(unique(aero_wb.AoA)), length(unique(aero_wb.Mach)));
f_cmwb.value = zeros(length(unique(aero_wb.AoA)), length(unique(aero_wb.Mach)));

for i_m = 1: length(unique(aero_wb.Mach))
    mach = f_clwb.y_mach(i_m);
    idx = find(aero_wb.Mach == mach);

    f_clwb.value(:, i_m) = aero_wb.CL(idx);
    f_cdwb.value(:, i_m) = aero_wb.CDtot(idx);
    f_cmwb.value(:, i_m) = aero_wb.CMy(idx);
end

f_clht.x_alpha = unique(aero_ht.AoA);
f_cdht.x_alpha = unique(aero_ht.AoA);

f_clht.y_mach = unique(aero_ht.Mach);
f_cdht.y_mach = unique(aero_ht.Mach);

f_clht.value = zeros(length(unique(aero_ht.AoA)), length(unique(aero_ht.Mach)));
f_cdht.value = zeros(length(unique(aero_ht.AoA)), length(unique(aero_ht.Mach)));

for i_m = 1: length(unique(aero_ht.Mach))
    mach = f_clht.y_mach(i_m);
    idx = find(aero_ht.Mach == mach);

    f_clht.value(:, i_m) = aero_ht.CL(idx);
    f_cdht.value(:, i_m) = aero_ht.CDtot(idx);
end

%% % Stockage des données dans une structure aero_data
aero_data.f_clwb = f_clwb;
aero_data.f_cdwb = f_cdwb;
aero_data.f_cmwb = f_cmwb;
aero_data.f_clht = f_clht;
aero_data.f_cdht = f_cdht;

% Sauvegarde de la structure aero_data dans le dossier 'Output'
fprintf('* Sauvegarde de la structure ''aero_data'' dans le dossier Output.\n')
save('Outputs/aero_data', 'aero_data', '-mat')


%% % Interpolation d'un coefficient en fonction de alpha et mach
alpha = 10; mach = 1.0;

CL_wb = interp2(aero_data.f_clwb.y_mach, aero_data.f_clwb.x_alpha, ...
    aero_data.f_clwb.value, mach, alpha, 'spline')

%% % Affichage des coefficients aérodynamiques
figure();
subplot(221); hold on; grid on; box on;
plot(f_clwb.x_alpha, f_clwb.value', 'b');
xlabel('$\alpha$ - [deg]', 'Interpreter', 'latex');
ylabel('$CL_{wb}$', 'Interpreter', 'latex');

subplot(222); hold on; grid on; box on;
plot(f_cdwb.x_alpha, f_cdwb.value', 'b');
xlabel('$\alpha$ - [deg]', 'Interpreter', 'latex');
ylabel('$CD_{wb}$', 'Interpreter', 'latex');

subplot(223); hold on; grid on; box on;
plot(f_clht.x_alpha, f_clht.value', 'b');
xlabel('$\alpha_{ht}$ - [deg]', 'Interpreter', 'latex');
ylabel('$CL_{ht}$', 'Interpreter', 'latex');

subplot(224); hold on; grid on; box on;
plot(f_cdht.x_alpha, f_cdht.value', 'b');
xlabel('$\alpha_{ht}$ - [deg]', 'Interpreter', 'latex');
ylabel('$CD_{ht}$', 'Interpreter', 'latex');


figure();
subplot(221); hold on; grid on; box on;
surf(f_clwb.x_alpha, f_clwb.y_mach, f_clwb.value');
view(45, 10);

xlabel('$\alpha$ - [deg]', 'Interpreter', 'latex');
ylabel('Mach]', 'Interpreter', 'latex');
zlabel('$CL_{wb}$', 'Interpreter', 'latex');

subplot(222); hold on; grid on; box on;
surf(f_cdwb.x_alpha, f_cdwb.y_mach, f_cdwb.value');
view(45, 10);

xlabel('$\alpha$ - [deg]', 'Interpreter', 'latex');
ylabel('Mach', 'Interpreter', 'latex');
zlabel('$CD_{wb}$', 'Interpreter', 'latex');

subplot(223); hold on; grid on; box on;
surf(f_clht.x_alpha, f_clht.y_mach, f_clht.value');
view(45, 10);

xlabel('$\alpha$ - [deg]', 'Interpreter', 'latex');
ylabel('Mach', 'Interpreter', 'latex');
zlabel('$CL_{ht}$', 'Interpreter', 'latex');

subplot(224); hold on; grid on; box on;
surf(f_cdht.x_alpha, f_cdht.y_mach, f_cdht.value');
view(45, 10);

xlabel('$\alpha$ - [deg]', 'Interpreter', 'latex');
ylabel('Mach', 'Interpreter', 'latex');
zlabel('$CD_{ht}$', 'Interpreter', 'latex');
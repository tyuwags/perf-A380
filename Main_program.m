% Preparation de l'environement Matlab
close all; clear; clc

% Ajout des dossiers / fonctions du programme
addpath('Aircraft/', 'Modules/');

load('Aircraft/aero_data.mat');

geom_data.wing.S_ref = 859;
geom_data.wing.c_ref = 11;

geom_data.stab.S_ref = 205;
geom_data.stab.x_ref = 32.0;
geom_data.stab.z_ref = 1.24;

% Données géométriques des moteurs
geom_data.engine.x_ref_23 = 6.00;
geom_data.engine.z_ref_23 = 1.60;

geom_data.engine.x_ref_14 = 1.70;
geom_data.engine.z_ref_14 = 0.50;

phi_t = 2;

fn_max = 332.44 * 10^3 * 4;

alpha = 0;
delta = 0;
fn = fn_max * 0.4;
n1 = 0;
gamma = 0;

A380 = m_plane.Plane(geom_data, aero_data, 500000, 40, 25, phi_t, alpha, delta, fn, n1, gamma);

%% % Définition des données géométriques de l'avion
% Données de l'aile

%% %
m_convert.f_length(36500, 'ft', 'm')
m_atmos.f_speed_sound(3000, 0)
m_atmos.f_pressure(15000)
m_convert.f_cas_to_mach(154.33, 6250, 0)
m_convert.f_cas_to_tas(154.33, 6250, 0)
m_convert.f_mach_to_cas(m_convert.f_cas_to_mach(154.33, 6250, 0), 6250)

mode = m_engine.mode.nmcl;

delta = m_atmos.f_delta(12000);

fn = m_engine.f_thrust(12000, 0.8, 20, mode)
wf = m_engine.f_fuel_flow(12000, 0.8, 20, mode)
%wf = m_engine.f_thrust_to_fuel(12000, 0.8, 20, (fn/4))

NOx = m_engine.f_emision_indices(12000, 0.8, 20, m_engine.pollutant.NOx, wf)
CO2 = m_engine.f_emision_indices(12000, 0.8, 20, m_engine.pollutant.CO2, wf)
UHC = m_engine.f_emision_indices(12000, 0.8, 20, m_engine.pollutant.UHC, wf)
CO = m_engine.f_emision_indices(12000, 0.8, 20, m_engine.pollutant.CO, wf)

A380.displayInfo()

% altitudes = [8000, 13000];
% for i = 1:length(altitudes)
%     fn_test = 100000; % example fixed thrust
%     n1 = m_engine.f_thrust_to_fan_speed(altitudes(i), 0.8, 0, fn_test);
%     wf = m_engine.f_fuel_flow_model(altitudes(i), 0.8, 0, n1);
%     fprintf("Altitude: %d m -> n1 = %.2f, wf = %.4f kg/s\n", altitudes(i), n1, wf);
% end

% return 

m_trim.f_trim(m_convert.f_length(36500, 'ft', 'm'), 0.8, 0, A380)

% [m, fb, x] = m_trajectory.f_state_cruise(9000, 0.8, 0, A380, 3000, 0, 3, 13000, m_engine.mode.nmcl)

A380.currentWeight

A380.resetWeight();

[m, fb, x] = m_trajectory.f_state_cruise(13500, 0.8, 0, A380, 3000, 0, 0)

A380.resetWeight();

[m, fb, x] = m_trajectory.f_state_cruise(14500, 0.8, 0, A380, 3000, 0, 0)
A380.resetWeight();


[m, fb, x] = m_trajectory.f_state_cruise(14000, 0.8, 0, A380, 3000, 0, 0)


A380.currentWeight


altitudes = 7000:500:16000; % step of 500 m (adjust as needed)
fb_values = zeros(size(altitudes));
CO_values = zeros(size(altitudes));
NOx_values = zeros(size(altitudes));
UHC_values = zeros(size(altitudes));
CO2_values = zeros(size(altitudes));
A380.resetWeight();


[wf, alpha, delta, fn] = m_trim.f_trim(11000, 0.8, 0, A380)

% Loop through altitudes
for i = 1:length(altitudes)
    altitude = altitudes(i);
    fprintf('\naltitude = %d\n', altitude);
    A380.resetWeight();
    [~, fb, ~, CO, NOx, UHC, CO2] = m_trajectory.f_state_cruise(altitude, 0.8, 0, A380, 10000, 0, 0);
    fb_values(i) = fb;
    fbc = fb / (m_atmos.f_delta(altitude)*sqrt(m_atmos.f_theta(altitude, 0)));
    CO_values(i) = CO;
    NOx_values(i) = NOx;
    CO2_values(i) = CO2;
    UHC_values(i) = UHC;
    A380.displayInfo();
end

% Display results
disp('Altitude (m)    fb')
disp([altitudes' fb_values'])

% Optional: Plot the result
figure;
plot(altitudes, fb_values, '-o');
xlabel('Altitude (m)');
ylabel('Fuel Burn (kg)');
title('Fuel Burn vs Altitude sur 10 000 m.n.');
grid on;

figure;
semilogy(altitudes, CO_values, altitudes, NOx_values, altitudes, CO2_values, altitudes, UHC_values);
xlabel('Altitude (m)');
title("Quantité d'émissions éjecté en fonction de l'altitude sur 10 000 m.n.");
ylabel("Masse d'émissions (kg)")
legend({'CO','NOx', 'CO_2', 'UHC'},'Location','best');

%% Détermination des Mach MRC et LRC

% Paramètres pour le calcul
altitude = 11000; % [m]
ISA_dev = 0;
V_W = 0;

A380.resetWeight();
% Obtenir masse et centrage courant
masse = A380.currentWeight;
xcg = A380.xcg;

% Calculs MRC et LRC
[Mach_MRC, SR_MRC, Mach_vect, SR_vect] = m_perf.f_find_MRC(altitude, ISA_dev, V_W, A380);
fprintf('--- Résultats MRC ---\n');
fprintf('Mach MRC = %.3f\n', Mach_MRC);
fprintf('SR MRC   = %.2f m/kg\n', SR_MRC);

[Mach_LRC, SR_LRC, ~, ~] = m_perf.f_find_LRC(altitude, ISA_dev, V_W, A380);
fprintf('\n--- Résultats LRC ---\n');
fprintf('Mach LRC = %.3f\n', Mach_LRC);
fprintf('SR LRC   = %.2f m/kg\n', SR_LRC);

% Affichage graphique
figure;
plot(Mach_vect, SR_vect, 'b-', 'LineWidth', 1.5); hold on;
plot(Mach_MRC, SR_MRC, 'ro', 'MarkerSize', 8, 'DisplayName', 'MRC');
plot(Mach_LRC, SR_LRC, 'gs', 'MarkerSize', 8, 'DisplayName', 'LRC');
xlabel('Mach');
ylabel('Specific Range (m/kg)');
title(sprintf('Specific Range vs Mach (Altitude = %d m)', altitude));
legend show;
grid on;

%% Tests sur des distances réelles

opts = detectImportOptions('airport-codes.csv');
opts.SelectedVariableNames = {'ident','iata_code','icao_code','coordinates'};
airports = readtable('airport-codes.csv', opts);
coords = split(airports.coordinates, ',');
airports.Latitude = str2double(coords(:,2));
airports.Longitude = str2double(coords(:,1));

% Paramètres du vol
altitude = 11000;        % m
mach = Mach_LRC;              % Mach
origin = "YUL";
destination = "CDG";

% Distance (en naut. miles)
dist = m_convert.f_length(m_trajectory.f_airport_distance(origin, destination, airports), 'km', 'naut mi');

% Simulation du vol en croisière
[~, fb, ~, mass_CO, mass_NOx, mass_UHC, mass_CO2] = m_trajectory.f_state_cruise(altitude, mach, 0, A380, dist, 0, 0);

altitude_max = 13000;

% Création du tableau
Results = table( ...
    ["Fuel Burn (kg)"; "CO (kg)"; "NOx (kg)"; "CO2 (kg)"; "UHC (kg)"], ...
    [fb; mass_CO; mass_NOx; mass_CO2; mass_UHC], ...
    'VariableNames', {'Quantité', 'Valeur'});

% Affichage
disp("=== Résultats du vol " + origin + " → " + destination + " ===");
disp("Altitude = " + altitude + " m, Mach = " + mach);
disp(Results);

[~, fb, ~, mass_CO, mass_NOx, mass_UHC, mass_CO2] = m_trajectory.f_state_cruise(altitude, mach, 0, A380, dist, 0, 1, altitude_max, m_engine.mode.nmcl);


% Création du tableau
Results = table( ...
    ["Fuel Burn (kg)"; "CO (kg)"; "NOx (kg)"; "CO2 (kg)"; "UHC (kg)"], ...
    [fb; mass_CO; mass_NOx; mass_CO2; mass_UHC], ...
    'VariableNames', {'Quantité', 'Valeur'});

% Affichage
disp("=== Résultats du vol " + origin + " → " + destination + " ===");
disp("Altitude initiale = " + altitude + " m, Altitude finale = " + altitude_max + " m, Mach = " + mach + ", step climb = 1");
disp(Results);

[~, fb, ~, mass_CO, mass_NOx, mass_UHC, mass_CO2] = m_trajectory.f_state_cruise(altitude, mach, 0, A380, dist, 0, 2, altitude_max, m_engine.mode.nmcl);


% Création du tableau
Results = table( ...
    ["Fuel Burn (kg)"; "CO (kg)"; "NOx (kg)"; "CO2 (kg)"; "UHC (kg)"], ...
    [fb; mass_CO; mass_NOx; mass_CO2; mass_UHC], ...
    'VariableNames', {'Quantité', 'Valeur'});

% Affichage
disp("=== Résultats du vol " + origin + " → " + destination + " ===");
disp("Altitude initiale = " + altitude + " m, Altitude finale = " + altitude_max + " m, Mach = " + mach + ", step climb = 2");
disp(Results);

[~, fb, ~, mass_CO, mass_NOx, mass_UHC, mass_CO2] = m_trajectory.f_state_cruise(altitude, mach, 0, A380, dist, 0, 10, altitude_max, m_engine.mode.nmcl);


% Création du tableau
Results = table( ...
    ["Fuel Burn (kg)"; "CO (kg)"; "NOx (kg)"; "CO2 (kg)"; "UHC (kg)"], ...
    [fb; mass_CO; mass_NOx; mass_CO2; mass_UHC], ...
    'VariableNames', {'Quantité', 'Valeur'});

% Affichage
disp("=== Résultats du vol " + origin + " → " + destination + " ===");
disp("Altitude initiale = " + altitude + " m, Altitude finale = " + altitude_max + " m, Mach = " + mach + ", step climb = 10");
disp(Results);



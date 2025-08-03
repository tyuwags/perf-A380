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


A380 = m_plane.Plane(geom_data, aero_data, 500000, 40, 25, phi_t);

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

fn = m_engine.f_thrust(12000, 0.8, 20, mode)
wf = m_engine.f_fuel_flow(12000, 0.8, 20, mode)
wf = m_engine.f_thrust_to_fuel(12000, 0.8, 20, fn)

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

[m, fb, x] = m_trajectory.f_state_cruise(9000, 0.8, 0, A380, 3000, 0, 3, 13000)

A380.currentWeight

A380.resetWeight();

[m, fb, x] = m_trajectory.f_state_cruise(13500, 0.8, 0, A380, 3000, 0, 0)

A380.resetWeight();

[m, fb, x] = m_trajectory.f_state_cruise(14500, 0.8, 0, A380, 3000, 0, 0)
A380.resetWeight();


[m, fb, x] = m_trajectory.f_state_cruise(14000, 0.8, 0, A380, 3000, 0, 0)


A380.currentWeight


altitudes = 3000:500:15000; % step of 500 m (adjust as needed)
fb_values = zeros(size(altitudes));

% Loop through altitudes
for i = 1:length(altitudes)
    altitude = altitudes(i);
    fprintf('altitude = %d\n', altitude);
    A380.resetWeight();
    [~, fb, ~] = m_trajectory.f_state_cruise(altitude, 0.8, 0, A380, 10000, 0, 0);
    fb_values(i) = fb;
end

% Display results
disp('Altitude (m)    fb')
disp([altitudes' fb_values'])

% Optional: Plot the result
figure;
plot(altitudes, fb_values, '-o');
xlabel('Altitude (m)');
ylabel('Fuel Burn (fb)');
title('Fuel Burn vs Altitude');
grid on;

%% Détermination des Mach MRC et LRC

% Paramètres pour le calcul
altitude = 11000; % [m]
ISA_dev = 0;
V_W = 0;

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

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


A380 = m_plane.Plane(geom_data, aero_data, 500000, 0.40, 0.25);

%% % Définition des données géométriques de l'avion
% Données de l'aile

%% %
m_convert.f_length(10000, 'ft', 'm')
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

m_trim.f_trim(12000, 0.8, 20, A380)



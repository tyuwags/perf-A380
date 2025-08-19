# Modèle de Performance A380 en Phase de Croisière

Ce projet propose un modèle de performance pour l'Airbus A380 en phase de croisière. Il permet d'analyser différents aspects des performances de l'avion, notamment la consommation de carburant et les émissions polluantes.

## Structure du Projet

Le projet est organisé de la manière suivante :
- `Aircraft/` : Contient les données de l'avion
  - `aero_data.mat` : Données aérodynamiques
- `Modules/` : Contient les différents modules de calcul
- `Main_program.m` : Programme principal

## Prérequis

- MATLAB
- Fichier de données aérodynamiques (`aero_data.mat`)
- Fichier des aéroports (`airport-codes.csv`)

## Fonctionnalités Principales

### 1. Initialisation de l'Avion

```matlab
A380 = m_plane.Plane(geom_data, aero_data, masse, xcg, phi, phi_t, alpha, delta, fn, n1, gamma);
```

### 2. Calculs Atmosphériques
- Vitesse du son : `m_atmos.f_speed_sound(altitude, deviation_ISA)`
- Pression : `m_atmos.f_pressure(altitude)`
- Conversions de vitesse : 
  ```matlab
  m_convert.f_cas_to_mach(cas, altitude, deviation_ISA)
  m_convert.f_cas_to_tas(cas, altitude, deviation_ISA)
  ```

### 3. Analyse des Performances Moteur

```matlab
% Calcul de la poussée en montée
fn = m_engine.f_thrust(altitude, mach, deviation_ISA, mode)

% Calcul du débit carburant en montée
wf = m_engine.f_fuel_flow(altitude, mach, deviation_ISA, mode)

% Calcul des émissions
NOx = m_engine.f_emision_indices(altitude, mach, deviation_ISA, m_engine.pollutant.NOx, wf)
CO2 = m_engine.f_emision_indices(altitude, mach, deviation_ISA, m_engine.pollutant.CO2, wf)
```

### 4. Analyse de Croisière

```matlab
% Simulation d'une phase de croisière avec step climb
[m, fb, x] = m_trajectory.f_state_cruise(altitude, mach, vent, avion, distance, deviation_ISA, nb_step_climb, altitude_m_max, mode)
```

### 5. Optimisation du Vol

Le programme permet de déterminer :
- Le Mach de croisière optimum (MRC - Maximum Range Cruise)
- Le Mach économique (LRC - Long Range Cruise)

```matlab
[Mach_MRC, SR_MRC] = m_perf.f_find_MRC(altitude, deviation_ISA, vent, avion)
[Mach_LRC, SR_LRC] = m_perf.f_find_LRC(altitude, deviation_ISA, vent, avion)
```

## Exemples d'Utilisation

### 1. Simulation d'un Vol entre Deux Aéroports

```matlab
% Paramètres du vol
altitude = 11000;        % m
mach = Mach_LRC;        % Mach number
origin = "YUL";         % Montréal
destination = "CDG";    % Paris

% Simulation du vol
[~, fb, ~, mass_CO, mass_NOx, mass_UHC, mass_CO2] = m_trajectory.f_state_cruise(altitude, mach, 0, A380, dist, 0, 0);
```

### 2. Analyse des Performances en Fonction de l'Altitude

```matlab
altitudes = 7000:500:16000;
for i = 1:length(altitudes)
    altitude = altitudes(i);
    [~, fb, ~, CO, NOx, UHC, CO2] = m_trajectory.f_state_cruise(altitude, 0.8, 0, A380, 10000, 0, 0);
    % Analyse des résultats...
end
```

## Visualisation des Résultats

Le programme génère automatiquement plusieurs graphiques :
- Consommation de carburant en fonction de l'altitude
- Émissions polluantes en fonction de l'altitude
- Specific Range en fonction du nombre de Mach

## Notes
- Tous les calculs peuvent être effectués avec différentes déviations ISA
- Le modèle prend en compte les step climbs pour optimiser la consommation
- Les résultats incluent les émissions de CO, NOx, CO2 et UHC

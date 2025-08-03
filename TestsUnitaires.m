classdef TestsUnitaires < matlab.unittest.TestCase
    % Classe de tests unitaires pour le dépôt perf-A380

    properties
        AeroData % Propriété pour stocker aero_data
    end

    methods (TestMethodSetup)
        function loadAeroData(testCase)
            % Ajoutez le chemin et chargez les données avant chaque test
            addpath('Aircraft/', 'Modules/');
            data = load('Aircraft/aero_data.mat');
            testCase.AeroData = data.aero_data;
        end
    end

    methods (Test)
        function testAeroDataLoaded(testCase)
            % Vérifiez que la structure aero_data est bien chargée
            testCase.verifyNotEmpty(testCase.AeroData, ...
                'La structure aero_data n''a pas été chargée correctement.');
        end

        %% Tests pour les conversions entre Mach et CAS
        function testMachToCasToMach(testCase)
            altitude = 11000; % Altitude en mètres
            Mach = 0.8; % Nombre de Mach
            cas = m_convert.f_mach_to_cas(Mach, altitude);
            MachBack = m_convert.f_cas_to_mach(cas, altitude, 0); % ISA deviation = 0
            testCase.verifyEqual(Mach, MachBack, 'AbsTol', 1e-3, ...
                'Conversion Mach <-> CAS échoue');
        end

        function testCasLimits(testCase)
            altitude = [0, 11000, 20000]; % Altitudes variées
            Mach = [0.1, 0.9]; % Mach limites
            for a = altitude
                for m = Mach
                    cas = m_convert.f_mach_to_cas(m, a);
                    testCase.verifyGreaterThan(cas, 0, ...
                        'CAS devrait être positif');
                end
            end
        end

        function testMachAndTAS(testCase)
            % [Altitude (m), Mach, vitesse du son (m/s), TAS attendu (m/s)]
            data = [
                0,     0.80, 340.29, 272.23;
                900,   0.78, 336.82, 262.72;
                1500,  0.85, 334.49, 284.31;
                2100,  0.75, 332.14, 249.11;
                3000,  0.88, 328.58, 289.15;
                3900,  0.82, 324.99, 266.49;
                4500,  0.76, 322.57, 245.15;
                5100,  0.84, 320.14, 268.92;
                5700,  0.90, 317.69, 285.92;
                900,   0.95, 336.82, 319.98
            ];

            isa_dev = 0;

            for i = 1:size(data, 1)
                h = data(i, 1);
                Mach = data(i, 2);
                a_ref = data(i, 3);
                TAS_expected = data(i, 4);

                % Calcul de la vitesse du son avec ton modèle
                a = m_atmos.f_speed_sound(h, isa_dev);
                testCase.verifyEqual(a, a_ref, 'AbsTol', 0.5, ...
                    sprintf('Vitesse du son incorrecte à %.0f m', h));

                % Calcul de TAS = Mach × a
                TAS = Mach * a;
                testCase.verifyEqual(TAS, TAS_expected, 'AbsTol', 1.0, ...
                    sprintf('TAS incorrect à %.0f m pour Mach %.2f', h, Mach));

                % Vérifie aussi le Mach recalculé à partir de TAS
                Mach_back = TAS / a;
                testCase.verifyEqual(Mach_back, Mach, 'AbsTol', 1e-3, ...
                    sprintf('Mach recalculé incorrect à %.0f m', h));
            end
        end


        %% Tests pour le modèle atmosphérique
        function testTemperatureISA(testCase)
            altitude = 11000; % Altitude troposphérique
            isa_dev = 0; % Aucune déviation ISA
            expectedTemp = 216.65; % Température attendue en Kelvin
            temp = m_atmos.f_temperature(altitude, isa_dev);
            testCase.verifyEqual(temp, expectedTemp, 'AbsTol', 1e-2, ...
                'Température incorrecte pour les conditions ISA standard');
        end

        function testDeltaPressure(testCase)
            altitude = 11000; % Altitude
            delta = m_atmos.f_delta(altitude);
            testCase.verifyGreaterThan(delta, 0, ...
                'Delta (pression relative) devrait être positif');
        end

        function testAtmosphericValuesAtAltitudes(testCase)
            % Tableau d'altitudes et valeurs de référence issues du tableau (image fournie)
            data = [
                0,      288.16, 1.01325e5, 1.2250, 340.29;
                300,    286.21, 9.7773e4, 1.1901, 339.14;
                900,    282.31, 9.0971e4, 1.1226, 336.82;
                1500,   278.41, 8.4560e4, 1.0581, 334.49;
                2100,   274.51, 7.8520e4, 0.99649, 332.14;
                3000,   268.67, 7.0121e4, 0.90926, 328.58;
                3900,   262.83, 6.2467e4, 0.82800, 324.99;
                4500,   258.93, 5.7752e4, 0.77704, 322.57;
                5100,   255.04, 5.3331e4, 0.72851, 320.14;
                5700,   251.14, 4.9188e4, 0.68234, 317.69;
                6000,   249.20, 4.7217e4, 0.66011, 316.45;
                6300,   247.25, 4.5311e4, 0.63845, 315.21;
                6600,   245.30, 4.3468e4, 0.61733, 313.97;
                6900,   243.36, 4.1686e4, 0.59676, 312.72;
                7200,   241.41, 3.9963e4, 0.57671, 311.47;
                7500,   239.47, 3.8299e4, 0.55719, 310.21;
                7800,   237.52, 3.6692e4, 0.53818, 308.95;
                8100,   235.58, 3.5140e4, 0.51967, 307.68;
                8400,   233.63, 3.3642e4, 0.50165, 306.41;
                8700,   231.69, 3.2196e4, 0.48412, 305.13;
                9000,   229.74, 3.0800e4, 0.46706, 303.85;
                9300,   227.80, 2.9455e4, 0.45047, 302.56;
                9600,   225.85, 2.8157e4, 0.43433, 301.27;
                9900,   223.91, 2.6906e4, 0.41864, 299.97;
                10200,  221.97, 2.5701e4, 0.40339, 298.66;
                10500,  220.02, 2.4540e4, 0.38857, 297.35;
                10800,  218.08, 2.3422e4, 0.37417, 296.03;
                11100,  216.66, 2.2346e4, 0.35932, 295.07;
                11400,  216.66, 2.1317e4, 0.34277, 295.07;
                11700,  216.66, 2.0335e4, 0.32699, 295.07;
                12000,  216.66, 1.9399e4, 0.31194, 295.07;
                12300,  216.66, 1.8506e4, 0.29758, 295.07;
                12600,  216.66, 1.7654e4, 0.28388, 295.07;
                12900,  216.66, 1.6842e4, 0.27081, 295.07;
                13200,  216.66, 1.6067e4, 0.25835, 295.07;
                13500,  216.66, 1.5327e4, 0.24646, 295.07;
                13800,  216.66, 1.4622e4, 0.23512, 295.07;
                14100,  216.66, 1.3950e4, 0.22430, 295.07;
                14400,  216.66, 1.3308e4, 0.21399, 295.07;
                14700,  216.66, 1.2696e4, 0.20414, 295.07;
                15000,  216.66, 1.2112e4, 0.19475, 295.07;
                15300,  216.66, 1.1555e4, 0.18580, 295.07;
                15600,  216.66, 1.1023e4, 0.17725, 295.07;
                15900,  216.66, 1.0516e4, 0.16910, 295.07;
                16200,  216.66, 1.0033e4, 0.16133, 295.07;
                16500,  216.66, 9.5717e3, 0.15391, 295.07;
                16800,  216.66, 9.1317e3, 0.14683, 295.07;
                17100,  216.66, 8.7119e3, 0.14009, 295.07;
                17400,  216.66, 8.3115e3, 0.13365, 295.07;
                17700,  216.66, 7.9295e3, 0.12751, 295.07;
                18000,  216.66, 7.5652e3, 0.12165, 295.07;
                18300,  216.66, 7.2175e3, 0.11606, 295.07;
                18600,  216.66, 6.8859e3, 0.11072, 295.07;
                18900,  216.66, 6.5696e3, 0.10564, 295.07
            ];
            
            isa_dev = 0; % Standard atmosphere

            for i = 1:size(data, 1)
                h = data(i, 1);
                T_ref = data(i, 2);
                P_ref = data(i, 3);
                rho_ref = data(i, 4);
                a_ref = data(i, 5);

                % Appel des fonctions du modèle
                T = m_atmos.f_temperature(h, isa_dev);
                P = m_atmos.f_pressure(h, isa_dev);
                rho = m_atmos.f_density(h, isa_dev);
                a = m_atmos.f_speed_sound(h, isa_dev);

                % Vérifications avec tolérances raisonnables
                testCase.verifyEqual(T, T_ref, 'AbsTol', 0.2, ...
                    sprintf('Température incorrecte à %.0f m', h));
                testCase.verifyEqual(P, P_ref, 'RelTol', 5e-2, ...
                    sprintf('Pression incorrecte à %.0f m', h));
                testCase.verifyEqual(rho, rho_ref, 'RelTol', 5e-2, ...
                    sprintf('Densité incorrecte à %.0f m', h));
                testCase.verifyEqual(a, a_ref, 'AbsTol', 0.5, ...
                    sprintf('Vitesse du son incorrecte à %.0f m', h));
            end

        end


        function testTrim(testCase)
            % Paramètres d'entrée pour l'équilibrage
            altitude = 11000; % Altitude en mètres
            Mach = 0.8;       % Nombre de Mach
            ISA_dev = 0;      % Déviation ISA (nulle)

            plane = loadPlane();

            % Appeler la fonction f_trim
            W_F = m_trim.f_trim(altitude, Mach, ISA_dev, plane);

            % Vérifier que le poids de portance calculé est cohérent
            testCase.verifyGreaterThan(W_F, 0, ...
                'La portance calculée devrait être positive.');
            testCase.verifyLessThan(W_F, plane.currentWeight, ...
                'La portance ne devrait pas dépasser le poids de l''avion.');
        end

        %% Tests pour les performances (MRC et LRC)
        function testFindMRC(testCase)
            altitude = 11000; % Altitude en mètres
            ISA_dev = 0; % Pas de déviation ISA
            V_W = 0; % Pas de vent
            plane = loadPlane(); % Charger un objet avion valide
            [Mach_MRC, SR_MRC, ~, ~] = m_perf.f_find_MRC(altitude, ISA_dev, V_W, plane);
            testCase.verifyGreaterThan(Mach_MRC, 0, ...
                'Mach MRC devrait être positif');
            testCase.verifyGreaterThan(SR_MRC, 0, ...
                'Specific Range MRC devrait être positif');
        end

        function testFindLRC(testCase)
            altitude = 11000; % Altitude en mètres
            ISA_dev = 0; % Pas de déviation ISA
            V_W = 0; % Pas de vent
            plane = loadPlane(); % Charger un objet avion valide
            [Mach_LRC, SR_LRC, Mach_MRC, SR_MRC] = m_perf.f_find_LRC(altitude, ISA_dev, V_W, plane);
            testCase.verifyGreaterThan(Mach_LRC, Mach_MRC, ...
                'Mach LRC devrait être positif');
            testCase.verifyGreaterThan(SR_MRC, SR_LRC, ...
                'Specific Range LRC devrait être positif');
        end

        %% Tests pour les trajectoires
        function testStateCruise(testCase)
            altitude = 11000; % Altitude initiale
            mach_nb = 0.8; % Nombre de Mach
            isa_dev = 0; % Pas de déviation ISA
            plane = loadPlane(); % Charger un objet avion valide
            dist = 1000; % Distance de croisière en mètres
            [m, fb, ~] = m_trajectory.f_state_cruise(altitude, mach_nb, isa_dev, plane, dist, 0, 0, altitude);
            testCase.verifyGreaterThan(m, 0, ...
                'La masse finale devrait être positive');
            testCase.verifyGreaterThan(fb, 0, ...
                'La consommation de carburant devrait être positive');
        end

        %% Tests pour les interpolations aérodynamiques
        function testInterpolationCoefficients(testCase)
            alpha = 5; % Angle d'attaque en degrés
            mach = 0.8; % Mach
            aero_data = testCase.AeroData;
            CL_wb = interp2(aero_data.f_clwb.y_mach, aero_data.f_clwb.x_alpha, ...
                aero_data.f_clwb.value, mach, alpha, 'spline');
            testCase.verifyGreaterThan(CL_wb, 0, ...
                'Coefficient de portance interpolé devrait être positif');
        end
    end
end

function plane = loadPlane()
    % Charger un objet avion pour les tests
    load('Aircraft/aero_data.mat', 'aero_data');
    geom_data.wing.S_ref = 859;
    geom_data.wing.c_ref = 11;
    geom_data.stab.S_ref = 205;
    geom_data.stab.x_ref = 32.0;
    geom_data.stab.z_ref = 1.24;
    geom_data.engine.x_ref_23 = 6.00;
    geom_data.engine.z_ref_23 = 1.60;
    geom_data.engine.x_ref_14 = 1.70;
    geom_data.engine.z_ref_14 = 0.50;
    phi_t = 2;
    plane = m_plane.Plane(geom_data, aero_data, 500000, 40, 25, phi_t);
end
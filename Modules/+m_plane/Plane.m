classdef Plane < handle
    properties
        % Géométrie aile
        wingArea
        wingChord

        % Géométrie stabilisateur
        stabArea
        stabX
        stabZ

        % Moteurs
        numEngines
        enginePositions % [x, z] pour chaque moteur

        % Coefficients aérodynamiques
        aeroCoeffs

        % Poids
        startingWeight

        currentWeight

        % Centre de gravité (h en % corde)
        hcg
        xcg

        % Centre aérodynamique (h en % corde)
        hac
        xac

        % Angle du moteur dans le repère avion
        phi_t
    end

    methods
        function obj = Plane(varargin)
            if nargin == 1 && isstruct(varargin{1})
                error('Mode structuré : veuillez aussi fournir aeroCoeffs, weight, hcg, hac, phi_t');
            elseif nargin >= 1 && isstruct(varargin{1})
                obj = obj.buildFromStruct(varargin{:});
            elseif nargin >= 11
                obj = obj.buildFromArgs(varargin{:});
            else
                error(['Constructeur mal utilisé. Utilisez :' newline ...
                       '  Plane(geom_data, aeroCoeffs, weight, hcg, hac, phi_t)' newline ...
                       'ou Plane(wingArea, wingChord, stabArea, stabX, stabZ, enginePositions, aeroCoeffs, weight, hcg, hac, phi_t)']);
            end

            % Calculs dérivés
            obj.xac = obj.hac * obj.wingChord / 100;
            obj.xcg = obj.hcg * obj.wingChord / 100;
            obj.currentWeight = obj.startingWeight;
        end

        function displayInfo(obj)
            fprintf('--- Caractéristiques de l''avion ---\n');
            fprintf('Aile : %.2f m², corde %.2f m\n', obj.wingArea, obj.wingChord);
            fprintf('Stabilisateur : %.2f m² à (x=%.2f, z=%.2f)\n', ...
                obj.stabArea, obj.stabX, obj.stabZ);
            fprintf('Moteurs : %d moteur(s)\n', obj.numEngines);
            for i = 1:obj.numEngines/2
                fprintf('  - Moteur %d à [x=%.2f, z=%.2f]\n', ...
                    i, obj.enginePositions(i, 1), obj.enginePositions(i, 2));
            end
            fprintf('Poids : %.2f\n', obj.currentWeight);
            fprintf('Centre de gravité (xcg) : %.2f m\n', obj.xcg);

            if isfield(obj.aeroCoeffs, 'f_clwb')
                fprintf('CL : Table avec %d valeurs\n', numel(obj.aeroCoeffs.f_clwb.value));
            end
            if isfield(obj.aeroCoeffs, 'f_cdwb')
                fprintf('CD : Table avec %d valeurs\n', numel(obj.aeroCoeffs.f_cdwb.value));
            end
            if isfield(obj.aeroCoeffs, 'f_cmwb')
                fprintf('CM : Table avec %d valeurs\n', numel(obj.aeroCoeffs.f_cmwb.value));
            end
        end

        function resetWeight(obj)
            obj.currentWeight = obj.startingWeight;
        end

        function fuelConsumed(obj, fuel_kg)
            obj.currentWeight = obj.currentWeight - fuel_kg;
        end

    end

    methods (Access = private)
        function obj = buildFromStruct(obj, geom, aeroCoeffs, weight, hcg, hac, phi_t)
            % Extraction géométrie aile et stabilisateur
            obj.wingArea = geom.wing.S_ref;
            obj.wingChord = geom.wing.c_ref;
            obj.stabArea = geom.stab.S_ref;
            obj.stabX = geom.stab.x_ref;
            obj.stabZ = geom.stab.z_ref;

            % Détection des moteurs
            enginePositions = [];
            if isfield(geom.engine, 'x_ref_14') && isfield(geom.engine, 'x_ref_23')
                enginePositions = [
                    geom.engine.x_ref_14, geom.engine.z_ref_14;
                    geom.engine.x_ref_23, geom.engine.z_ref_23
                ];
            elseif isfield(geom.engine, 'x_ref')
                enginePositions = [
                    geom.engine.x_ref, geom.engine.z_ref
                ];
            else
                error("Champ geom.engine incomplet ou invalide.");
            end

            obj.enginePositions = enginePositions;
            obj.numEngines = size(enginePositions, 1) * 2;

            % Autres données
            obj.aeroCoeffs = aeroCoeffs;
            obj.startingWeight = weight;
            obj.hcg = hcg;
            obj.hac = hac;
            obj.phi_t = phi_t;
        end

        function obj = buildFromArgs(obj, wingArea, wingChord, stabArea, stabX, stabZ, ...
                                     enginePositions, aeroCoeffs, weight, hcg, hac, phi_t)
            % Construction directe à partir de paramètres
            if size(enginePositions, 2) ~= 2
                error('enginePositions doit être une matrice Nx2 de [x z] par moteur.');
            end

            obj.wingArea = wingArea;
            obj.wingChord = wingChord;
            obj.stabArea = stabArea;
            obj.stabX = stabX;
            obj.stabZ = stabZ;
            obj.enginePositions = enginePositions;
            obj.numEngines = size(enginePositions, 1) * 2;
            obj.aeroCoeffs = aeroCoeffs;
            obj.startingWeight = weight;
            obj.hcg = hcg;
            obj.hac = hac;
            obj.phi_t = phi_t;
        end
    end
end

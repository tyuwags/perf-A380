classdef Plane
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
        enginePosCenter
        enginePosOuter

        % Coefficients aérodynamiques (sous-structures .f_clwb, etc.)
        aeroCoeffs

        % Poids de l'avion (en N ou kg à préciser)
        weight

        % Centre de gravité
        hcg
        xcg

        % Centre aérodynamique
        hac
        xac
        
    end

    methods
        function obj = Plane(varargin)
            if nargin >= 1 && isstruct(varargin{1})
                % --- Mode structuré avec geom_data + autres structures ---
                geom = varargin{1};

                % Vérifications minimales
                if nargin < 5
                    error('En mode structuré, utilisez : Plane(geom_data, aeroCoeffs, weight, hcg, hac)');
                end

                obj.wingArea = geom.wing.S_ref;
                obj.wingChord = geom.wing.c_ref;

                obj.stabArea = geom.stab.S_ref;
                obj.stabX = geom.stab.x_ref;
                obj.stabZ = geom.stab.z_ref;

                obj.numEngines = 4; % À modifier
                obj.enginePosCenter = [geom.engine.x_ref_23, geom.engine.z_ref_23];
                obj.enginePosOuter  = [geom.engine.x_ref_14, geom.engine.z_ref_14];

                obj.aeroCoeffs = varargin{2}; % ex: aero_data
                obj.weight = varargin{3};
                obj.hcg = varargin{4};
                obj.hac = varargin{5};

            elseif nargin >= 11
                % --- Mode à l'ancienne : tous les champs à la main ---
                obj.wingArea = varargin{1};
                obj.wingChord = varargin{2};
                obj.stabArea = varargin{3};
                obj.stabX = varargin{4};
                obj.stabZ = varargin{5};
                obj.numEngines = varargin{6};
                obj.enginePosCenter = varargin{7};
                obj.enginePosOuter = varargin{8};
                obj.aeroCoeffs = varargin{9};
                obj.weight = varargin{10};
                obj.hcg = varargin{11};
                obj.hac = varargin{12};
            else
                error('Constructeur mal utilisé : fournir geom_data, aeroCoeffs, weight, xcg ou au moins 11 paramètres.');
            end
            obj.xac = obj.hac*obj.wingChord;
            obj.xcg = obj.hcg * obj.wingChord;
        end

        function displayInfo(obj)
            fprintf('--- Caractéristiques de l''avion ---\n');
            fprintf('Aile : %.2f m², corde %.2f m\n', obj.wingArea, obj.wingChord);
            fprintf('Stabilisateur : %.2f m² à (x=%.2f, z=%.2f)\n', ...
                    obj.stabArea, obj.stabX, obj.stabZ);
            fprintf('Moteurs : %d moteur(s)\n', obj.numEngines);
            fprintf('  - Position centrale : [%.2f, %.2f]\n', obj.enginePosCenter);
            if ~isempty(obj.enginePosOuter)
                fprintf('  - Position externe  : [%.2f, %.2f]\n', obj.enginePosOuter);
            end
            fprintf('Poids : %.2f\n', obj.weight);
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
    end
end

function aero_table = f_readOpenVSPfileMAC(filename)

aero_table = [];
file_id = fopen(filename, 'r');

%%% Force la lecture du fichier
keep_reading = true;

%%% Lecture du fichier
while keep_reading
    
    % Lecture jusqu'à trouver le "solver_case" suivant
    curr_string = fgetl(file_id);
    while ischar(curr_string) && ~contains(curr_string, 'Solver Case:')
        % Cette ligne ne contient pas les mots clés "Solver Case"       
        curr_string = fgetl(file_id);
    end

    % If the end of file was reached, stop the main loop
    if ~ischar(curr_string),  break; end

    % Il faut continuer à lire au moins 6 lignes:
    for k = 1 : 7
        curr_string = fgetl(file_id);
    end
    
    % Récupération des données
    str_plit = strsplit(curr_string, ' ');
    data_tmp = zeros(1, length(str_plit)-2);
    for k = 1 : length(data_tmp)
        data_tmp(k) = str2double(str_plit{k+2}); 
    end
    
    % Stockage des données dans un tableau
    aero_table = [aero_table; data_tmp];

end

fclose(file_id);

data_name = {'Mach', 'AoA', 'Beta', 'CL', 'CDo', 'CDi', 'CDtot', 'CDt',...
    'CDtot_t', 'CS', 'LoD', 'E', 'CFx', 'CFy', 'CFz', 'CMx', 'CMy', 'CMz'};

aero_table = array2table(aero_table(:, 1:end-1), 'VariableNames', data_name);
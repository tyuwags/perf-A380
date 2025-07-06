function aero_table = f_readOpenVSPfileWIN(filename)

aero_table = [];
file_id = fopen(filename, 'r');

%%% Force la lecture du fichier
keep_reading = true;
var_read = false;

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
    
    max_read = 7;
    if ~var_read
        % Il faut continuer à lire au moins 2 lignes pour récupérer le nom des
        % variables
        for k = 1 : 2
            curr_string = fgetl(file_id);
        end
        str_plit = strsplit(curr_string, ' ');
        tmp_name = str_plit(3:end-2);
        max_read = 5;
    end

    % Il faut continuer à lire au moins 6 lignes:
    for k = 1 : max_read
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

aero_table = array2table(aero_table(:, 1:end-2), 'VariableNames', tmp_name);
try
    aero_table.CL = aero_table.CLtot;
    aero_table.CMy = aero_table.CMytot;
catch
end

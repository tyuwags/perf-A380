function force_out = f_force(force_in, unit_in, unit_out)
%F_FORCE Convert from force units to desired force units.
%   The function "F_FORCE" is a sub-routine of the convert module. This
%   function convert a force units (i.e lfb or N) to desired force unit
%   (i.e lbf or N). 
%
% Syntax:
%   output = m_convert.f_force(input, unit_in, unit_out);
%
% Inputs:
%   - force_in  : force value that the function is to convert,
%   - unit_in    : specified input force unit as string,
%   - unit_out   : specified output force unit as string.
% Outputs:
%   - force_out  : force value that the function has converted.
%
% Supported unit strings are:
%   'lbf'        : Pound force
%   'N'          : Newton
%
% Reference(s)
%   NONE
%
% Copyright 2016-2018 LARCASE - Laboratory of Applied Research in Active 
% Controls, Avionics and AeroServoElasticity.
% web url : http://www.larcase.etsmtl.ca/
%
% $ Creation by G. Ghazi$
% $ Revision: 1.0 $ $Date: 06/29/2017 by G. Ghazi$

%%% Create conversion table
conversion_table = {[],'lbf', 'N'; ...
    'lbf',1,4.448222000000000;...
    'N', 0.224808923655339, 1};

%%% Find the corresponding unit in the table
for i = 1 : length(conversion_table(:,1))
    if strcmpi(conversion_table{i,1}, unit_in)
        idx_line = i;
    end
end

for i = 1 : length(conversion_table(1,:))
    if strcmpi(conversion_table{1,i}, unit_out)
        idx_column = i;
    end
end

%%% Compute the conversion factor
slope = conversion_table{idx_line, idx_column};

%%% Compute the output
force_out = force_in.*slope;

%%% End of the funtion
end
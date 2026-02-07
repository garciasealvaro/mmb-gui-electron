function check = convert_code(name)

%%
% Input:    name of models
% Output:   check = 0, mod file could not be changed
%                 = 1, all mod files successfully changed

% This file converts mod file to dynare version >4.6
% Copy file 
% Read mod file
% Look for sequence to change
% Replace it
% Save mod file
oldpath=pwd;

%%
check=0;

cd(name);
%% Sequences which replace code
sequence_change = {};   %sequence to search
lines_change={};        %lines to add

%Loading policy rule coefficients
sequence_change{end+1} = "M_.param_names(i,:)";
lines_change{end+1}= "M_.param_names{i}";

% copy paste original code
%copyfile(name+".mod",name+"_orig.mod");
% Read the mod file as a cell with element being one line of code
% --- FIX FOR OCTAVE/LINUX START ---
if exist([name, '.mod'], 'file')
    raw_text = fileread([name, '.mod']); % Read all the file as an only string
    code = strsplit(raw_text, {'\n', '\r'}, 'CollapseDelimiters', false); % Cut by line breaks
    code = code(:);                      % Ensure that it is a column vector.
else
    error(['The file ' name '.mod cannot be found.']);
end
% --- FIX FOR OCTAVE/LINUX END ---
% Look for the sequences where to change code
% Look for the sequences where to change code
for j = 1:size(sequence_change, 2)
    % Vectorized replacement: applies the change to all lines at once.
    % This replaces the manual 'while' loop and index searching.
    code = strrep(code, sequence_change{1,j}, lines_change{1,j});
end

% Set check to 1 to indicate the conversion process ran
check = 1;

% create a mod file with the converted code
filename = [name, '.mod'];
fid = fopen(filename,'wt');
for k = 1:length(code)
fprintf(fid, '%s \n', code{k});
end
fclose(fid);

cd(oldpath)

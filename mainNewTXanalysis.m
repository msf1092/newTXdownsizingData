clear all; close all; format compact; clc;
%% Loading data
% Get a list of all text files in the folder
dir_in='C:\Users\qdmofa\OneDrive - TUNI.fi\Fincone II-adjunct\Asli\FINCONE II - Analytical tools\Codes\New TX\in';
dir_out = 'C:\Users\qdmofa\OneDrive - TUNI.fi\Fincone II-adjunct\Asli\FINCONE II - Analytical tools\Codes\New TX\out';
files = dir(dir_in);

% Initialize variables to store the largest and smallest file names and sizes
largest_file = '';
largest_size = 0;

% Loop through the files
for k = 1:length(files)
    % Get the file name and size
    file_name = files(k).name;
    file_size = files(k).bytes;

    % Compare the file size with the current largest and smallest si
    if file_size > largest_size
        % Update the largest file name and size
        largest_file = file_name;
        largest_size = file_size;
    end
end

% Load the largest file as a table named "in" with tab delimiter and comma decimal separator
in = readtable(fullfile(dir_in, largest_file), 'Delimiter', '\t', 'DecimalSeparator', ','); %, ...
% Remove the initial measurements before the test starts:

% After calculation n save as txt, strings appear. To change em to number:
for i = 1:width(in)
    if iscell(in.(i))
        temp_col = in.(i);
        in.(i) = str2double(temp_col);
    end
end

if in.Askeleet(1) == 0
    while in.Askeleet(1) == 0
        in(1,:) = [];
    end
end

% Sort the files by their size in ascending order and get the sorted indices
[~, sorted_indices] = sort([files.bytes]);

% Get the index of the third smallest file
third_smallest_index = sorted_indices(3);

% Get the file name and size of the third smallest file
third_smallest_file = files(third_smallest_index).name;
third_smallest_size = files(third_smallest_index).bytes;

% Create an import options object for the third smallest file that can detect the decimal separator
opts = detectImportOptions(fullfile(dir_in, third_smallest_file), 'Delimiter', '\t');

% Load the third smallest file as a table named "info" with tab delimiter and detected decimal separator
info = readtable(fullfile(dir_in, third_smallest_file), opts);
%% Downsizing the table
% Selection of the required params, as they need to be transferred to Excel:
in_smaller = [in(:,"Aika_s_"), ...
    in(:,"SuhteellinenKokoonpuristuma___"), ...
    in(:,"Maksimileikkausj_nnitys_kPa_"), ...
    in(:,"Huokosvedenpaine_kPa_"), ...
    in(:,"Sellipaine_mitattu_kPa_"), ...
    in(:,"SuhteellinenTilavuudenMuutos___"), ...
    in(:,"Voimamittaus_kg_"), ...
    in(:,"Siirtym__mm_"), ...
    in(:,"Vaaka_g_"), ...
    table(5*ones(height(in),1))];

% Downsizing:
time = in.Aika_s_;
strain = in.SuhteellinenKokoonpuristuma___;

[time_downsized, strain_downsized, ind_downsizing] = fnc_downsize_time_strain(time, strain, 246);
% The two following lines are repeated in other lines. They had better move
% below (but now I have done it temporarily!:
in_new = in_smaller(ind_downsizing,:);


%% save the table to a text file
filename = fullfile(dir_out, 'Output_excel.txt');
writetable(in_new, filename, 'Delimiter', '\t');





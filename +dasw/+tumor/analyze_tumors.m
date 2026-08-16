function t = analyze_tumors(folder, conditionName)
% ANALYZE_TUMORS - Analyze folder of data
%  T = dasw.tumor.analyze_tumors(FOLDERNAME, CONDITIONNAME)
%
%  Steps through all subdirectories of the folder
%  FOLDERNAME and looks for files called
%  'tumor_data.txt'.
%
%  If it finds one, then it performs a fit
%  using dasw.tumor.tumorfit.m.
%
%  The function then builds a table T of all such entries with
%  the CHANGE, RATE, and A, B, C, D parameters returned. There
%  is a column "Condition" that is set to CONDITIONNAME, and a
%  column "File" with the path to the data file.

subdirs = dir(folder);

t = []; % start with an empty variable

for i=1:numel(subdirs),
    if subdirs(i).isdir & ~strcmp(subdirs(i).name,'.') & ~strcmp(subdirs(i).name,'..'),
        filename = [folder filesep subdirs(i).name filesep 'tumor_data.txt'];
        if isfile(filename),
            disp(['Analyzing file ' filename '.']);
            data = load(filename,'-ascii');
            [change_,rate_,a_,b_,c_,d_] = dasw.tumor.tumorfit(data,5);
            t_here = array2table([change_ rate_ a_ b_ c_ d_],...
                'VariableNames',["Change" "Rate" "a" "b" "c" "d"]);
            t_condition = array2table(string(conditionName),...
                'VariableNames',"Condition");
            t_filename = array2table(string(filename),...
                'VariableNames',"File");
            t = [t ; t_here t_condition t_filename];
        end;
    end;
end;

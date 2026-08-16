function t = analyze_tumors_plot(folder, conditionName, plotit)
% ANALYZE_TUMORS_PLOT - Analyze folder of data and plot each fit
%  T = dasw.tumor.analyze_tumors_plot(FOLDERNAME, CONDITIONNAME, PLOTIT)
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
%
%  If PLOTIT is 1, then the function also plots each fit.

subdirs = dir(folder);
t = []; % empty variable for table
if plotit, fig = figure; else, fig = []; end;
plot_number = 1;
for i=1:numel(subdirs),
    if subdirs(i).isdir & ~strcmp(subdirs(i).name,'.') & ~strcmp(subdirs(i).name,'..'),
        filename = [folder filesep subdirs(i).name filesep 'tumor_data.txt'];
        if isfile(filename),
            disp(['Analyzing file ' filename '.']);
            data = load(filename,'-ascii');
            [change_,rate_,a_,b_,c_,d_] = dasw.tumor.tumorfit(data,5);
            if plotit,
                dasw.plot.supersubplot(fig, 3, 3, plot_number);
                dasw.tumor.tumorplot(data, a_, b_, c_, d_);
                title([subdirs(i).name ', C%=' int2str(change_) ', R=' num2str(rate_,2)]);
                plot_number = plot_number + 1;
            end;
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

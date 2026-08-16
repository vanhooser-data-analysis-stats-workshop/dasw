function [ performance_individual, performance_100 ] = drugvsplacebo(mode)
%DRUGvSPLACEBO - A fun stats game where you pick drug or placebo?
%   [PERFORMANCE_INDIVIDUAL, PERFORMANCE_100] =
%        DRUGVSPLACEBO(MODESTRING)
%
%   Inputs:  MODESTRING - Can be one of
%                Nothing - raw numbers are provided
%                'MEAN'   only means are provided
%                'MEDIAN' only medians are provided
%                'PERCENTILERANGE' - 20/80% percentiels
%                'BARGRAPHRANGE' - bar graphs with range
%                'HISTOGRAM' - Histograms
%                'CUMULATIVEHISTOGRAM' - Cumulative histograms


if nargin==0, modestr = 'numbers';
else, modestr = mode;
end;

 % 1 - have to generate the data sets
       % Involves picking distribution, parameters and getting data points

dist1 = 'normal';
dist2 = 'normal';
stddev = [0.1 0.5 1 2 3];
mn1 = randn;
mn2 = randn;
s1 = randperm(numel(stddev));
s1 = s1(1);
s2 = randperm(3);
if s1==1, s2 = s2(1);
elseif s1==numel(stddev), s2 = numel(stddev)+(s2(1)-3);
else, s2 = s2(1)-2 + s1;
end;
params1 = { stddev(s1)*mn1 stddev(s1)};
params2 = { stddev(s2)*mn2 stddev(s2)};

code = mod(round(1000*rand),1000);
printcode = 0;

orig_modestr = modestr;

if (rand-1)<code&modestr(1)=='*',
	params2 = params1;
	modestr = modestr(2:end);
	printcode = 1;
end;

switch lower(modestr),
    case 'numbers',
        N1 = 10;
        N2 = 10;
    otherwise,
        ns = icdf('uniform',rand(2,1),log(10),log(2000));
        N1 = ceil(exp(ns(1)));
        N2 = ceil(exp(ns(2)));
end;

s = struct('dist1',dist1,'dist2',dist2,'N1',N1,'N2',N2,'params1',{params1},'params2',{params2});

s.data1 = dasw.stats.generate_random_data(s.N1,s.dist1,s.params1{:});
s.data2 = dasw.stats.generate_random_data(s.N2,s.dist2,s.params2{:});

 % 2 - display the data

f=dasw.plot.displaydrugvsplacebo(modestr, s.data1, s.data2);

 % 3 - ask the user: Do you want the drug or placebo?  Do you think one
 % choice is much better than the other?

muchbetter = questdlg('Do you think one choice is a lot better than the other?','What is your confidence','Much better','Not much better','Not different','Not different');
choice = questdlg('Which do you choose?', 'Make your choice', 'Drug', 'Placebo','Drug');

 % 4 - calculate the odds and display the answer:

user_drug = dasw.stats.generate_random_data(1,s.dist1,s.params1{:});
user_placebo = dasw.stats.generate_random_data(1,s.dist2,s.params2{:});

many_drug = dasw.stats.generate_random_data(100,s.dist1,s.params1{:});
many_placebo = dasw.stats.generate_random_data(100,s.dist2,s.params2{:});

if user_drug>user_placebo, better = 'drug';
else, better = 'placebo';
end;

str = {};

str{end+1} = ['You chose ' choice ' and said that one choice was ' lower(muchbetter) ' than the other.'];
str{end+1} = '';
str{end+1} = ['We simulated one person taking the drug and one person taking the placebo.'];
str{end+1} = ['The simulated person who took the drug lived ' num2str(user_drug,2) ' years.'];
str{end+1} = ['The simulated person who took the placebo lived ' num2str(user_placebo,2) ' years.'];
str{end+1} = ['The simulated person might have lived longer with the ' better '.'];
str{end+1} = '';
str{end+1} = ['If 100 people took the drug, they''d live on average ' num2str(mean(many_drug)) ' years.'];
str{end+1} = ['If 100 people took the placebo, they''d live on average ' num2str(mean(many_placebo)) ' years.'];
str{end+1} = ['Of 100 people, ' int2str(sum(many_drug>many_placebo)) ' (' num2str(100*sum(many_drug>many_placebo)/100) '%) might have lived longer in the drug group.'];
str{end+1} = '';
str{end+1} = '';
str{end+1} = 'Would you like to play again?';
if printcode, str{end+1} = ['Code is ' sprintf('%.3d',code) '.']; end;

ans = questdlg(str, 'Would you like to play again', 'Yes','No','Yes');

if strcmp(ans,'Yes'),
    try, close(f); end;
    dasw.stats.drugvsplacebo(orig_modestr);
end;

try, close(f); end;

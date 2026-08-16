function f = displaydrugvsplacebo(modestr, data1, data2)
% DISPLAYDRUGVSPLACEBO - Display data from game drugvsplacebo
%     DISPLAYDRUGVSPLACEBO(MODE, DATA1, DATA2)
%
%


f = [];

switch (lower(modestr)),
    case 'numbers',
         disp(' ');         disp(' ');
         t1 = array2table(sort(data1),'VariableNames',{'Drug group'});
         t2 = array2table(sort(data2),'VariableNames',{'Placebo group'});
         f = figure;
         uit1 = uitable('Data',t1{:,:},'ColumnName',t1.Properties.VariableNames,...
             'units','normalized','position',[0.0 0 0.4 1]);
         uit2 = uitable('Data',t2{:,:},'ColumnName',t2.Properties.VariableNames,...
             'units','normalized','position',[0.5 0 0.4 1]);
         disp(['   Drug group: ' num2str(sort(data1)',2)]);
         disp(['Placebo group: ' num2str(sort(data2)',2)]);
    case 'mean',
         disp(' ');         disp(' ');
         disp(['   Drug group mean: ' num2str(mean(sort(data1))',2) ', N=' int2str(numel(data1)) '.']);
         disp(['Placebo group mean: ' num2str(mean(sort(data2))',2) ', N=' int2str(numel(data2)) '.']);
    case 'median',
         disp(' ');         disp(' ');
         disp(['   Drug group median: ' num2str(median(sort(data1))',2) ', N=' int2str(numel(data2)) '.']);
         disp(['Placebo group median: ' num2str(median(sort(data2))',2) ', N=' int2str(numel(data2)) '.']);
    case 'percentilerange',
         disp(' ');         disp(' ');
         disp(['   Drug group: 20%-tile is ' num2str(prctile(data1,20),2) ', 80%-tile is ' num2str(prctile(data1,80),2) ', N=' int2str(numel(data1)) '.']);
         disp(['Placebo group: 20%-tile is ' num2str(prctile(data2,20),2) ', 80%-tile is ' num2str(prctile(data2,80),2) ', N=' int2str(numel(data2)) '.']);
    case 'bargraphrange',
        f=figure;
        h=bar(1,mean(data1),'w');
        set(h,'barwidth',0.5);
        hold on;
        h=bar(2,mean(data2),'w');
        set(h,'barwidth',0.5);
        plot(1,data1,'bo');
        plot(2,data2,'gx');
        set(gca,'xtick',[1 2]);
        set(gca,'xticklabel',{ ['Drug N=' int2str(numel(data1))], ['Placebo N=' int2str(numel(data2))] });
        ylabel('Years of life');
		box off;
		A = axis;
		A(3) = min(A(3),min(min(data1),min(data2)));
		A(4) = max(A(4),max(max(data1),max(data2)));
		axis(A);
    case 'histogram',
        f=figure;
        bin_min = min(min(data1),min(data2));
        bin_max = max(max(data1),max(data2));
        bin_width = 2*iqr([data1(:);data2(:)])/power(numel(data1)/2+numel(data2)/2,1/3);
        bin_edges = (bin_min-bin_width):bin_width:(bin_max+bin_width);
        bin_centers = bin_edges(1:end-1) + bin_width/2;
        N1 = histcounts(data1,bin_edges);
        N2 = histcounts(data2,bin_edges);
        subplot(2,1,1);
        bar(bin_centers,N1,'b');
        ylabel({'Drug group: # of observations' ['N=' int2str(numel(data1))]} );
        box off;
        subplot(2,1,2);
        bar(bin_centers,N2,'g');
        ylabel({'Placebo group: # of observations' ['N='  int2str(numel(data2))]} );
        xlabel('Years of life');
        box off;
    case 'cumulativehistogram',
        f=figure;
        bin_min = min(min(data1),min(data2));
        bin_max = max(max(data1),max(data2));
        bin_width = 2*iqr([data1(:);data2(:)])/power(numel(data1)/2+numel(data2)/2,1/3);
        Y1 = [0 0:1:100 100];
        Y2 = Y1;
        X1 = [ bin_min-bin_width prctile(data1, 0:1:100) bin_max+bin_width];
        X2 = [ bin_min-bin_width prctile(data2, 0:1:100) bin_max+bin_width];
        plot(X1,Y1,'b-');
        hold on;
        plot(X2,Y2,'g-');
        xlabel('Years of life');
        ylabel('Fraction of observations');
        box off;
        legend(['Drug group, N=' int2str(numel(data1))],['Placebo group, N=' int2str(numel(data2))],'Location','SouthEast');
end;

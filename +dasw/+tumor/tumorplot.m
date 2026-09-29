function tumorplot(data, a, b, c, d)
% TUMORPLOT - Plot tumor size data and fit
%
%  TUMORPLOT(DATA, A, B, C, D)
%
% Plot tumor data and fit.  The fit is the equation
%
%  X = data(1,:)
%  Y = A+B*exp(C*X.^D)


plot(data(1,:),data(2,:),'b-');
hold on;
plot(data(1,:),a+b*exp(c*data(1,:).^d),'b--');
ylabel('Tumor size');
xlabel('Day');
box off;
% set x axis manually, y axis using whatever it chose
a = axis;
axis([data(1,1) data(1,end) a(3) a(4)]);
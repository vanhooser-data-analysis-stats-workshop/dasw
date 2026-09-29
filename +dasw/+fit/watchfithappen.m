function [finalfit, finalfitgof, errorovertime] = ...
   watchfithappen(x, y, fitt, N)
% WATCHFITHAPPEN - Watch a fit proceed
%  [FINALFIT, FINALFITGOF] = dasw.fit.watchfithappen(X, Y, FITTYPEOBJ)
%  WATCHFITHAPPEN will display the progress of a fit as it
%  makes better and better guesses as to the fit parameters.
%    Inputs:
%       X, a column of X data
%       Y, the values of Y that were measured at those X values
%       FIT, a FITTYPEOBJ describing the fit to be used
%       N the number of iterations to watch
%    Outputs:
%       FINALFIT - A fit object with the best fit parameters
%       FINALFITGOF - The final goodness-of-fit parameters
%       ERROROVERTIME - The sum of squared errors over time
i = 1;
figure;
plot(x,y,'k');
hold on;
h=plot(x,y,'k'); % plot a second plot to erase
xlabel('X');
ylabel('Y');
errorovertime = [];
while i<=N,
    fo = fitoptions(fitt);
    fo.MaxIter = i; % only let it run i iterations
    fitt = setoptions(fitt,fo); % set those options
    [finalfit,finalfitgof] = fit(x,y,fitt);
    errorovertime(i) = finalfitgof.sse;
    delete(h);
    h=plot(x,finalfit(x),'b--');
    pause(0.1);
    i = i + 1;
end;

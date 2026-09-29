function fn = display_fourier_frequencies( t )
%DISPLAY_FOURIER_FREQUENCIES Show fourier frequencies in figure
%   FN = dasw.signal.display_fourier_frequencies(T)
%
% Displays the discrete Fourier frequencies Fn using Sin
%
%  The signal is assumed to be sampled at times T with
%  a constant time interval between samples.
N = numel(t);
sample_interval = t(2)-t(1); % assuming this is constant over sample
sample_rate = 1/sample_interval;
fn = sample_rate * [0:N-1]/N;
figure;
for i=1:numel(fn),
    plot(t,sin(2*pi*t*fn(i)));
    title(['Frequency fn, n=' int2str(i) '.']);
    ylabel('Signal');
    xlabel('Time(s)');
    mn = min(i,numel(fn)-i);
    if mn<10,
        pause(1);
    elseif mn<20,
        pause(0.5);
    elseif mn<100,
        pause(0.1),
    else,
        pause(0.001);
    end;
end;

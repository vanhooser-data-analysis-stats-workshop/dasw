function [freqs,output, phaseshift] = filtertransfer(b,a,sr,N, filtfunc)
% FILTERTRANSFER - calculate transfer vs. frequency for filters
%
%  [FREQS,OUTPUT,PHASESHIFT] = dasw.signal.filtertransfer(B,A,SR,N,FILTFUNC)
%
%  Inputs:
%  B and A are the coefficients for filter
%  SR is the samplig rate
%  N is the number of points to sample
%  FILTFUNC should be a filter function such as 'filter' or 'filtfilt'
%
%  Outputs:  FREQS a list of 200 frequencies that will be examined
%            OUTPUT the fraction of signal at that frequency that is passed
%            PHASESHIFT the phase shift (if any) of the filter
t = 0:1/sr:(N-1)*1/sr;
  % create 200 equally spaced samples in log space
freqs = logspace(log10(sr*1/N),log10(0.5*sr*(N-1)/N),200); 
output = [];
phaseshift = [];
for i=1:numel(freqs),
    y = cos(2*pi*freqs(i)*t);
    eval(['y2 = ' filtfunc '(b,a,y);']);
    amp_cosine = 2*mean(y.*y2); % an fourier coefficient
    amp_sine = 2*mean(sin(2*pi*freqs(i)*t).*y2); % bn fourier coefficient
    output(i) = sqrt(amp_cosine.^2+amp_sine.^2); % total amplitude
    phaseshift(i) = atan2(amp_sine,amp_cosine); % phase
end;

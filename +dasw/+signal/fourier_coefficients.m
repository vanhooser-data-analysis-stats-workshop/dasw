function [ an, bn, fn ] = fourier_coefficients( t, signal )
%FOURIER_COEFFICIENTS Fourier coefficients of a signal
%   [AN,BN,FN] = dasw.signal.fourier_coefficients(T, SIGNAL)
%
% Returns the discrete Fourier cofficients An and Bn
% with frequencies Fn such that
%
%  SIGNAL(T) = AN*COS(2*PI*FN*T)+BN*SIN(2*PI*FN*T)
%
%  The SIGNAL is assumed to be sampled at times T with
%  a constant time interval between samples.

N = numel(t);
t = t(:); % make sure we are in a column
signal = signal(:); % make sure we are in a column
sample_interval = t(2)-t(1); % assuming this is constant over sample
sample_rate = 1/sample_interval;
fn = sample_rate * [0:N-1]/N;
an = [];
bn = [];
for i=1:numel(fn),
    an(i) = mean(signal.*cos(2*pi*fn(i)*t));
    bn(i) = mean(signal.*sin(2*pi*fn(i)*t));
end;

% Sine BP Test

% Zero Mean Noise
A = 10;                             % signal amplitude
snr = 100;                          % signal to noise ratio
n = (A/snr)*(rand(1,10000)-0.5);     % noise vector
x = 2*pi*rand(1,10000);              % input
b = A*(sin(x)+n)';                  % output
w = cell(2,1);
w{1} = rand(2,2);
w{2} = rand(3,1);

w = back_propagation(x, b, w);
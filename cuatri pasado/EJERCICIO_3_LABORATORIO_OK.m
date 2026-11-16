clear;
clc;
close all;

% Parámetros

Nx = 401;
dt = 0.0001;
t = 0:dt:(Nx-1)*dt;

Fc = 1000;
Nh = 201;


% Señal de entrada x[n]

x = 10*cos(2*pi*150*t) + 5*sin(2*pi*1000*t);


% Respuesta al impulso h[n]

n_h = -(Nh-1)/2 : (Nh-1)/2;
h = 2*Fc*dt * sinc(2*Fc*dt*n_h);


% Convolución vía FFT

% Longitud N suficiente para la convolución
N = 2^nextpow2(Nx + Nh - 1);

% Extender con ceros
x_pad = [x, zeros(1, N - Nx)];
h_pad = [h, zeros(1, N - Nh)];

% FFT
X = fft(x_pad);
H = fft(h_pad);

% Multiplicación en frecuencia
Y = X .* H;

% IFFT para volver al tiempo
y_fft = ifft(Y);

% Vector de frecuencia
f = (0:N-1)*(1/(N*dt));


% Gráficos

figure('Name', 'Ejercicio 3', 'NumberTitle', 'off')

% x[n] en tiempo
subplot(3,2,1);
plot(0:N-1, x_pad);
title('x[n] en tiempo');
xlabel('n'); ylabel('x[n]');

% x[n] en frecuencia
subplot(3,2,2);
plot(f, abs(X));
title('X[k] módulo FFT');
xlabel('f (Hz)'); ylabel('|X[k]|');

% h[n] en tiempo
subplot(3,2,3);
plot(0:N-1, h_pad);
title('h[n] en tiempo');
xlabel('n'); ylabel('h[n]');

% h[n] en frecuencia
subplot(3,2,4);
plot(f, abs(H));
title('H[k] módulo FFT');
xlabel('f (Hz)'); ylabel('|H[k]|');

% y[n] en tiempo
subplot(3,2,5);
plot(0:N-1, y_fft);
title('y[n] = x[n]*h[n] por FFT');
xlabel('n'); ylabel('y[n]');

% y[n] en frecuencia
subplot(3,2,6);
plot(f, abs(Y));
title('Y[k] módulo FFT');
xlabel('f (Hz)'); ylabel('|Y[k]|');

% El recorte brusco de la señal (ventana rectangular) introduce
% discontinuidades en los bordes del intervalo temporal.
% Esas discontinuidades generan oscilaciones en frecuencia,
% que son justamente el fenómeno de Gibbs

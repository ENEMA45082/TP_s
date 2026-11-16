% EJERCICIO 4 - Filtro paso bajo con ventana Hamming
clear; clc; close all;

% Parámetros
Fs = 10000;          % Frecuencia de muestreo (Hz)
dt = 1/Fs;           % Periodo de muestreo
Nx = 401;            % Muestras de la señal
t = (0:Nx-1)/Fs;     % Vector de tiempo
Fc = 1000;           % Frecuencia de corte (Hz)
Nh = 51;            % Longitud del filtro

% Señal de entrada
x = 10*cos(2*pi*150*t) + 5*sin(2*pi*1000*t);

% Filtro ideal (respuesta sinc)
n_h = -(Nh-1)/2 : (Nh-1)/2;
h_ideal = 2*(Fc/Fs) * sinc(2*(Fc/Fs) * n_h);

% Aplicar ventana de Hamming
w = hamming(Nh)';
h_win = h_ideal .* w;

% Normalizar para que la ganancia DC sea 1
h = h_win / sum(h_win);

% Convolución directa en tiempo
y_conv = conv(x, h);
t_y = (0:length(y_conv)-1)/Fs;

% Convolución por FFT
Nfft = 2^nextpow2(length(x) + length(h) - 1);
x_pad = [x, zeros(1, Nfft - length(x))];
h_pad = [h, zeros(1, Nfft - length(h))];
X = fft(x_pad, Nfft);
H = fft(h_pad, Nfft);
Y = X .* H;
y_ifft_full = real(ifft(Y));             % volver al tiempo
y_ifft = y_ifft_full(1:length(y_conv));  % misma longitud que conv

% Calcular espectros sin centrar (picos en los extremos)
f = (0:Nfft-1) * (Fs/Nfft);
X_mag = abs(X)/Nfft;
H_mag = abs(H)/Nfft;
Y_conv_mag = abs(fft(y_conv, Nfft))/Nfft;
Y_fft_mag  = abs(fft(y_ifft, Nfft))/Nfft;

% GRAFICOS
figure('Name', 'Ejercicio 4', 'NumberTitle', 'off')

% ==================== COLUMNA 1 ====================

subplot(4,2,1);
stem(t, x, '.');
xlabel('Tiempo (s)'); ylabel('x(t)');
title('x(t) en tiempo');
grid on;

subplot(4,2,3);
t_h_seconds = n_h / Fs;
stem(t_h_seconds, h, '.');
xlabel('Tiempo (s)'); ylabel('h[n]');
title('h[n] con ventana Hamming');
grid on;

subplot(4,2,5);
stem(t_y, y_conv, '.');
xlabel('Tiempo (s)'); ylabel('y(t)');
title('Convolución en tiempo (función conv)');
grid on;

subplot(4,2,7);
stem(t_y, y_ifft, '.');
xlabel('Tiempo (s)'); ylabel('y(t)');
title('Convolución por FFT');
grid on;

% ==================== COLUMNA 2 ====================

subplot(4,2,2);
stem(f, X_mag, '.');
xlabel('Frecuencia (Hz)'); ylabel('|X(f)|');
title('Espectro de x(t)');
grid on;

subplot(4,2,4);
stem(f, H_mag, '.');
xlabel('Frecuencia (Hz)'); ylabel('|H(f)|');
title('Espectro del filtro H(f)');
grid on;

subplot(4,2,6);
stem(f, Y_conv_mag, '.');
xlabel('Frecuencia (Hz)'); ylabel('|Y(f)|');
title('Espectro de y(t) conv');
grid on;

subplot(4,2,8);
stem(f, Y_fft_mag, '.');
xlabel('Frecuencia (Hz)'); ylabel('|Y(f)|');
title('Espectro de y(t) FFT');
grid on;


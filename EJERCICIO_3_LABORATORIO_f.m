% EJERCICIO 3 - Análisis Numérico (Convolución mediante FFT)
clc; clear; close all;

% ---------- Datos (mismos que el Ejercicio 2) ----------
Nx = 401;        % muestras de x[n]
Dt = 0.0001;     % paso de muestreo [s]
Fc = 500;        % frecuencia de corte [Hz]: entre 150 Hz y 1000 Hz
Nh = 101;        % muestras de h[n], IMPAR
N  = 1024;       % largo de la FFT, N = 2^r

% La convolución lineal tiene Nx + Nh - 1 muestras: N tiene que alcanzar
if N < Nx + Nh - 1
  error('N = %d es chico: hace falta N >= Nx + Nh - 1 = %d', N, Nx + Nh - 1);
end

% ---------- Señal de entrada x[n] ----------
n_x = 0:(Nx-1);
t   = n_x * Dt;
x   = 10*cos(2*pi*150*t) + 5*sin(2*pi*1000*t);

% ---------- Respuesta al impulso h[n]: sinc centrada ----------
n_h = -(Nh-1)/2 : (Nh-1)/2;
h   = 2*Fc*Dt * sinc(2*Fc*Dt*n_h);

% ---------- Mismo largo N: se agrega la zona nula ----------
xN = [x, zeros(1, N - Nx)];
hN = [h, zeros(1, N - Nh)];

% ---------- Convolución por FFT ----------
X = fft(xN);
H = fft(hN);
Y = X .* H;                % convolución en tiempo = producto en frecuencia
y = real(ifft(Y));         % la parte imaginaria es solo ruido numérico (~1e-15)

% ---------- Ejes ----------
% x[n] arranca en n = 0. h[n] e y[n] arrancan en n = n_h(1) = -(Nh-1)/2,
% igual que en el Ejercicio 2 (por eso h centrada queda guardada desde su primer valor no nulo).
n_xN = 0:(N-1);
n_hN = n_h(1) + (0:(N-1));
n_y  = n_h(1) + (0:(N-1));
k    = 0:(N-1);
lim_n = [n_h(1), n_h(1) + Nx + Nh - 2];   % elementos no nulos de y[n], igual que en el Ej. 2
lim_k = [0 N-1];

% ---------- Comparación con el Ejercicio 2 (conv en el tiempo) ----------
y_conv = conv(x, h);
err = max(abs(y(1:Nx+Nh-1) - y_conv));
printf('N = %d | Nx + Nh - 1 = %d | error máx |y_FFT - y_conv| = %.2e\n', N, Nx+Nh-1, err);

% Picos del espectro: k = f * N * Dt
k150  = round(150  * N * Dt) + 1;     % +1 porque los índices de Octave arrancan en 1
k1000 = round(1000 * N * Dt) + 1;
printf('|X| en 150 Hz = %.1f | |Y| en 150 Hz = %.1f | cociente = %.3f\n', abs(X(k150)),  abs(Y(k150)),  abs(Y(k150))/abs(X(k150)));
printf('|X| en 1000 Hz = %.1f | |Y| en 1000 Hz = %.1f | cociente = %.3f\n', abs(X(k1000)), abs(Y(k1000)), abs(Y(k1000))/abs(X(k1000)));

% ---------- Gráficos: 3 filas x 2 columnas ----------
c_x = [0.85 0.25 0.20];   % rojo ladrillo
c_h = [0.20 0.45 0.75];   % azul medio
c_y = [0.15 0.60 0.40];   % verde oscuro

figure('Name', 'Ejercicio 3', 'NumberTitle', 'off', ...
       'Color', 'white', 'Position', [100 60 1000 680]);

% --- Columna 1: tiempo discreto [n] ---
subplot(3,2,1);
stem(n_xN, xN, 'filled', 'LineWidth', 0.8, 'Color', c_x, 'MarkerSize', 2, ...
     'MarkerFaceColor', c_x, 'MarkerEdgeColor', c_x);
title('x[n]  (con ceros hasta N)', 'FontWeight', 'bold', 'Color', c_x);
xlabel('n'); ylabel('Amplitud'); xlim(lim_n); grid on; set(gca, 'Box', 'off');

subplot(3,2,3);
stem(n_hN, hN, 'filled', 'LineWidth', 0.8, 'Color', c_h, 'MarkerSize', 2, ...
     'MarkerFaceColor', c_h, 'MarkerEdgeColor', c_h);
title('h[n]  (con ceros hasta N)', 'FontWeight', 'bold', 'Color', c_h);
xlabel('n'); ylabel('Amplitud'); xlim(lim_n); grid on; set(gca, 'Box', 'off');

subplot(3,2,5);
stem(n_y, y, 'filled', 'LineWidth', 0.8, 'Color', c_y, 'MarkerSize', 2, ...
     'MarkerFaceColor', c_y, 'MarkerEdgeColor', c_y);
title('y[n] por FFT', 'FontWeight', 'bold', 'Color', c_y);
xlabel('n'); ylabel('Amplitud'); xlim(lim_n); grid on; set(gca, 'Box', 'off');

% --- Columna 2: frecuencias discretas [k], módulos ---
subplot(3,2,2);
plot(k, abs(X), 'Color', c_x, 'LineWidth', 1.2);
title('|X[k]|', 'FontWeight', 'bold', 'Color', c_x);
xlabel('k'); ylabel('Módulo'); xlim(lim_k); grid on; set(gca, 'Box', 'off');

subplot(3,2,4);
plot(k, abs(H), 'Color', c_h, 'LineWidth', 1.2);
title('|H[k]|', 'FontWeight', 'bold', 'Color', c_h);
xlabel('k'); ylabel('Módulo'); xlim(lim_k); grid on; set(gca, 'Box', 'off');

subplot(3,2,6);
plot(k, abs(Y), 'Color', c_y, 'LineWidth', 1.2);
title('|Y[k]| = |X[k]|·|H[k]|', 'FontWeight', 'bold', 'Color', c_y);
xlabel('k'); ylabel('Módulo'); xlim(lim_k); grid on; set(gca, 'Box', 'off');

titulo = sprintf('Ejercicio 3 - Convolución por FFT | N = %d, Dt = %g s, Fc = %g Hz, Nh = %d', N, Dt, Fc, Nh);
if exist('sgtitle')
  sgtitle(titulo, 'FontWeight', 'bold');
else
  set(gcf, 'Name', titulo);
end

% ================== CONCLUSIONES ==================
% 1) Comparación con el Ej. 2: la y[n] por FFT coincide con la de conv (error ~1e-13),
%    siempre que N >= Nx + Nh - 1. Si N fuera menor, la convolución se vuelve circular
%    y los extremos de y[n] se montan sobre el principio (aliasing temporal).
% 2) Los picos de X[k] están en k = f*N*Dt: 150 Hz -> k ~ 15 y 1000 Hz -> k ~ 102.
%    El espectro es simétrico: k y N-k son la misma frecuencia (la segunda mitad es la
%    frecuencia negativa). Solo la primera mitad (k < N/2) es información independiente.
% 3) Gibbs: al recortar x[n] a 401 muestras (ventana rectangular) cada pico se ensancha
%    y aparecen lóbulos laterales (fuga espectral) alrededor de 150 y 1000 Hz.
%    En |H[k]| el rizado en la banda de paso y en la de rechazo es Gibbs: h[n] es una
%    sinc truncada a Nh muestras, o sea un filtro ideal multiplicado por una ventana
%    rectangular.
% 4) Entrada vs. salida: |X| tiene dos picos (150 y 1000 Hz); en |Y| queda el de 150 Hz
%    (cociente ~1) y el de 1000 Hz casi desaparece (cociente ~0.014), porque
%    |Y[k]| = |X[k]|·|H[k]| y |H| cae en la banda de rechazo.
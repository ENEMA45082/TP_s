% EJERCICIO 4 - Filtro pasa bajo con ventana de Hamming
clc; clear; close all;

% ---------- Datos (cambiar acá para las otras corridas) ----------
Fm = 10000;      % frecuencia de muestreo [Hz]   (Dt = 1/Fm)
Fc = 500;        % frecuencia de corte [Hz]: entre 150 Hz y 1000 Hz
Nx = 401;        % muestras de x[n]
Nh = 101;        % muestras de h[n], IMPAR
N  = max(1024, 2^nextpow2(Nx + Nh - 1));   % largo de la FFT (potencia de 2, alcanza para toda y[n])

% ---------- Señal de entrada x[n] ----------
n_x = 0:(Nx-1);
t_x = n_x / Fm;                          % tiempos continuos [s]
x   = 10*cos(2*pi*150*t_x) + 5*sin(2*pi*1000*t_x);

% ---------- Respuesta al impulso: sinc ideal * ventana de Hamming ----------
n_h     = -(Nh-1)/2 : (Nh-1)/2;
t_h     = n_h / Fm;
h_ideal = 2*(Fc/Fm) * sinc(2*(Fc/Fm)*n_h);   % = 2*Fc*Dt*sinc(2*Fc*Dt*n)
w       = hamming(Nh)';                        % ventana de Hamming
h_w     = h_ideal .* w;
h       = h_w / sum(h_w);                      % normalizado: ganancia en continua = 1

% ---------- Convolución en el tiempo ----------
y_conv = conv(x, h);
n_y    = n_h(1) + (0:(length(y_conv)-1));      % y[n] arranca en n = -(Nh-1)/2
t_y    = n_y / Fm;

% ---------- Convolución por FFT ----------
xN = [x, zeros(1, N - Nx)];
hN = [h, zeros(1, N - Nh)];
X  = fft(xN);
H  = fft(hN);
Y  = X .* H;
y_fft = real(ifft(Y));
y_fft = y_fft(1:length(y_conv));               % mismas muestras que conv

% ---------- Eje de frecuencias analógicas [Hz] ----------
f = (0:N-1) * (Fm/N);

% ---------- Comparación y métricas por consola ----------
printf('Fm = %g Hz | Fc = %g Hz | Nx = %d | Nh = %d | N = %d\n', Fm, Fc, Nx, Nh, N);
printf('Error máx |y_fft - y_conv| = %.2e\n', max(abs(y_fft - y_conv)));

% Métricas de H(f) con alta resolución, Hamming vs ventana rectangular
Nm  = 16384;  fm = (0:Nm/2) * (Fm/Nm);
h_r = h_ideal / sum(h_ideal);                  % misma h pero con ventana rectangular
Hm_h = abs(fft(h,   Nm)); Hm_h = Hm_h(1:Nm/2+1);
Hm_r = abs(fft(h_r, Nm)); Hm_r = Hm_r(1:Nm/2+1);
metricas = @(Hm) deal( ...
  max(abs(Hm(fm <= Fc/2) - 1)), ...                              % rizado en banda de paso (f <= Fc/2)
  max(Hm(fm >= 2*Fc)), ...                                        % máx en banda de rechazo (f >= 2Fc)
  fm(find(Hm < 0.1, 1)) - fm(find(Hm < 0.9, 1)));                 % ancho de transición 0.9 -> 0.1
[rz_h, rc_h, tr_h] = metricas(Hm_h);
[rz_r, rc_r, tr_r] = metricas(Hm_r);
printf('                     rizado banda paso | máx banda rechazo | transición 0.9->0.1\n');
printf('  Rectangular:           %6.3f        |      %6.4f       |   %6.0f Hz\n', rz_r, rc_r, tr_r);
printf('  Hamming:               %6.3f        |      %6.4f       |   %6.0f Hz\n', rz_h, rc_h, tr_h);

% ---------- Gráficos: 4 filas x 2 columnas ----------
c_x = [0.85 0.25 0.20];   % rojo ladrillo
c_h = [0.20 0.45 0.75];   % azul medio
c_y = [0.15 0.60 0.40];   % verde oscuro
c_z = [0.55 0.30 0.70];   % violeta (salida por FFT)
lim_t = [t_y(1), t_y(end)];
lim_f = [0, Fm/2];        % la mitad de arriba es el espejo (frecuencias negativas)

figure('Name', 'Ejercicio 4', 'NumberTitle', 'off', ...
       'Color', 'white', 'Position', [80 40 1050 760]);

% --- Columna 1: señales en el tiempo [s] ---
subplot(4,2,1);
stem(t_x, x, 'filled', 'LineWidth', 0.8, 'Color', c_x, 'MarkerSize', 2, ...
     'MarkerFaceColor', c_x, 'MarkerEdgeColor', c_x);
title('x(t)  -  señal de entrada', 'FontWeight', 'bold', 'Color', c_x);
xlabel('Tiempo (s)'); ylabel('Amplitud'); xlim(lim_t); grid on; set(gca, 'Box', 'off');

subplot(4,2,3);
stem(t_h, h, 'filled', 'LineWidth', 0.8, 'Color', c_h, 'MarkerSize', 2, ...
     'MarkerFaceColor', c_h, 'MarkerEdgeColor', c_h);
title('h[n]  -  sinc con ventana de Hamming (normalizada)', 'FontWeight', 'bold', 'Color', c_h);
xlabel('Tiempo (s)'); ylabel('Amplitud'); xlim(lim_t); grid on; set(gca, 'Box', 'off');

subplot(4,2,5);
stem(t_y, y_conv, 'filled', 'LineWidth', 0.8, 'Color', c_y, 'MarkerSize', 2, ...
     'MarkerFaceColor', c_y, 'MarkerEdgeColor', c_y);
title('y(t)  -  convolución en el tiempo (conv)', 'FontWeight', 'bold', 'Color', c_y);
xlabel('Tiempo (s)'); ylabel('Amplitud'); xlim(lim_t); grid on; set(gca, 'Box', 'off');

subplot(4,2,7);
stem(t_y, y_fft, 'filled', 'LineWidth', 0.8, 'Color', c_z, 'MarkerSize', 2, ...
     'MarkerFaceColor', c_z, 'MarkerEdgeColor', c_z);
title('y(t)  -  convolución por FFT', 'FontWeight', 'bold', 'Color', c_z);
xlabel('Tiempo (s)'); ylabel('Amplitud'); xlim(lim_t); grid on; set(gca, 'Box', 'off');

% --- Columna 2: módulos de los espectros en frecuencia analógica [Hz] ---
subplot(4,2,2);
plot(f, abs(X), 'Color', c_x, 'LineWidth', 1.2);
title('|X(f)|', 'FontWeight', 'bold', 'Color', c_x);
xlabel('Frecuencia (Hz)'); ylabel('Módulo'); xlim(lim_f); grid on; set(gca, 'Box', 'off');

subplot(4,2,4);
plot(f, abs(H), 'Color', c_h, 'LineWidth', 1.2);
title('|H(f)|  -  con ventana de Hamming', 'FontWeight', 'bold', 'Color', c_h);
xlabel('Frecuencia (Hz)'); ylabel('Módulo'); xlim(lim_f); grid on; set(gca, 'Box', 'off');

% Las dos salidas se representan con el espectro del proceso FFT: Y = X.*H
subplot(4,2,6);
plot(f, abs(Y), 'Color', c_y, 'LineWidth', 1.2);
title('|Y(f)|  -  de la salida por conv (espectro del proceso FFT)', 'FontWeight', 'bold', 'Color', c_y);
xlabel('Frecuencia (Hz)'); ylabel('Módulo'); xlim(lim_f); grid on; set(gca, 'Box', 'off');

subplot(4,2,8);
plot(f, abs(Y), 'Color', c_z, 'LineWidth', 1.2);
title('|Y(f)|  -  de la salida por FFT', 'FontWeight', 'bold', 'Color', c_z);
xlabel('Frecuencia (Hz)'); ylabel('Módulo'); xlim(lim_f); grid on; set(gca, 'Box', 'off');

titulo = sprintf('Ejercicio 4 - Pasa bajo con Hamming | Fm = %g Hz, Fc = %g Hz, Nx = %d, Nh = %d', Fm, Fc, Nx, Nh);
if exist('sgtitle')
  sgtitle(titulo, 'FontWeight', 'bold');
else
  set(gcf, 'Name', titulo);
end

% ---------- Figura extra: mejora de H(f) al usar Hamming (Gibbs) ----------
figure('Name', 'Ejercicio 4 - H(f): rectangular vs Hamming', 'NumberTitle', 'off', ...
       'Color', 'white', 'Position', [140 100 900 420]);
subplot(1,2,1);
plot(fm, Hm_r, 'Color', [0.6 0.6 0.6], 'LineWidth', 1.4); hold on;
plot(fm, Hm_h, 'Color', c_h, 'LineWidth', 1.6);
legend('Rectangular', 'Hamming', 'Location', 'northeast');
title('|H(f)|  lineal', 'FontWeight', 'bold'); xlabel('Frecuencia (Hz)'); ylabel('Módulo');
xlim(lim_f); grid on;
subplot(1,2,2);
plot(fm, 20*log10(Hm_r + 1e-12), 'Color', [0.6 0.6 0.6], 'LineWidth', 1.4); hold on;
plot(fm, 20*log10(Hm_h + 1e-12), 'Color', c_h, 'LineWidth', 1.6);
legend('Rectangular', 'Hamming', 'Location', 'northeast');
title('|H(f)|  en dB', 'FontWeight', 'bold'); xlabel('Frecuencia (Hz)'); ylabel('dB');
xlim(lim_f); ylim([-100 5]); grid on;

% ================== CONCLUSIONES (valores medidos con Fc = 500 Hz) ==================
% 1) Conv vs FFT: las dos salidas coinciden (error ~1e-14) mientras N >= Nx + Nh - 1.
%    Por eso los dos espectros de salida se dibujan con el mismo Y = X.*H.
%
% 2) Gibbs en H(f) (figura 2, Nh = 101): con ventana rectangular el rizado en la banda
%    de paso llega a 0.078 y el nivel en rechazo a 0.013; con Hamming baja a 0.005 y
%    0.0007 (de -37 dB a -63 dB aprox.). Costo: la banda de transición se ensancha
%    (de 93 Hz a 182 Hz entre |H| = 0.9 y 0.1).
%
% 3) Nh y banda de transición (Hamming): 21 -> 760 Hz | 51 -> 366 Hz | 101 -> 182 Hz |
%    301 -> 60 Hz. El ancho es ~ 1.8*Fm/Nh: al aumentar Nh el filtro se acerca al ideal
%    (corte más abrupto), a costa de más cálculo y transitorios más largos en los bordes.
%    Con Nh = 21 la transición es tan ancha que a 1000 Hz el filtro todavía no llegó a
%    la banda de rechazo: |H| = 0.09 (la rectangular tiene 0.05), es decir, Hamming
%    solo gana si Nh es suficientemente grande.
%
% 4) Nx y espectro de entrada (Fm = 10 kHz): el ancho (-3 dB) de cada pico de |X(f)| es
%    ~ 1/T con T = Nx/Fm: 98 Hz (Nx = 101) | 29 Hz (401) | 7 Hz (2001) | 2 Hz (8001).
%    El recorte rectangular de la señal ensancha las deltas ideales y genera lóbulos
%    laterales (fuga espectral). Con Nx -> infinito quedarían dos deltas en 150 y 1000 Hz
%    (la altura del pico crece ~ A*Nx/2: 39131 para Nx = 8001 con A = 10).
%    Resolución de la FFT: Fm/N = 9.8 Hz, por eso el pico sale en 146 Hz y no en 150 Hz.
%
% 5) Fm: con Fm = 5000 y 2500 Hz la señal se ve igual y el pico de 1000 Hz sigue en su
%    lugar (el filtro lo elimina). Con Fm = 2000 Hz (1000 Hz = Nyquist) y 1000 Hz
%    el seno muestreado da 0 y la componente desaparece de x[n]. Con Fm = 1800 Hz
%    aparece aliasing: la componente de 1000 Hz se ve en |1800 - 1000| = 800 Hz; el filtro
%    la elimina igual, pero ya no se puede distinguir de una señal real de 800 Hz.
%    Fm grande: más muestras por ciclo y mejor representación en tiempo; Fm chico:
%    menos definición y riesgo de aliasing (Fm debe superar 2*1000 Hz).
%    Además, con Nh fijo, Fm chico hace la transición más angosta en Hz (~ Fm/Nh).
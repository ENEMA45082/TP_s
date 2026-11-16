% EJERCICIO 2 - Análisis Numérico (Convolución Discreta con filtro)
clc; clear; clear all;

% Datos proporcionados
Nx = 401;
Dt = 0.0001;
Fc = 1000;
Nh = 101;

% Vectores de tiempo e índice
t   = 0 : Dt : (Nx-1)*Dt;
n   = 0:(Nx-1);

% Señal de entrada x[n]
x = 10*cos(2*pi*150*t) + 5*sin(2*pi*1000*t);

% Filtro h[n]
n_h = -(Nh-1)/2 : (Nh-1)/2;
h   = 2*Fc*Dt .* sinc(2*Fc*Dt*n_h);

% Convolución
y   = conv(x, h);
n_y = (n(1) + n_h(1)) : (n(end) + n_h(end));

% ── Paleta ────────────────────────────────────────────────────────────────
c_x = [0.85 0.25 0.20];
c_h = [0.20 0.45 0.75];
c_y = [0.15 0.60 0.40];

figure('Name', 'Ejercicio 2', 'NumberTitle', 'off', ...
       'Color', 'white', 'Position', [120 80 780 620]);

% Señal x[n]
subplot(3,1,1);
stem(t, x, 'filled', 'LineWidth', 1.2, 'Color', c_x, ...
     'MarkerSize', 3, 'MarkerFaceColor', c_x, 'MarkerEdgeColor', c_x);
yline(0, 'Color', [0.7 0.7 0.7], 'LineWidth', 0.8);
title('x[n]  —  10cos(2π·150·t) + 5sen(2π·1000·t)', ...
      'FontSize', 11, 'FontWeight', 'bold', 'Color', c_x);
xlabel('Tiempo (s)', 'FontSize', 10);
ylabel('Amplitud',   'FontSize', 10);
xlim([0 max(t)]); ylim([-15 15]);
set(gca, 'Box', 'off', 'GridAlpha', 0.35, 'FontSize', 9);
grid on;

% Filtro h[n]
subplot(3,1,2);
stem(n_h*Dt, h, 'filled', 'LineWidth', 1.2, 'Color', c_h, ...
     'MarkerSize', 4, 'MarkerFaceColor', c_h, 'MarkerEdgeColor', c_h);
yline(0, 'Color', [0.7 0.7 0.7], 'LineWidth', 0.8);
title('h[n]  —  2Fc·Δt·sinc(2Fc·Δt·n)', ...
      'FontSize', 11, 'FontWeight', 'bold', 'Color', c_h);
xlabel('Tiempo (s)', 'FontSize', 10);
ylabel('Amplitud',   'FontSize', 10);
xlim([min(n_h*Dt) max(n_h*Dt)]);
set(gca, 'Box', 'off', 'GridAlpha', 0.35, 'FontSize', 9);
grid on;

% Salida y[n]
subplot(3,1,3);
stem(n_y*Dt, y, 'filled', 'LineWidth', 1.2, 'Color', c_y, ...
     'MarkerSize', 3, 'MarkerFaceColor', c_y, 'MarkerEdgeColor', c_y);
yline(0, 'Color', [0.7 0.7 0.7], 'LineWidth', 0.8);
title('y[n]  =  x[n] \ast h[n]', ...
      'FontSize', 11, 'FontWeight', 'bold', 'Color', c_y);
xlabel('Tiempo (s)', 'FontSize', 10);
ylabel('Amplitud',   'FontSize', 10);
xlim([min(n_y*Dt) max(n_y*Dt)]); ylim([-15 15]);
set(gca, 'Box', 'off', 'GridAlpha', 0.35, 'FontSize', 9);
grid on;

sgtitle(sprintf('Ejercicio 2  ·  Filtro Pasa Bajo  |  Δt = %.4f s,  Nh = %d', Dt, Nh), ...
        'FontSize', 13, 'FontWeight', 'bold');

% Para las otras ejecuciones del codigo con distintos valores, primero deberiamos
% cambiar los siguientes valores:
% Dt = 0.0005 ; Nh = 51 (por ejemplo); y Dt = 0.001 y Nh = 201 (por ejemplo)
% Lo que podemos darnos cuenta es que cuando Dt es mas pequeño, notamos a la
% señal mucho mas definida, por la alta frecuencia de muestreo. Por su contra parte
% cuando Dt es mas grande, sucede el aliasing.
% Con respeto a Nh, cuando es pequeño, la salida tendrá mas errores ya que el filtro
% será mas impreciso, a diferencia de cuando este es más grande.
% Los valores de Nh los elegimos nosotros.

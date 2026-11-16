% EJERCICIO 1 - Análisis Numérico (Convolución Discreta)

% Limpieza:
clc
clear
clear all

% Definición de la señal x[n]
nx = -5:5; % Valores positivos y negativos guardados en nx, va de -5 a 5
x = (nx >= -2) & (nx <= 2); % pulso rectangular unitario
% x = ones(1, length(nx))

% Definición de la señal h[n]
nh = 0:5; % Vector que va de 0 a 5
h = nh; % respuesta al impulso

% Convolución
y = conv(x, h); % Obtenemos y utilizando el comando conv
ny = (nx(1) + nh(1)) : (nx(end) + nh(end)); % Por definición de convolución

% Rango total para las gráficas
nmin = min([nx(1), nh(1), ny(1)]);
nmax = max([nx(end), nh(end), ny(end)]);

% Gráficas
c_x = [0.85 0.25 0.20];   % rojo ladrillo
c_h = [0.20 0.45 0.75];   % azul medio
c_y = [0.15 0.60 0.40];   % verde oscuro

figure('Name', 'Convolución Discreta', 'NumberTitle', 'off', ...
       'Color', 'white', 'Position', [120 80 780 620]);

% Señal x[n]
subplot(3,1,1);
stem(nx, x, 'filled', 'LineWidth', 1.6, 'Color', c_x, ...
     'MarkerSize', 6, 'MarkerFaceColor', c_x, 'MarkerEdgeColor', c_x);
yline(0, 'Color', [0.7 0.7 0.7], 'LineWidth', 0.8);
title('x[n]  —  Pulso Rectangular', 'FontSize', 11, 'FontWeight', 'bold', 'Color', c_x);
xlabel('n', 'FontSize', 10); ylabel('Amplitud', 'FontSize', 10);
xlim([min(ny)-1, max(ny)+1]); ylim([-0.3 1.7]);
set(gca, 'Box', 'off', 'GridAlpha', 0.35, 'FontSize', 9);
grid on;

% Señal h[n]
subplot(3,1,2);
stem(nh, h, 'filled', 'LineWidth', 1.6, 'Color', c_h, ...
     'MarkerSize', 6, 'MarkerFaceColor', c_h, 'MarkerEdgeColor', c_h);
yline(0, 'Color', [0.7 0.7 0.7], 'LineWidth', 0.8);
title('h[n]  —  Respuesta al Impulso (Rampa)', 'FontSize', 11, 'FontWeight', 'bold', 'Color', c_h);
xlabel('n', 'FontSize', 10); ylabel('Amplitud', 'FontSize', 10);
xlim([min(ny)-1, max(ny)+1]); ylim([-0.5 max(h)+1.5]);
set(gca, 'Box', 'off', 'GridAlpha', 0.35, 'FontSize', 9);
grid on;

% Señal y[n]
subplot(3,1,3);
stem(ny, y, 'filled', 'LineWidth', 1.6, 'Color', c_y, ...
     'MarkerSize', 6, 'MarkerFaceColor', c_y, 'MarkerEdgeColor', c_y);
yline(0, 'Color', [0.7 0.7 0.7], 'LineWidth', 0.8);
[val_max, idx_max] = max(y);
text(ny(idx_max), val_max + 1, sprintf('  %g', val_max), ...
     'FontSize', 9, 'Color', c_y, 'FontWeight', 'bold');
title('y[n]  =  x[n] \ast h[n]', 'FontSize', 11, 'FontWeight', 'bold', 'Color', c_y);
xlabel('n', 'FontSize', 10); ylabel('Amplitud', 'FontSize', 10);
xlim([min(ny)-1, max(ny)+1]); ylim([min(y)-1 max(y)+3]);
set(gca, 'Box', 'off', 'GridAlpha', 0.35, 'FontSize', 9);
grid on;

sgtitle('Ejercicio 1  ·  Convolución de Señales Discretas', ...
        'FontSize', 13, 'FontWeight', 'bold');

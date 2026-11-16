% EJERCICIO 1 - Análisis Numérico (Convolución Discreta)
clc; clear; close all;

% ---------- Señal de entrada x[n] ----------
% Pulso rectangular unitario: nx guarda el intervalo donde x es no nula
nx = -2:2;                  % incluye n negativos y positivos
x  = ones(1, length(nx));   % valor 1 en todo nx

% ---------- Respuesta al impulso h[n] ----------
nh = 0:5;                   % arranca en n = 0, todos positivos
h  = nh;                    % h[n] = n (rampa)

% ---------- Convolución ----------
y  = conv(x, h);
ny = (nx(1) + nh(1)) : (nx(end) + nh(end));   % el soporte de y arranca en nx(1)+nh(1)
% largo(y) = largo(x) + largo(h) - 1  ->  5 + 6 - 1 = 10 muestras

disp('    n     y[n]');
disp([ny' y']);

% ---------- Escala común para los 3 gráficos ----------
nmin = min([nx(1), nh(1), ny(1)]);
nmax = max([nx(end), nh(end), ny(end)]);
lim_n = [nmin-1, nmax+1];

% ---------- Gráficos ----------
c_x = [0.85 0.25 0.20];   % rojo ladrillo
c_h = [0.20 0.45 0.75];   % azul medio
c_y = [0.15 0.60 0.40];   % verde oscuro

figure('Name', 'Convolución Discreta', 'NumberTitle', 'off', ...
       'Color', 'white', 'Position', [120 80 780 620]);

% x[n]
subplot(3,1,1);
stem(nx, x, 'filled', 'LineWidth', 1.6, 'Color', c_x, 'MarkerSize', 6, ...
     'MarkerFaceColor', c_x, 'MarkerEdgeColor', c_x);
title('x[n]  -  Pulso rectangular unitario', 'FontWeight', 'bold', 'Color', c_x);
xlabel('n'); ylabel('Amplitud');
xlim(lim_n); ylim([-0.3 1.5]);
grid on; set(gca, 'Box', 'off', 'XTick', nmin-1:nmax+1);

% h[n]
subplot(3,1,2);
stem(nh, h, 'filled', 'LineWidth', 1.6, 'Color', c_h, 'MarkerSize', 6, ...
     'MarkerFaceColor', c_h, 'MarkerEdgeColor', c_h);
title('h[n] = n  -  Respuesta al impulso (rampa)', 'FontWeight', 'bold', 'Color', c_h);
xlabel('n'); ylabel('Amplitud');
xlim(lim_n); ylim([-0.5 max(h)+1.5]);
grid on; set(gca, 'Box', 'off', 'XTick', nmin-1:nmax+1);

% y[n]
subplot(3,1,3);
stem(ny, y, 'filled', 'LineWidth', 1.6, 'Color', c_y, 'MarkerSize', 6, ...
     'MarkerFaceColor', c_y, 'MarkerEdgeColor', c_y);
[val_max, idx_max] = max(y);
text(ny(idx_max), val_max + 1.5, sprintf('%g', val_max), ...
     'HorizontalAlignment', 'center', 'Color', c_y, 'FontWeight', 'bold');
title('y[n] = x[n] * h[n]', 'FontWeight', 'bold', 'Color', c_y);
xlabel('n'); ylabel('Amplitud');
xlim(lim_n); ylim([-1 max(y)+4]);
grid on; set(gca, 'Box', 'off', 'XTick', nmin-1:nmax+1);

% Título general (sgtitle no existe en algunas versiones de Octave)
if exist('sgtitle')
  sgtitle('Ejercicio 1 - Convolución de señales discretas', 'FontWeight', 'bold');
else
  set(gcf, 'Name', 'Ejercicio 1 - Convolución de señales discretas');
end

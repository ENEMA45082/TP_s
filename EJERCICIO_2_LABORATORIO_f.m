% EJERCICIO 2 - Análisis Numérico (Convolución Discreta con filtro)
clc; clear; close all;

% ---------- Datos (cambiar acá para las otras corridas) ----------
Nx = 401;        % muestras de x[n]
Dt = 0.0001;     % paso de muestreo [s]   (probar: 0.0001, 0.0005, 0.001)
Fc = 500;        % frecuencia de corte [Hz]: entre 150 Hz y 1000 Hz
Nh = 101;        % muestras de h[n], IMPAR (probar: 21, 101, 301)

% ---------- Señal de entrada x[n] ----------
n_x = 0:(Nx-1);                  % arranca en t = 0
t   = n_x * Dt;                  % instantes de muestreo
x   = 10*cos(2*pi*150*t) + 5*sin(2*pi*1000*t);

% ---------- Respuesta al impulso h[n]: sinc centrada ----------
n_h = -(Nh-1)/2 : (Nh-1)/2;
h   = 2*Fc*Dt * sinc(2*Fc*Dt*n_h);     % sinc(x) = sin(pi x)/(pi x)

% ---------- Convolución ----------
y   = conv(x, h);
n_y = (n_x(1) + n_h(1)) : (n_x(end) + n_h(end));
lim_n = [n_y(1), n_y(end)];            % misma escala en los 3 gráficos

% Amplitud de la salida en la zona central (sin los transitorios de los bordes)
centro = y(Nh:Nx);   % solo donde h[n] se superpone entera con x[n]
printf('Dt = %g s | Fm = %g Hz | Fc = %g Hz | Nh = %d\n', Dt, 1/Dt, Fc, Nh);
printf('2*Fc*Dt = %g  |  amplitud máx de y[n] en la zona central = %.2f\n', 2*Fc*Dt, max(abs(centro)));

% ---------- Gráficos ----------
c_x = [0.85 0.25 0.20];   % rojo ladrillo
c_h = [0.20 0.45 0.75];   % azul medio
c_y = [0.15 0.60 0.40];   % verde oscuro

figure('Name', 'Ejercicio 2', 'NumberTitle', 'off', ...
       'Color', 'white', 'Position', [120 80 780 620]);

% x[n]
subplot(3,1,1);
stem(n_x, x, 'filled', 'LineWidth', 1.0, 'Color', c_x, 'MarkerSize', 3, ...
     'MarkerFaceColor', c_x, 'MarkerEdgeColor', c_x);
title('x[n]  -  10cos(2\pi·150·t) + 5sen(2\pi·1000·t)', ...
      'FontWeight', 'bold', 'Color', c_x);
xlabel('n'); ylabel('Amplitud');
xlim(lim_n); grid on; set(gca, 'Box', 'off');

% h[n]
subplot(3,1,2);
stem(n_h, h, 'filled', 'LineWidth', 1.0, 'Color', c_h, 'MarkerSize', 3, ...
     'MarkerFaceColor', c_h, 'MarkerEdgeColor', c_h);
title('h[n]  -  2Fc·\Deltat·sinc(2Fc·\Deltat·n)', ...
      'FontWeight', 'bold', 'Color', c_h);
xlabel('n'); ylabel('Amplitud');
xlim(lim_n); grid on; set(gca, 'Box', 'off');

% y[n]
subplot(3,1,3);
stem(n_y, y, 'filled', 'LineWidth', 1.0, 'Color', c_y, 'MarkerSize', 3, ...
     'MarkerFaceColor', c_y, 'MarkerEdgeColor', c_y);
title('y[n]  =  x[n] * h[n]', 'FontWeight', 'bold', 'Color', c_y);
xlabel('n'); ylabel('Amplitud');
xlim(lim_n); grid on; set(gca, 'Box', 'off');

% Título general (sgtitle no existe en algunas versiones de Octave)
titulo = sprintf('Ejercicio 2 - Filtro pasa bajo | Dt = %g s, Fc = %g Hz, Nh = %d', Dt, Fc, Nh);
if exist('sgtitle')
  sgtitle(titulo, 'FontWeight', 'bold');
else
  set(gcf, 'Name', titulo);
end

% ================== CONCLUSIONES (correr con los valores indicados) ==================
% Se resolvió con Fc = 500 Hz (entre 150 y 1000 Hz). Con Fc = 1000 Hz el corte cae
% justo sobre la componente a eliminar y esta pasa a la mitad (ganancia 0.5).
%
% 1) Dt = 0.0001 (Fm = 10 kHz), Nh = 101: el filtro funciona. Queda la cos de 150 Hz
%    con amplitud 10 y los 1000 Hz bajan a ~1.4%. En los bordes (~(Nh-1)/2 muestras
%    de cada lado) hay un transitorio porque h[n] no se superpone entera con x[n].
% 2) Dt = 0.0005 (Fm = 2 kHz): los 1000 Hz quedan justo en Nyquist (Fm/2), el seno
%    muestreado vale 0 en todas las muestras y la componente desaparece de x[n]
%    antes de filtrar (efecto del muestreo, no del filtro).
% 3) Dt = 0.001 (Fm = 1 kHz): los 1000 Hz se pliegan a 0 Hz (aliasing, sen = 0) y,
%    como Fc = Fm/2, 2*Fc*Dt = 1 -> h[n] = delta[n]: el filtro no hace nada (y = x).
%    Con Fc = 1000 Hz sería 2*Fc*Dt = 2 -> h = 2*delta y la salida se duplica.
%    Regla: Fm debe ser bastante mayor que 2*1000 Hz para no perder la componente.
% 4) Variar Nh (Dt = 0.0001): con Nh = 21 el filtro es poco selectivo (los 1000 Hz
%    pasan al ~6% y los 150 Hz salen con ganancia ~1.09 por las ondulaciones);
%    con Nh = 101 es 1.4% y 1.00; con Nh = 301 es aún mejor. A mayor Nh, mejor
%    filtro, pero más cálculo y transitorios más largos en los bordes.
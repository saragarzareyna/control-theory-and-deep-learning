% Cargar datos de Simulink
t_red   = out.red.Time;
t_ctrl  = out.control.Time;
t_input = out.input.Time;

y_red     = out.red.Data;
y_ctrl    = out.control.Data;
input_sig = out.input.Data;

% Colores
c_input = [0.50, 0.50, 0.50];
c_ctrl  = [0.18, 0.45, 0.75];
c_red   = [0.47, 0.67, 0.19];

% Figura
figure('Color', 'white', 'Position', [100, 100, 1100, 520]);

plot(t_input, input_sig, 'Color', c_input, ...
    'LineWidth', 1.5, 'LineStyle', ':', 'DisplayName', 'Entrada');
hold on;

plot(t_ctrl, y_ctrl, 'Color', c_ctrl, ...
    'LineWidth', 2, 'DisplayName', 'Teoría de control');

plot(t_red, y_red, 'Color', c_red, ...
    'LineWidth', 2, 'DisplayName', 'Basado en datos (CNN)');

xlabel('Tiempo (s)', 'FontSize', 13, 'FontWeight', 'bold');
ylabel('Temperatura (°C)', 'FontSize', 13, 'FontWeight', 'bold');
title('Comparación de modelos — Horno Fusor', ...
    'FontSize', 15, 'FontWeight', 'bold');
legend('FontSize', 11, 'Location', 'southeast');
grid on; grid minor;
xlim([0, 80000]);
ylim([0,1000]);
set(gca, 'FontSize', 11, 'Box', 'on');
hold off;
% Cargar datos de Simulink
t = out.tempout_c.Time;
y = out.tempout_c.Data;

% Figura
figure('Color', 'white', 'Position', [100, 100, 1000, 500]);

plot(t/3600, y, 'Color', [0.18, 0.45, 0.75], ...
    'LineWidth', 2, 'DisplayName', 'Temperatura del horno');
hold on;
yline(780, 'Color', [0.85, 0.33, 0.10], 'LineWidth', 1.8, ...
    'LineStyle', '--', 'DisplayName', 'Setpoint (780°C)');

xlabel('Tiempo (horas)', 'FontSize', 13, 'FontWeight', 'bold');
ylabel('Temperatura (°C)', 'FontSize', 13, 'FontWeight', 'bold');
title('Respuesta del Horno Fusor — Control Clásico PID', ...
    'FontSize', 15, 'FontWeight', 'bold');
legend('FontSize', 11, 'Location', 'southeast');
grid on;
grid minor;
xlim([0, t(end)/3600]);
ylim([740, 860]);
set(gca, 'FontSize', 11, 'Box', 'on');

hold off;
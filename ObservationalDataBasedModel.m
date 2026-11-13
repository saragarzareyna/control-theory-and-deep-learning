% SISTEMA COMPLETO - Horno Fusor (Lazo Cerrado) — versión RED NEURONAL (CNN)

% --- PID (mismo controlador) ---
Kp    = 0.0032072;
C_num = [1, 0.002419];
C_den = [1, 0.0002966];
C     = Kp * tf(C_num, C_den);

% --- Planta CNN ---
P_num = [-0.000749, 9.681e-06];
P_den = [1, 0.02014, 9.321e-05];
P     = tf(P_num, P_den);

% --- Lazo cerrado SIN escala todavía ---
G_open   = C * P;
G_closed = feedback(G_open, 1);

% --- Calcular K_ref automáticamente para que llegue a 780 ---
dc_raw = dcgain(G_closed);
K_ref  = 1 / dc_raw;          % <-- esto fuerza ganancia DC = 1
G_final = K_ref * G_closed;

% --- Análisis ---
disp('G(s) lazo cerrado (CNN)')
G_final
zpk(G_final)

disp('polos'),  pole(G_final)
disp('ceros'),  zero(G_final)

dc_final = dcgain(G_final);
T_ss = 780 * dc_final;
ess  = 780 - T_ss;
fprintf('K_ref calculado = %.6f\n', K_ref)
fprintf('ganancia DC = %.6f\n', dc_final)
fprintf('T_ss = %.4f C\n', T_ss)
fprintf('error estado estable = %.4f C\n', ess)

% --- Respuesta al escalón de 780 ---
t_sim = 0:1:40000;
[y, t] = step(780 * G_final, t_sim);

figure('Color','white','Position',[100,100,1000,500]);
plot(t/3600, y, 'Color',[0.18,0.45,0.75],'LineWidth',2,'DisplayName','Temperatura del horno');
hold on;
yline(780,'Color',[0.85,0.33,0.10],'LineWidth',1.8,'LineStyle','--','DisplayName','Setpoint (780°C)');
xlabel('Tiempo (horas)','FontSize',13,'FontWeight','bold');
ylabel('Temperatura (°C)','FontSize',13,'FontWeight','bold');
title('Respuesta del Horno Fusor — G(s) Modelo CNN con Control Clásico PID','FontSize',15,'FontWeight','bold');
legend('FontSize',11,'Location','southeast');
grid on; grid minor;
xlim([0, t(end)/3600]); ylim([0, 900]);
set(gca,'FontSize',11,'Box','on');
hold off;
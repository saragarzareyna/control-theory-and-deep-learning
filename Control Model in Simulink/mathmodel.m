% SISTEMA COMPLETO - Horno Fusor (Lazo Cerrado)
% Réplica exacta del diagrama Simulink (sin perturbaciones)

% --- Pre-ganancia de referencia (bloque 780/675 ANTES del comparador) ---
K_ref = 780/675;

% --- PID ---
Kp    = 0.0032072;
C_num = [1, 0.002419];
C_den = [1, 0.0002966];
C     = Kp * tf(C_num, C_den);

% --- Planta (coeficientes EXACTOS del bloque Simulink) ---
P_num = [-0.022685, 7.5617e-05];
P_den = [1, 0.00342593, 3.0864e-7];
P     = tf(P_num, P_den);

% --- Lazo abierto y cerrado ---
% El K_ref pre-multiplica la referencia; dentro del lazo va C*P
G_open   = C * P;
G_closed = feedback(G_open, 1);

% Lazo cerrado visto desde el escalón de entrada (incluye K_ref)
G_final  = K_ref * G_closed;

% --- Análisis ---
disp('G(s) lazo cerrado')
G_final
zpk(G_final)

disp('polos'),  pole(G_final)
disp('ceros'),  zero(G_final)

dc_final = dcgain(G_final);
T_ss = 780 * dc_final;
ess  = 780 - T_ss;
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
title('Respuesta del Horno Fusor — G(s) con Control Clásico PID','FontSize',15,'FontWeight','bold');
legend('FontSize',11,'Location','southeast');
grid on; grid minor;
xlim([0, t(end)/3600]); ylim([0, 1300]);
set(gca,'FontSize',11,'Box','on');
hold off;
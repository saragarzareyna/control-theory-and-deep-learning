% Controlador
Kp = 0.0032072;
C_num = [1, 0.002419];
C_den = [1, 0.0002966];
C = Kp * tf(C_num, C_den);

% Planta
P_num = [-0.0648148*0.035, 0.00021605*0.035];
P_den = [1, 0.00342593, 3.0864e-7];
P = tf(P_num, P_den);

% Lazo cerrado
G_open = C * P;          % lazo abierto
G_closed = feedback(G_open, 1)  % lazo cerrado con retroalimentación unitaria

% Ver polos y ceros
pole(G_closed)
zero(G_closed)
zpk(G_closed)            % forma más limpia


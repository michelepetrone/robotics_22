%clc;

%% CONTROLLO ROBUSTO

% Guadagni
Kd_cr=200*eye(4);
Kp_cr=(Kd_cr^2)/2 * eye(4);
% Definizione matrici
D=[zeros(4); eye(4)];
Htilde= [zeros(4) eye(4); -Kp_cr -Kd_cr];
P=eye(8);
Q=lyap(Htilde, P);

%% CONTROLLO ADATTATIVO

pi_0 = [m1; I1(3,3); Im1(3,3); Fm(1,1); m2; I2(3,3); Im2(3,3); Fm(2,2); m3; 0; Im3(3,3); Fm(3,3); 0; I4(3,3); Im4(3,3); Fm(4,4)];
Kd_ad = diag([250 250 250 250]);
Lambda = diag([50 50 50 50]);

% L'adattamento deve agire prevalentemente su m4, per questo motivo il
% corrispettivo valore nella matrice dei pesi deve essere scelto
% sufficientemente piccolo
K_pi = diag([100 100 100 100 100 100 100 100 100 100 100 100 0.1 100 100 100]);

%% CONTROLLO CON AZIONE INTEGRALE
% Si impone un autovalore in -100 e gli altri due in -10
Ki_ci=1e4;
Kp_ci=2100;
Kd_ci=120;

%% Esecuzione Script Simulink
sim('controllo_robusto.slx',40)
% Cambiare il modello in caso si voglia eseguire un altro controllo

%% Grafici

figure();
Q_q = permute(q.signals.values,[1 3 2]);
plot(q.time,Q_q);
grid;
title('$q(t)$','Interpreter','latex','FontSize',12);
xlabel('t','Interpreter','latex','FontSize',12);
legend('$1$','$2$','$3$','$4$','Interpreter','latex');
figure();
Q_dot = permute(q_dot.signals.values,[1 3 2]);
plot(q.time,Q_dot);
grid;
title('$\dot{q}(t)$','Interpreter','latex','FontSize',12);
xlabel('t','Interpreter','latex','FontSize',12);
legend('$1$','$2$','$3$','$4$','Interpreter','latex');
figure();
Q_dot_dot = permute(q_dot_dot.signals.values,[1 3 2]);
plot(q.time,Q_dot_dot);
grid;
title('$\ddot{q}(t)$','Interpreter','latex','FontSize',12);
xlabel('t','Interpreter','latex','FontSize',12);
legend('$1$','$2$','$3$','$4$','Interpreter','latex');

figure();
TAU = permute(tau.signals.values,[1 3 2]);
plot(q.time,TAU);
grid;
title('$\tau(t)$','Interpreter','latex','FontSize',12);
xlabel('t','Interpreter','latex','FontSize',12);
legend('$1$','$2$','$3$','$4$','Interpreter','latex');

figure();
Q_TILDE = permute(q_tilde.signals.values,[1 3 2]);
plot(q.time,Q_TILDE);
grid;
title('$\tilde{q}(t)$','Interpreter','latex','FontSize',12);
xlabel('t','Interpreter','latex','FontSize',12);
legend('$1$','$2$','$3$','$4$','Interpreter','latex');
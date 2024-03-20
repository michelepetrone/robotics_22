%clc;

%% Parametri e guadagni

angolo = acos(0.75);
theta1_0 = pi/2 - angolo;
theta2_0 = 2*angolo;

k_inversa = 10;
k_trasposta = 500;
k_pinv = 10;

k_d = 20;               % CLIK del secondo ordine
k_p = (k_d^2)/2;

%% Simulazione e grafici

sim("CLIK_secondo_ordine");

figure();
Q_d = permute(q_d.signals.values,[1 3 2]);
plot(q_d.time,Q_d);
grid;
title('$q_{d}(t)$','Interpreter','latex','FontSize',12);
xlabel('t','Interpreter','latex','FontSize',12);
legend('$1$','$2$','$3$','$4$','Interpreter','latex');
figure();
Q_d_dot = permute(q_d_dot.signals.values,[1 3 2]);
plot(q_d.time,Q_d_dot);
grid;
title('$\dot{q}_{d}(t)$','Interpreter','latex','FontSize',12);
xlabel('t','Interpreter','latex','FontSize',12);
legend('$1$','$2$','$3$','$4$','Interpreter','latex');
figure();
Q_d_dot_dot = permute(q_d_dot_dot.signals.values,[1 3 2]);
plot(q_d.time,Q_d_dot_dot);
grid;
title('$\ddot{q}_{d}(t)$','Interpreter','latex','FontSize',12);
xlabel('t','Interpreter','latex','FontSize',12);
legend('$1$','$2$','$3$','$4$','Interpreter','latex');

figure();
E = permute(e.signals.values,[1 3 2]);
plot(q_d.time,E);
grid;
title('$e(t)$','Interpreter','latex','FontSize',12);
xlabel('t','Interpreter','latex','FontSize',12);
legend('$x$','$y$','$z$','$\phi$','Interpreter','latex');
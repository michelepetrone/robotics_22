%clear; close all; clc;

%% Leggi orarie con profilo di velocità quadratico
tf = 5;
W = [1 0 0 0; 0 1 0 0; 1 tf tf^2 tf^3; 0 1 2*tf 3*tf^2];
a1 = W \ [0 0 0.5*pi/2 0]';

tf = 4;
W = [1 0 0 0; 0 1 0 0; 1 tf tf^2 tf^3; 0 1 2*tf 3*tf^2];
a2 = W \ [0 0 0.25 0]';
a2_phi = W \ [0 0 pi/2 0]';     % orientamento

tf = 4;
W = [1 0 0 0; 0 1 0 0; 1 tf tf^2 tf^3; 0 1 2*tf 3*tf^2];
a3 = W \ [0 0 0.25 0]';

tf = 5;
W = [1 0 0 0; 0 1 0 0; 1 tf tf^2 tf^3; 0 1 2*tf 3*tf^2];
a4 = W \ [0 0 0.5*pi/2 0]';

tf = 4;
W = [1 0 0 0; 0 1 0 0; 1 tf tf^2 tf^3; 0 1 2*tf 3*tf^2];
a5 = W \ [0 0 0.25 0]';

tf = 4;
W = [1 0 0 0; 0 1 0 0; 1 tf tf^2 tf^3; 0 1 2*tf 3*tf^2];
a6 = W \ [0 0 0.25 0]';
a6_phi = W \ [0 0 pi/2 0]';     % orientamento

tf = 4;
W = [1 0 0 0; 0 1 0 0; 1 tf tf^2 tf^3; 0 1 2*tf 3*tf^2];
a7 = W \ [0 0 0.5*pi/2 0]';

tf = 4;
W = [1 0 0 0; 0 1 0 0; 1 tf tf^2 tf^3; 0 1 2*tf 3*tf^2];
a8 = W \ [0 0 0.5*pi/2 0]';

tf = 6;
W = [1 0 0 0; 0 1 0 0; 1 tf tf^2 tf^3; 0 1 2*tf 3*tf^2];
a9 = W \ [0 0 (sqrt(5)/4)*(pi - 2*atan(1/2)) 0]';

%% Simulazione e grafici

T = 1e-3;
p_d_0 = [0 0.75 -0.25]';
phi_d_0 = 0;
sim("traiettoria");

P_d = permute(p_d.signals.values,[1 3 2]);
P_d_dot = permute(p_d_dot.signals.values,[1 3 2]);
P_d_dot_dot = permute(p_d_dot_dot.signals.values,[1 3 2]);
Phi_d = permute(phi_d.signals.values,[1 3 2]);
Phi_d_dot = permute(phi_d_dot.signals.values,[1 3 2]);
Phi_d_dot_dot = permute(phi_d_dot_dot.signals.values,[1 3 2]);

figure();                                               % plot 3D della traiettoria
plot3(P_d(1,:),P_d(2,:),P_d(3,:));
hold on;

x = [0 0.5 0.5 0.5 0 0 -0.5 0];                         % coordinate dei punti nello spazio di lavoro
y = [0.75 0.25 0.25 0 0.5 0.75 0.25 -0.25];
z = [-0.25 -0.25 -0.5 -0.5 -0.5 -0.5 -0.25 -0.25];
scatter3(x,y,z,"Marker","x","LineWidth",1);
text(x,y,z,{'  1 7 10' '  2' '  3' '  4' '  5' '  6' '  8' '  9'});
grid on;
title('$p_{d}$','Interpreter','latex','FontSize',12);
xlabel('$x_{0}$','Interpreter','latex','FontSize',12);
ylabel('$y_{0}$','Interpreter','latex','FontSize',12);
zlabel('$z_{0}$','Interpreter','latex','FontSize',12);

% Andamenti
figure();
plot(p_d.time,[P_d; Phi_d]);
grid;
title('$x_{d}(t)$','Interpreter','latex','FontSize',12);
xlabel('t','Interpreter','latex','FontSize',12);
legend('$x$','$y$','$z$','$\phi$','Interpreter','latex');
figure();
plot(p_d.time,[P_d_dot; Phi_d_dot]);
grid;
title('$\dot{x}_{d}(t)$','Interpreter','latex','FontSize',12);
xlabel('t','Interpreter','latex','FontSize',12);
legend('$x$','$y$','$z$','$\phi$','Interpreter','latex');
figure();
plot(p_d.time,[P_d_dot_dot; Phi_d_dot_dot]);
grid;
title('$\ddot{x}_{d}(t)$','Interpreter','latex','FontSize',12);
xlabel('t','Interpreter','latex','FontSize',12);
legend('$x$','$y$','$z$','$\phi$','Interpreter','latex');
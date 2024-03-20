%clc;

q = sym('q',[1 4],'real')';
q_dot = sym('q_dot',[1 4],'real')';
q_dot_dot = sym('q_dot_dot',[1 4],'real')';

% Denavit-Hartenberg e cinematica differenziale
a = [0.5 0.5 0 0];
alfa = [0 0 pi 0];

T_01 = T_DH(a(1),alfa(1),q(1),0);
T_02 = T_01 * T_DH(a(2),alfa(2),q(2),0);
T_03 = T_02 * T_DH(a(3),alfa(3),0,q(3));
T_04 = T_03 * T_DH(a(4),alfa(4),q(4),0);

R_1 = T_01(1:3,1:3);
R_2 = T_02(1:3,1:3);
R_3 = T_03(1:3,1:3);
R_4 = T_04(1:3,1:3);

z_0 = [0 0 1]';
z_1 = z_0;
z_2 = z_1;
z_3 = -z_2;
z_4 = z_3;

p_1 = T_01(1:3,4);
p_e = T_04(1:3,4);

J = [cross(z_0,p_e) cross(z_1,p_e-p_1) z_2 zeros(3,1); 1 1 0 -1];       % Jacobiano geometrico
x_e = [p_e; q(4)];                                                      % Posa dell'end-effector

J_p = J(1:3,:);
J_p_1 = [cross(z_0,p_1) zeros(3)];

J_dot = [cross(z_0,J_p*q_dot) cross(z_1,J_p*q_dot - J_p_1*q_dot) zeros(3,2); 0 0 0 0];

% Dinamica
l1 = 0.25;
l2 = 0.25;

T_01_b = T_DH(l1,alfa(1),q(1),0);
T_02_b = T_01 * T_DH(l2,alfa(2),q(2),0);

p_1 = T_01_b(1:3,4);
J_p_1 = [cross(z_0,p_1) zeros(3)];
p_2 = T_02_b(1:3,4);
p_1 = T_01(1:3,4);
J_p_2 = [cross(z_0,p_2) cross(z_1,p_2 - p_1) zeros(3,2)];
p_3 = T_03(1:3,4);
J_p_3 = [cross(z_0,p_3) cross(z_1,p_3 - p_1) z_2 zeros(3,1)];
p_1 = T_01_b(1:3,4);

J_o_1 = [z_0 zeros(3)];
J_o_2 = [z_0 z_1 zeros(3,2)];
J_o_3 = [z_0 z_1 zeros(3,2)];
J_o_4 = [z_0 z_1 zeros(3,1) z_3];

m1 = 20;        I1 = zeros(3,3); I1(3,3) = 4;
m2 = 20;        I2 = zeros(3,3); I2(3,3) = 4;
m3 = 10;
                I4 = zeros(3,3); I4(3,3) = 1;
                                  
B1 = m1 * (J_p_1' * J_p_1) + J_o_1' * R_1 * I1 * R_1' * J_o_1;
B2 = m2 * (J_p_2' * J_p_2) + J_o_2' * R_2 * I2 * R_2' * J_o_2;
B3 = m3 * (J_p_3' * J_p_3);
B4 = J_o_4' * R_4 * I4 * R_4' * J_o_4;

Im1 = zeros(3,3); Im1(3,3) = 0.01;      kr1 = 1;
Im2 = zeros(3,3); Im2(3,3) = 0.01;      kr2 = 1;
Im3 = zeros(3,3); Im3(3,3) = 0.005;     kr3 = 50;
Im4 = zeros(3,3); Im4(3,3) = 0.001;     kr4 = 20;

J_o_m_1 = kr1 * z_0 * [1 0 0 0];
T_01_m = T_DH(0,0,kr1*q(1),0);
R_1_m = T_01_m(1:3,1:3);
Bm1 = J_o_m_1' * R_1_m * Im1 * R_1_m' * J_o_m_1;

J_o_m_2 = J_o_1 + kr2 * z_1 * [0 1 0 0];
T_02_m = T_01 * T_DH(0,0,kr2*q(2),0);
R_2_m = T_02_m(1:3,1:3);
Bm2 = J_o_m_2' * R_2_m * Im2 * R_2_m' * J_o_m_2;

J_o_m_3 = J_o_2 + kr3 * z_2 * [0 0 1 0];
T_03_m = T_02 * T_DH(0,0,kr3*q(3),0);
R_3_m = T_03_m(1:3,1:3);
Bm3 = J_o_m_3' * R_3_m * Im3 * R_3_m' * J_o_m_3;

J_o_m_4 = J_o_3 + kr4 * z_3 * [0 0 0 1];
T_04_m = T_03 * T_DH(0,0,kr4*q(4),0);
R_4_m = T_04_m(1:3,1:3);
Bm4 = J_o_m_4' * R_4_m * Im4 * R_4_m' * J_o_m_4;

B = B1 + B2 + B3 + B4 + Bm1 + Bm2 + Bm3 + Bm4;

B_dot = diff(B,q(2))*q_dot(2) + diff(B,q(3))*q_dot(3) + diff(B,q(4))*q_dot(4);

g0 = [0 0 -9.81];
U1 = -g0 * m1 * p_1;
U2 = -g0 * m2 * p_2; 
U3 = -g0 * m3 * p_3;
U = U1 + U2 + U3;

Fm = diag([0.00005,0.00005,0.01,0.005]);

n = B_dot * q_dot - (1/2) * gradient(q_dot' * B * q_dot,q) + Fm * q_dot + gradient(U,q);
tau = B * q_dot_dot + n;

function T = T_DH(a,alfa,theta,d)

    T_A = [cos(theta)   -sin(theta)     0       0;
           sin(theta)    cos(theta)     0       0;
                0           0           1       d;
                0           0           0       1];
    
    T_B = [cos(alfa)        0       sin(alfa)   a;
                0           1           0       0;
          -sin(alfa)        0       cos(alfa)   0;
                0           0           0       1];
    
    T = T_A * T_B;
end
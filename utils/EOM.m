clc;
close all;
global ssA ssB
syms theta phi dtheta dphi ddtheta ddphi tau real
%syms g m1 m2 I1x I1y I1z I2x I2y I2z l1 L1 l2 real
syms g real
syms T P real

% linear velocity
vc1 = [-0.5*cos(theta)*dtheta -0.5*sin(theta)*dtheta 0]';
vc2 = [-cos(theta)*dtheta-dtheta*sin(phi)*sin(theta)+dphi*cos(theta)*cos(phi)...
    -sin(theta)*dtheta+dtheta*sin(phi)*cos(theta)+dphi*sin(theta)*cos(phi) ...
    -dphi*cos(theta)*sin(phi)*cos(theta)-dphi*sin(theta)*sin(phi)*sin(theta)]';

% angular velocity 
w1 = [0 0 dtheta]';
w2 = [-dphi*sin(theta) dphi*cos(theta) dtheta]';

%Inertia Matrices
I1 = diag([0.08400000000000001, 0.0013, 0.08400000000000001]);
I2 = diag([0.3681, 0.3681, 0.0013]);

R1 = [cos(theta) -sin(theta) 0;
    sin(theta) cos(theta) 0;
    0          0          1];

R2 = [cos(phi) 0 sin(phi);
    0          1 0;
    -sin(phi)  0 cos(phi)];
I1R = simplify(R1'*I1*R1);
I2R = simplify((R1*R2)'*I2*(R1*R2));

T=0.5*(vc1'*vc1)+0.5*w1'*I1R*w1 +0.5*(vc2'*vc2) + 0.5*w2'*I2R*w2;
T=simplify(T);
P=g*cos(phi);

%the lagrangian
Lg = simplify(T-P);

%derivative in velocity item
partial_dtheta = simplify(diff(Lg, dtheta));
partial_dphi = simplify(diff(Lg, dphi));

time_der1 = diff(partial_dtheta, dtheta)*ddtheta + diff(partial_dtheta, theta)*dtheta...
    +diff(partial_dtheta, dphi)*ddphi + diff(partial_dtheta, phi)*dphi;
time_der1 = simplify(time_der1);

time_der2 = diff(partial_dphi, dtheta)*ddtheta + diff(partial_dphi, theta)*dtheta...
    +diff(partial_dphi, dphi)*ddphi + diff(partial_dphi, phi)*dphi;
time_der2 = simplify(time_der2);

partial_theta = simplify(diff(Lg, theta));
partial_phi = simplify(diff(Lg, phi));

%  equations of motion
Eq1 = simplify(time_der1 - partial_theta);
Eq2 = simplify(time_der2 - partial_phi);

H11 = diff(Eq1, ddtheta);
H12 = diff(Eq1, ddphi);
G1 = diff(Eq1, g)*g;
C1 = simplify(Eq1 - H11*ddtheta - H12*ddphi - G1);

H21 = diff(Eq2, ddtheta);
H22 = diff(Eq2, ddphi);
G2 = diff(Eq2, g)*g;
C2 = simplify(Eq2 - H21*ddtheta - H22*ddphi - G2);

D_mtx =[H11 H12;H21 H22];
C_vec = [C1; C2];
G_vec = [G1; G2];
input_vec = [tau;0];
f = D_mtx\(input_vec - C_vec - G_vec);
subs_vec = [theta phi dtheta dphi];
lin_point = [0 0 0 0];
A11 = simplify(subs(diff(f(1), theta), subs_vec, lin_point));
A12 = simplify(subs(diff(f(1), phi), subs_vec, lin_point));
A13 = simplify(subs(diff(f(1), dtheta), subs_vec, lin_point));
A14 = simplify(subs(diff(f(1), dphi), subs_vec, lin_point));

A21 = simplify(subs(diff(f(2), theta), subs_vec, lin_point));
A22 = simplify(subs(diff(f(2), phi), subs_vec, lin_point));
A23 = simplify(subs(diff(f(2), dtheta), subs_vec, lin_point));
A24 = simplify(subs(diff(f(2), dphi), subs_vec, lin_point));


B1 = simplify(subs(diff(f(1), tau), subs_vec, lin_point));
B2 = simplify(subs(diff(f(2), tau), subs_vec, lin_point));


ssA = [[ 0 0 1 0];
       [ 0 0 0 1];
       [A11 A12 A13 A14];
       [A21 A22 A23 A24]];
ssB = [0; 0; B1; B2];

%matlabFunction(vc2,'File', ['com_lv'],'Vars',{theta phi dtheta dphi},'Outputs',{'com2_lv' });
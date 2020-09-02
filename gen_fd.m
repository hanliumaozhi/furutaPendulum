import casadi.*

theta = MX.sym('theta', 1);
dtheta = MX.sym('dtheta', 1);
ddtheta = MX.sym('ddtheta', 1);
phi = MX.sym('phi', 1);
dphi = MX.sym('dphi', 1);
ddphi = MX.sym('ddphi', 1);
g = MX.sym('g', 1);

f1 = Function('f1', {theta, dtheta, ddtheta, phi, dphi, ddphi,  g},{dphi^2*sin(phi) + (917*dphi^2*sin(theta))/2500 - ddtheta*((3417*cos(phi)^2)/2500 - 27021/10000) - ddphi*(cos(phi) + (917*cos(phi)*sin(phi)*sin(theta))/2500) - (917*dphi^2*cos(phi)^2*sin(theta))/1250 + (917*dphi^2*cos(theta)*sin(theta))/2500 - (917*dphi^2*cos(phi)^2*cos(theta)*sin(theta))/2500 + (3417*dphi*dtheta*cos(phi)*sin(phi))/1250},{'theta', 'dtheta', 'ddtheta', 'phi', 'dphi', 'ddphi', 'g'},{'f'});
f1(0.0098,0.4706,14.7423,3.1351,-0.3395,-10.7295,9.81);
opts = struct('mex', true);
f1.generate('fd_f.c', opts);
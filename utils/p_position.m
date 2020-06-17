function [p_1, p_2] = p_position(theta, phi, l1, l2, L1)
    p_1 = zeros(3,1);
    p_2 = zeros(3,1);
    p_1(1) = -l1*sin(theta);
    p_1(2) = l1*cos(theta);
    p_2(1) = -L1*sin(theta)+l2*sin(phi)*cos(theta);
    p_2(2) = L1*cos(theta)+l2*sin(phi)*sin(theta);
    p_2(3) = l2*cos(phi);
end
function [lv_1, lv_2, av_1, av_2] = p_velocity(theta, phi, dot_theta, dot_phi, l1, l2, L1)
    lv_1 = zeros(3, 1);
    lv_2 = zeros(3, 1);
    av_1 = zeros(3, 1);
    av_2 = zeros(3, 1);
    
    l2_position = zeros(3, 1);
    
    av_1(3) = dot_theta;
    
    av_2(1) = -dot_phi*sin(theta);
    av_2(2) = dot_phi*cos(theta);
    av_2(3) = dot_theta;
    
    lv_1(1)= l1*-cos(theta)*dot_theta;
    lv_1(2) = l1*-sin(theta)*dot_theta;
    
    l2_position(1) = l2*sin(phi)*cos(theta);
    l2_position(2) = l2*sin(phi)*sin(theta);
    l2_position(3) = l2*cos(phi);
    
    skew_av_2 = [0 -av_2(3) av_2(2);av_2(3) 0 -av_2(1); -av_2(2) av_2(1) 0]; 
    
    lv_2(1) = L1*-cos(theta)*dot_theta;
    lv_2(2) = L1*-sin(theta)*dot_theta;
    
    tem_vector = skew_av_2*l2_position;
    
    lv_2 = lv_2 + tem_vector; 
    
end
curren_phase_index = 1;
phase_index = 1;
op_data = OptimalData;
torque_list = zeros(5001, 1);
for i=1:5001
    if curren_phase_index > 51
        phase_index = phase_index + 1;
        curren_phase_index = 1;
    end
    
    phase_variable = (curren_phase_index)/(51.0);
    
    torque_list(i) = op_data.tau_list(phase_index) + phase_variable*(op_data.tau_list(phase_index+1) - op_data.tau_list(phase_index));
    curren_phase_index = curren_phase_index + 1;
end

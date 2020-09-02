file_id = fopen('data.txt', 'r');
formatSpec = '%f';
optimal_data = fscanf(file_id, formatSpec);
fclose(file_id);
tau_list = zeros(101, 1);
theta_list = zeros(101, 1);
dtheta_list = zeros(101, 1);
ddtheta_list = zeros(101, 1);
phi_list = zeros(101, 1);
dphi_list = zeros(101, 1);
ddphi_list = zeros(101, 1);
for i=1:101
    tau_list(i) = optimal_data(i*7);
    theta_list(i) = optimal_data((i-1)*7+1);
    dtheta_list(i) = optimal_data((i-1)*7+2);
    ddtheta_list(i) = optimal_data((i-1)*7+3);
    phi_list(i) = optimal_data((i-1)*7+4);
    dphi_list(i) = optimal_data((i-1)*7+5);
    ddphi_list(i) = optimal_data((i-1)*7+6);
end
optimal_datas.tau_list = tau_list;
optimal_datas.theta_list = theta_list;
optimal_datas.dtheta_list = dtheta_list;
optimal_datas.ddtheta_list = ddtheta_list;
optimal_datas.phi_list = phi_list;
optimal_datas.dphi_list = dphi_list;
optimal_datas.ddphi_list = ddphi_list;


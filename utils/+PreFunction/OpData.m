OP = load('op.mat');
OptimalData = OP.optimal_datas;
optimalDataBusInfo = Simulink.Bus.createObject(OptimalData);
optimalDataBus= eval(optimalDataBusInfo.busName);
classdef Controller < matlab.System & matlab.system.mixin.Propagates & matlab.system.mixin.SampleTime
    % Untitled Add summary here
    %
    % This template includes the minimum set of functions required
    % to define a System object with discrete state.

    % Public, tunable properties
    properties

    end

    properties(DiscreteState)

    end

    % Pre-computed constants
    properties(Access = private)
        K = [-2.2065 233.3886 -10.3683 34.0941];
        i2 = diag([0.3681, 0.3681, 0.0013]);
        current_state = 1;
        up_p_gain = 5;
        swing_up_index = 1;
        phase_index = 1;
        curren_phase_index = 1;
        worker_re = 0;
    end

    methods(Access = protected)
        function setupImpl(obj)
            % Perform one-time calculations, such as computing constants
        end

        function [y,torque] = stepImpl(obj,u, op_data)
            % Implement algorithm. Calculate y as a function of input u and
            % discrete states.
            %y = u;
            if obj.current_state == 1
                
                R1 = [cos(u.shoulder_position) -sin(u.shoulder_position) 0;
                    sin(u.shoulder_position) cos(u.shoulder_position) 0;
                    0          0          1];
                
                R2 = [cos(u.ellbow_position) 0 sin(u.ellbow_position);
                    0          1 0;
                    -sin(u.ellbow_position)  0 cos(u.ellbow_position)];
                % redefine
                theta = u.shoulder_position;
                phi = u.ellbow_position;
                dtheta = u.shoulder_velocity;
                dphi = u.ellbow_velocity;
                vc2 = [-cos(theta)*dtheta-dtheta*sin(phi)*sin(theta)+dphi*cos(theta)*cos(phi)...
                    -sin(theta)*dtheta+dtheta*sin(phi)*cos(theta)+dphi*sin(theta)*cos(phi) ...
                    -dphi*cos(theta)*sin(phi)*cos(theta)-dphi*sin(theta)*sin(phi)*sin(theta)]';
                w2 = [-dphi*sin(theta) dphi*cos(theta) dtheta]';
                current_inertial = (R1*R2)'*obj.i2*R1*R2;
                current_energy = 0.5*(vc2'*vc2) + 0.5*(w2'*current_inertial*w2)+9.81*cos(u.ellbow_position);
                
                if obj.curren_phase_index > 51
                    obj.phase_index = obj.phase_index + 1;
                    obj.curren_phase_index = 1;
                end
                
                R1 = [cos(op_data.theta_list(obj.phase_index)) -sin(op_data.theta_list(obj.phase_index)) 0;
                    sin(op_data.theta_list(obj.phase_index)) cos(op_data.theta_list(obj.phase_index)) 0;
                    0          0          1];
                
                R2 = [cos(op_data.phi_list(obj.phase_index)) 0 sin(op_data.phi_list(obj.phase_index));
                    0          1 0;
                    -sin(op_data.phi_list(obj.phase_index))  0 cos(op_data.phi_list(obj.phase_index))];
                % redefine
                theta = op_data.theta_list(obj.phase_index);
                phi = op_data.phi_list(obj.phase_index);
                dtheta = op_data.dtheta_list(obj.phase_index);
                dphi = op_data.dphi_list(obj.phase_index);
                vc2 = [-cos(theta)*dtheta-dtheta*sin(phi)*sin(theta)+dphi*cos(theta)*cos(phi)...
                    -sin(theta)*dtheta+dtheta*sin(phi)*cos(theta)+dphi*sin(theta)*cos(phi) ...
                    -dphi*cos(theta)*sin(phi)*cos(theta)-dphi*sin(theta)*sin(phi)*sin(theta)]';
                w2 = [-dphi*sin(theta) dphi*cos(theta) dtheta]';
                
                current_inertial_d = (R1*R2)'*obj.i2*R1*R2;
                current_energy_d = 0.5*(vc2'*vc2) + 0.5*(w2'*current_inertial_d*w2)+9.81*cos(op_data.phi_list(obj.phase_index));
                
                
                
                error = (current_energy-current_energy_d);
                if u.ellbow_velocity < 0.01
                    y.torque = -obj.up_p_gain*error;
                else
                    y.torque = -obj.up_p_gain*u.ellbow_velocity*error;
                end
              
                %y.torque = op_data.tau_list(obj.swing_up_inde
                
                
                obj.curren_phase_index = obj.curren_phase_index + 1;
                obj.swing_up_index = obj.swing_up_index + 1;
                if ((u.ellbow_position < deg2rad(15)) && (u.ellbow_position > deg2rad(-15))) || obj.swing_up_index > 5001
                    obj.current_state = 2;
                    y.torque = 0;
                    obj.worker_re = obj.swing_up_index;
                end
                
            else
                state_var = [u.shoulder_position u.ellbow_position u.shoulder_velocity u.ellbow_velocity]';
                y.torque = -obj.K*state_var;
            end
            %y.torque = 0;
            torque = obj.worker_re;
        end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
        end
        
        % PROPAGATES CLASS METHODS ============================================
        function [out, out1] = getOutputSizeImpl(~)
            %GETOUTPUTSIZEIMPL Get sizes of output ports.
            out = [1, 1];
            out1 = [1, 1];
        end % getOutputSizeImpl
        
        function [out, out1] = getOutputDataTypeImpl(~)
            %GETOUTPUTDATATYPEIMPL Get data types of output ports.
            out = 'PendulumInBus';
            out1 = 'double';
        end % getOutputDataTypeImpl
        
        function [out, out1] = isOutputComplexImpl(~) 
            %ISOUTPUTCOMPLEXIMPL Complexity of output ports.
            out = false;
            out1 = false;
        end % isOutputComplexImpl
        
        function [out, out1] = isOutputFixedSizeImpl(~)
            %ISOUTPUTFIXEDSIZEIMPL Fixed-size or variable-size output ports.
            out = true;
            out1 = true;
        end % isOutputFixedSizeImpl
    end
end

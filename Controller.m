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
    end

    methods(Access = protected)
        function setupImpl(obj)
            % Perform one-time calculations, such as computing constants
        end

        function [y,torque] = stepImpl(obj,u)
            % Implement algorithm. Calculate y as a function of input u and
            % discrete states.
            %y = u;
            state_var = [u.shoulder_position u.ellbow_position u.shoulder_velocity u.ellbow_velocity]';
            
            y.torque = -obj.K*state_var;
            %y.torque = 0;
            torque = y.torque;
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

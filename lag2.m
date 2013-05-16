function V=lag2(L,var);               %% INPUT variable always var(1) OUTPUT variable always var(2)
p.A1	= 3;
p.A2    = 10;
p.rho   = 1000;
p.P_o	= 0;
p.g		= 9.81;
p.k1    = 0.1;
p.k2    = 0.05;

i.F_in  = 100;



%States =   [ V1    V2]
%           [ 1     2 ]
% Algebraic Eq
F_out1 = @(S, i) p.k1*sqrt(p.rho*p.g*(S(1)/p.A1));
F_out2 = @(S, i) p.k2*sqrt(p.rho*p.g*(S(2)/p.A2));

% Differential
dSdt = @(S, i) [(i.F_in - F_out1(S, i)) 
                (F_out1(S, i) - F_out2(S, i))];

                % [ in out other]

        if var == [0 0 0]  ;                                        % if this is true, it means initial state must first be calculated, else, only dSdt is calculated
                s0 = [453 500]  ;                                   % steadystate initial guess values
                S = fsolve(@(S) dSdt(S, i), s0);
                var = [i.F_in S(2) S(1)];                           % Replaces zero vector with initial variables in METHOD
                V = var;                                            % Assigns var to output of function
                
        else
                i.F_in = i.F_in + L;
                var(1) = i.F_in;                                    % Apply LOAD
                S = [var(3) var(2)];                                % Define vector S for next line
                
                A = dSdt(S, i);
                V = [L A(2) A(1)];                                  % this vector (var) is added to the var vector by the METHOD
        end
         

    
    
end
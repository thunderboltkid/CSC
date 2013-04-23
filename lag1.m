function V=lag1(L,var);               %% INPUT variable always var(1) OUTPUT variable always var(2)
p.A		= 10;
p.rho   = 1000;
p.P_o	= 0;
p.g		= 9.81;
p.k     = 0.1;

i.F_in  = 100;

Vss     = 453;
F_out_ss= i.F_in;

%States =   [ V]
%           [ 1]
% Algebraic Eq
F_out = @(S, i) p.k*sqrt(p.rho*p.g*(S(1)/p.A));

% Differential
dSdt = @(S, i) [(i.F_in - F_out(S, i)) ];

    

        if var == [0 0 0]  ;                                        % if this is true, it means initial state must first be calculated, else, only dSdt is calculated
                s0 = [Vss]  ;                                       %steadystate initial values
                S = fsolve(@(S) dSdt(S, i), s0);
                var = [i.F_in S(1) F_out(S, i)];                    % Replaces zero vector with initial variables in METHOD
                V = var ;                                           % Assigns var to output of function
        else
                var(1) = i.F_in + L;                                % Apply LOAD
                i.F_in = i.F_in + L;
                S = [var(2)];                                       % Define vector S for next line
                V = [L dSdt(S, i) (F_out(S, i)-var(3))];                                  % this vector (var) is added to the var vector by the METHOD
        end
         

    
    
end
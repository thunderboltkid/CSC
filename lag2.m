function V=lag2(L,var);               %% INPUT variable always var(1) OUTPUT variable always var(2)
p.A1	= 6;
p.A2    = 5;
p.rho   = 1000;
p.P_o	= 0;
p.g		= 9.81;
p.k1    = 0.05;
p.k2    = 0.4;

i.F_in  = 10;



%States =   [ V1    V2]
%           [ 1     2 ]
% Algebraic Eq
F_out1 = @(S, i) p.k1*sqrt(p.rho*p.g*(S(1)/p.A1));
F_out2 = @(S, i) p.k2*sqrt(p.rho*p.g*(S(2)/p.A2));

% Differential
dSdt = @(S, i) [(i.F_in - F_out1(S, i)) 
                (F_out1(S, i) - F_out2(S, i))];

    

        if var == [0 0 0]  ;                                        % if this is true, it means initial state must first be calculated, else, only dSdt is calculated
                s0 = [453 500]  ;                                   % steadystate initial guess values
                S = fsolve(@(S) dSdt(S, i), s0);
                var = [i.F_in S(2) S(1)];                           % Replaces zero vector with initial variables in METHOD
                V = var ;                                           % Assigns var to output of function
        else
                var(1) = i.F_in + L;                                % Apply LOAD
                S = [var(2) var(1)];                                % Define vector S for next line
                i.F_in = i.F_in + L;
                A = dSdt(S, i);
                V = [L A(1) A(2)];                                  % this vector (var) is added to the var vector by the METHOD
        end
         

    
    
end
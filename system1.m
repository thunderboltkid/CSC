function F = system
p.A1	= 3;
p.A2    = 10;
p.rho   = 1000;
p.P_o	= 0;
p.g		= 9.81;
p.k1     = 0.1;
p.k2     = 0.05;

i.F_in  = 100;

Vss     = [453,453];
var = [0 0 0];
%States =   [ V1  V2]
%           [ 1   2 ]
% Algebraic Eq
F_out1 = @(S, i) p.k1*sqrt(p.rho*p.g*(S(1)/p.A1));
F_out2 = @(S, i) p.k2*sqrt(p.rho*p.g*(S(2)/p.A2));

% Differential
dSdt = @(S, i) [ (i.F_in - F_out1(S, i));
                 (F_out1(S, i) - F_out2(S, i)) ];
             Vol1 = [];
             Vol2 = [];
             F_in = [];
             tspan= [];
for t = [0:100];
    t
    if t>15
        i.F_in  = 120;
    end

        if var == [0 0 0]  ;                                        % if this is true, it means initial state must first be calculated, else, only dSdt is calculated
                s0 = [Vss]  ;                                       %steadystate initial values
                S = fsolve(@(S) dSdt(S, i), s0);
                var = [i.F_in S(1) S(2)];                           % Replaces zero vector with initial variables in METHOD
        else
                var(1) = i.F_in;                                    % Apply LOAD
                a = dSdt(S,i)
                var = var + [0 a(1) a(2)]                          % Define vector S for next line
                S = S + [a(1) a(2)];
        end
            Vol1 = [Vol1, var(2)];
            Vol2 = [Vol2, var(3)];
            F_in = [F_in, i.F_in];
            tspan= [tspan,t];
end   
plot(tspan,F_in,tspan,Vol2)%,tspan,Vol1)
end
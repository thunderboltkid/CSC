function V=third(L,var);               %% INPUT variable always var(1) OUTPUT variable always var(2)
p.A1	= 10;
p.A2    = 10;
p.rho   = 1000;
p.P_o	= 0;
p.g		= 9.81;
p.k1     = 0.5;
p.k2     = 0.5;

i.F_in  = 100;

Vss     = [453,453];

%States =   [ V1  V2]
%           [ 1   2 ]
% Algebraic Eq
F_out1 = @(S, i) p.k1*sqrt(p.rho*p.g*(S(1)/p.A2));
F_out2 = @(S, i) p.k2*sqrt(p.rho*p.g*(S(2)/p.A1));

% Differential
dSdt = @(S, i) [ (F_out1(S, i) - F_out2(S, i));
                    (i.F_in - F_out1(S, i)) ];
var=[0 0 0];
Vol1=[];
F_in=[];
for t = linspace(0,50);    
        if t>10;
            i.F_in = 110;
        end
        if var == [0 0 0]  ;                                        % if this is true, it means initial state must first be calculated, else, only dSdt is calculated
                s0 = [Vss]  ;                                       %steadystate initial values
                S = fsolve(@(S) dSdt(S, i), s0);
                var = [i.F_in S(1) S(2)];                           % Replaces zero vector with initial variables in METHOD
                V = var ;                                           % Assigns var to output of function
        else
                var(1) = i.F_in + L;                                % Apply LOAD
                i.F_in = var(1);
                S = [var(2), var(3)];                                       % Define vector S for next line
                a = dSdt(S,i);
                V = [L a(1) a(2)];                                  % this vector (var) is added to the var vector by the METHOD
        end
                Vol1 = [Vol1, V(1)];
                F_in = [F_in, i.F_in];
end        

    plot(t,Vol1,t,F_in)
    
end
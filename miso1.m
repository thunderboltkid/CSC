function V=miso1(L,var);               
p.A	    = 10;
p.rho   = 1000;
p.g		= 9.81;
p.Cv     = 0.5;

i.F_in  = 100;
i.C_in  = 0.1;
ss      = [100 , 0.1];

%States = [ Ca  V1  ]
%         [ 1   2   ]
% Algebraic Eq
F_out = @(S) p.Cv*sqrt(p.g*(S(1)/p.A2));
% Differential
dSdt = @(S, i) [ F_in - F_out(S,i);
                 (F_in*C_in - S(2)*F_out(S))/S(1)];

        if var == [0 0 0];                                        
                S = fsolve(@(S) dSdt(S, i), ss);
                V = [i.F_in S(1) S(2)];                             
        else
                var(3) = i.F_in + L;                                
                S = [var(1), var(2)];                                       
                a = dSdt(S,i);
                V = [a(1) a(2) L];                                  
        end
end
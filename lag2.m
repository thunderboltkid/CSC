function V=lag2(L,var);               %% INPUT variable always var(1) OUTPUT variable always var(2)
i.T1 = 80;
i.T2 = 50;
i.k1 = 0.0001;
i.k2 = 0.00001;
i.F = 1;

% Differential
dSdt = @(S, i) [ inv(i.T1)*i.F - (inv(i.T1)+i.k1)*S(1); 
                 inv(i.T2)*S(1)- (inv(i.T2)+i.k2)*S(2)];

                % [ in out other]

        if var == [0 0 0]  ;                                        % if this is true, it means initial state must first be calculated, else, only dSdt is calculated
                s0 = [10 20]  ;                                   % steadystate initial guess values
                S = fsolve(@(S) dSdt(S, i), s0);
                var = [i.F S(2) S(1)];                           % Replaces zero vector with initial variables in METHOD
                V = var;                                            % Assigns var to output of function
                
        else
                i.F = i.F + L;
                var(1) = i.F;                                    % Apply LOAD
                S = [var(3) var(2)];                                % Define vector S for next line
                
                A = dSdt(S, i);
                V = [L A(2) A(1)];                                  % this vector (var) is added to the var vector by the METHOD
        end
end
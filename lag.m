function V=lag(L,var);               %% INPUT variable always var(1) OUTPUT variable always var(2)
i.T = 10;
i.k = 0.81;
i.F = 10;

% Differential
dSdt = @(S, i) [ (1/i.T)*i.k*i.F - (1/i.T)*S(1)];

                % [ in out other]

        if var == [0 0 0]  ;                                        % if this is true, it means initial state must first be calculated, else, only dSdt is calculated
                s0 = [10]  ;                                   % steadystate initial guess values
                S = fsolve(@(S) dSdt(S, i), s0);
                var = [i.F S(1) 0];                           % Replaces zero vector with initial variables in METHOD
                V = var;                                            % Assigns var to output of function
                
        else
                i.F = i.F + L;
                var(1) = i.F;                                    % Apply LOAD
                S = [var(2)];                                % Define vector S for next line
                
                A = dSdt(S, i);
                V = [L A(1) 0];                                  % this vector (var) is added to the var vector by the METHOD
        end
end
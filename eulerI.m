function E = eulerI(steps,magn,deadT,LOAD,SYSTEMS,i,j,start,Ts); %#Euler se metode Labuschagne et al. "'n Inleiding tot Numeriese Analise" p 87
M = [0 0 0];
M_deadT = [];
for t = 1:Ts:steps;
    
    if t==1;
        var=[0 0 0];
    end
    L       = LOAD{j}(t,i,magn,start)  ;
    dS      = SYSTEMS{i}(L,var)  ;
    var(2)  =var(2) + dS(2);%% INPUT variable always var(1) OUTPUT variable always var(2)   V = [L A(2) A(1)]; 
    var(3)  =var(3) + dS(3);
    if t==1;
        inputvar_ss = dS(1);
        var(1) = inputvar_ss;
        M = [t (inputvar_ss+L) var(2)];
    else
        R = [t (inputvar_ss+L) var(2)];
        
        if t <= deadT*inv(Ts);
            if t>1;
                RdeadT = [t (inputvar_ss+L) 0];
            end
        elseif deadT>0;
            RdeadT = [t (inputvar_ss+L) M((t*inv(Ts)-(deadT*inv(Ts))),3)];
            M_deadT = [M_deadT;RdeadT];
        end
            M = [M;R];
        
    end
    
    
    
end
if deadT >0
    E = M_deadT;
else
    E = M;
end
end
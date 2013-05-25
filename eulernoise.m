function E = eulernoise(steps,magn,deadT,LOAD,SYSTEMS,i,j,start,Ts,noise); %#Euler se metode Labuschagne et al. "'n Inleiding tot Numeriese Analise" p 87
M = [0 0 0];
M_deadT = [];
for t = 1:Ts:steps;
a = 0.1*noise*sin(0.1*t)+noise*rand;   
    if t==1;
        var=[0 0 0];
    end
    L       = LOAD{j}(t,i,magn,start)  ;
    dS      = SYSTEMS{i}(L,var)  ;
    var(2)  =var(2) + dS(2); 
    var(3)  =var(3) + dS(3);
    if t==1;
        inputvar_ss = dS(1);
        var(1) = inputvar_ss;
        M = [t (inputvar_ss+L) var(2)+a];
        M_deadT = [t (inputvar_ss+L) a];
    else
        R = [t (inputvar_ss+L) var(2)+a];
        
        if t <= deadT*inv(Ts);
            if t>0;
                RdeadT = [t (inputvar_ss+L) a];
            end
        elseif deadT>0;
            RdeadT = [t (inputvar_ss+L) M((t*inv(Ts)-(deadT*inv(Ts))),3)];
        end
        M = [M;R];
        M_deadT = [M_deadT;RdeadT];
    end
end
if deadT >0
    E = M_deadT;
else
    E = M;
end
end
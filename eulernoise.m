function E = eulernoise(steps,magn,deadT,LOAD,SYSTEMS,i,j,start,Ts,noise); %#Euler se metode Labuschagne et al. "'n Inleiding tot Numeriese Analise" p 87
M = [0 0 0];
Ms =[0 0 0];
for t = 1:Ts:steps;
    a = 0.1*noise*sin(0.1*t)+noise*rand;
    
    if t==1;
        var=[0 0 0];
    end
    
    L       = LOAD{j}(t,i,magn,start)  ;
    dS      = SYSTEMS{i}(L,var)  ;
    var(2)  = var(2) + dS(2);
    var(3)  = var(3) + dS(3);
    
    if t==1;
        inputvar_ss = dS(1);
        var(1) = inputvar_ss;
        Ms     = [t (inputvar_ss+L) var(2)];
        M = Ms;
    else
        R = [t (inputvar_ss+L) var(2)];
        Ms = [Ms;R];
        
        if t>deadT
            Rd = [t (inputvar_ss+L) Ms((t*inv(Ts)-(deadT*inv(Ts))),3)+a];
        else
            Rd = [t (inputvar_ss+L) Ms(1,3)+a];
        end
        M(t,:)= Rd;
    end
end
E=M;
end
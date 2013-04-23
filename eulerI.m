function E = eulerI(steps,magn,LOAD,SYSTEMS,i,j,start,Ts); %#Euler se metode Labuschagne et al. "'n Inleiding tot Numeriese Analise" p 87
M = [0 0 0];
 for t = 1:Ts:steps;
    
     if t==1;
         var=[0 0 0];
     end
     L       = LOAD{j}(t,i,magn,start)  ;                  
     dS      = SYSTEMS{i}(L,var)  ;              
     var(2)  =var(2) + dS(2);%% INPUT variable always var(1) OUTPUT variable always var(2)
     var(3)  =var(3) + dS(3);
     if t==1;
         inputvar_ss = dS(1);   
         var(1) = inputvar_ss;
         M = [t (inputvar_ss+L) var(2)];
     else
         M = [M;[t (inputvar_ss+L) var(2)]];
     end
     
     
     
 end
 E = M;
 end
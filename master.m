
steps = 200;
start = 50;
Ts = 0.5;
tspan = 1:Ts:steps;
IDMETHOD = { @(data,orders) Arx(data,orders)}%leastsqmatrix(data,orders)}%@(data,orders,M) Arx(data,orders,M)};%, ;@(data,orders) TFest(data,orders),
order = 1:3;
deadT = 0;
METHOD   = {@(steps,magn,LOAD,SYSTEMS,i,j,start,Ts) eulerI(steps,magn,LOAD,SYSTEMS,i,j,start,Ts)};%  @(steps,magn,LOAD,SYSTEMS,i,j,Ts) eulerII(steps,magn,LOAD,SYSTEMS,i,j,Ts)}% @(steps,magn,LOAD,SYSTEMS,i,j) rungakutta(steps,magn,LOAD,SYSTEMS,i,j)};
LOAD     = {@(t,i,magn,start) pulse(t,i,magn,start)}% , @(t,i,magn,start) step(t,i,magn,start)};% @(t,i,magn,start) ramp(t,i,magn,start) 
SYSTEMS  = {@(L,var) lag1(L,var)}% @(L,var) lag2(L,var)   }% @(L,var)lag3(L,var)};            
magnE     = [20 10 100 10 10];                                                           % define a suitable input change for each of the systems
magnV     = [15 30 140 13 17]; 



                                                 
for i=1:length(SYSTEMS);                    %e.g. cstr
    for j=1:length(LOAD);                 %e.g. step
        for k=1:length(METHOD);             %e.g. Euler
            
            
                        % DATA PREPARATION
                        % ESTIMATION
               e = METHOD{k}(steps,magnE,LOAD,SYSTEMS,i,j,start,Ts);         
                        % REMOVE EQUILIBRIUM VALUES
                    % input
               e(:,2) = dev(e(:,2),start);
                    % output
               e(:,3) = dev(e(:,3),start);
               Store{i,j,k} = e;
                        % VALIDATION
               v = METHOD{k}(steps,magnE,LOAD,SYSTEMS,i,j,start,Ts);        %(floor(rand(length(LOAD)-1))+1)   
                        % REMOVE EQUILIBRIUM VALUES
                    % input
               v(:,2) = dev(v(:,2),start);
                    % output
               v(:,3) = dev(v(:,3),start);
                        % CREATE IDDATA OBJECTS
               Ts = 0.5;
               ze = iddata(e(:,3) , e(:,2) , Ts);       % Output, Input, Stepsize
               zv = iddata(v(:,3) , v(:,2) , Ts);       % Output, Input, Stepsize
                        % MODEL ORDER ESTIMATION
               NN1 = struc(order,order,deadT);         %% Struc creates a matrix of model-order combinations for a specified range of na, nb, and nk values
                            % ORDER SELECTION BASED ON RISSANEN MDL CRITERION  
               %[nn, vmod] = selstruc(arxstruc(ze(:,:,1),zv(:,:,1),NN1),'mdl');% 
                       
                            % ORDER SELECTION BASED ON AKAIKE AIC CRITERION    
               [nn, vmod] = selstruc(arxstruc(ze(:,:,1),zv(:,:,1),NN1),'aic')
               M = buildmatrix(ze,nn)
               
               
                        
                                                for l=1:length(IDMETHOD);
                                                    R = IDMETHOD{l}(ze,nn);
                                                    theta = [(-1)*R.a(2:end), R.b]'
                                                    predictplotvec = M*theta
                                                    result{i,j,k,l} = IDMETHOD{l}(ze,nn);
                                                    inputplotvec = ze.inputdata;             
                                                    outputplotvec= ze.outputdata;
                                                 end
    end
    end
  subplot(2,1,1)
  plot(tspan,ze.inputdata)
  subplot(2,1,2)
  plot(tspan,ze.outputdata,tspan,predictplotvec)
%   
  
  
%     for i=1:length(SYSTEMS);                    %e.g. cstr
%         for j=1:length(LOAD)-1;                 %e.g. step
%             for k=1:length(METHOD);             %e.g. Euler
%                 d = Store{1,1,1};
%                 subplot(1,2,1)
%                 plot(d(:,1),d(:,2))
%                 axis([0 steps+10 -5 30])
%                 subplot(1,2,2)
%                 plot(d(:,1),d(:,3))
%             end
%         end
%     end
end

% subplot(6,1,1)
% plot(e{1,1}(:,1),e{1,1}(:,2))
% subplot(6,1,2)
% plot(e{1,1}(:,1),e{1,1}(:,3))
% subplot(6,1,3)
% plot(e{1,2}(:,1),e{1,2}(:,2))
% subplot(6,1,4)
% plot(e{1,2}(:,1),e{1,2}(:,3))
% subplot(6,1,5)
% plot(e{1,3}(:,1),e{1,3}(:,2))
% subplot(6,1,6)
% plot(e{1,3}(:,1),e{1,3}(:,3))
% 
% subplot(6,1,1)
% plot(e{2,1}(:,1),e{2,1}(:,2))
% subplot(6,1,2)
% plot(e{2,1}(:,1),e{2,1}(:,3))
% subplot(6,1,3)
% plot(e{2,2}(:,1),e{2,2}(:,2))
% subplot(6,1,4)
% plot(e{2,2}(:,1),e{2,2}(:,3))
% subplot(6,1,5)
% plot(e{2,3}(:,1),e{2,3}(:,2))
% subplot(6,1,6)
% plot(e{2,3}(:,1),e{2,3}(:,3))

% subplot(6,1,1)
% plot(m{1,1}(:,1),m{1,1}(:,2))
% subplot(6,1,2)
% plot(m{1,1}(:,1),m{1,1}(:,3))
% subplot(6,1,3)
% plot(m{1,2}(:,1),m{1,2}(:,2))
% subplot(6,1,4)
% plot(m{1,2}(:,1),m{1,2}(:,3))
% subplot(6,1,5)
% plot(m{1,3}(:,1),m{1,3}(:,2))
% subplot(6,1,6)
% plot(m{1,3}(:,1),m{1,3}(:,3))
% 
% subplot(6,1,1)
% plot(m{2,1}(:,1),m{2,1}(:,2))
% subplot(6,1,2)
% plot(m{2,1}(:,1),m{2,1}(:,3))
% subplot(6,1,3)
% plot(m{2,2}(:,1),m{2,2}(:,2))
% subplot(6,1,4)
% plot(m{2,2}(:,1),m{2,2}(:,3))
% subplot(6,1,5)
% plot(m{2,3}(:,1),m{2,3}(:,2))
% subplot(6,1,6)
% plot(m{2,3}(:,1),m{2,3}(:,3))

 
 
        
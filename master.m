
steps = 200;    start = 50;     Ts = 0.5;       tspan = 1:Ts:steps;     order = 1:15;       deadT = 0;
NN1 = struc(order,order,deadT) % Struc creates a matrix of model-order combinations for a specified range of na, nb, and nk values
IDMETHOD = {@(data,orders) Arx(data,orders),@(data,orders) Iv4(data,orders), @(data,orders) leastsqmatrix(data,orders)};% @(data,orders) TFest(data,orders)};%@(data,orders,M) Arx(data,orders,M)};%, ;@(data,orders) TFest(data,orders),
METHOD_E   = {@(steps,magn,deadT,LOAD,SYSTEMS,i,j,start,Ts,noise) eulernoise(steps,magn,deadT,LOAD,SYSTEMS,i,j,start,Ts,noise)};
METHOD   = {@(steps,magn,deadT,LOAD,SYSTEMS,i,j,start,Ts) eulerI(steps,magn,deadT,LOAD,SYSTEMS,i,j,start,Ts)};
IDLOAD     = {@(t,i,magn,start) stepnoise(t,i,magn,start), @(t,i,magn,start) pulsenoise(t,i,magn,start), @(t,i,magn,start) rampnoise(t,i,magn,start)}; 
TESTLOAD   = {@(t,i,magn,start) step(t,i,magn,start), @(t,i,magn,start) pulse(t,i,magn,start), @(t,i,magn,start) ramp(t,i,magn,start)};
SYSTEMS  = {@(L,var) lag1(L,var), @(L,var) lag2(L,var)};                 % @(L,var)lag3(L,var)};            
magnE    = [1 1 1 1 1]; magnV = [1 1 1 1 1];          % define a suitable input change for each of the systems
N = 0;
% HTML Iv4
fid = fopen('results.html','w');fprintf(fid, ['<table align="center"><tr><td width="60"></td><td width="60"></td><td width="60"></td></tr>']);
for noise = 0:0.1:0.5;
    N = N + 1;
for i=1:length(SYSTEMS);                    %   e.g. cstr
    for j=1:length(LOAD);                   %   e.g. step
        for k=1:length(METHOD_E);             %   e.g. Euler
            % ESTIMATION
            e = METHOD_E{k}(steps,magnE,deadT,LOAD,SYSTEMS,i,j,start,Ts,noise);
            e(:,2) = dev(e(:,2),start); e(:,3) = dev(e(:,3),start     );                                    % REMOVE EQUILIBRIUM VALUES input,% output
            O = length(e(:,2))
            % CREATE IDDATA OBJECTS
            ze = iddata(e(:,3) , e(:,2) , Ts);       % Output, Input, Stepsize
            % MODEL ORDER ESTIMATION
            % ORDER SELECTION BASED ON RISSANEN MDL CRITERION
            %[nn, vmod] = selstruc(arxstruc(ze(:,:,1),zv(:,:,1),NN1),'mdl');%
            % ORDER SELECTION BASED ON AKAIKE AIC CRITERION
            [nn, vmod] = selstruc(arxstruc(ze(:,:,1),ze(:,:,1),NN1),'aic'); % arxstruc(ze,zv,n) The data sets ze and zv need not be of equal size. ( from ARXstruc help )
            % They could, however, be the same sets, in which case the computation is faster.
            %M = buildmatrix(ze,nn);
            P = length(tspan)            
            Q=length(ze.inputdata)
                        f = figure();
                        subplot(1,2,1);
                        plot(tspan,ze.inputdata);
                        axis([0 steps+50 -0.5 (magnE(i)*1.5)]);
                        subplot(1,2,2);
                        plot(tspan,ze.outputdata);
                        saveas(f, strcat('IDgraph',num2str(i),num2str(j),num2str(l),num2str(m),num2str(N),'.png'));
                        close
            
                        %write to HTML
                        fid = fopen('results.html','a')
                        fprintf(fid, ['<tr><td>ID by using System :',num2str(i),'</td>']);
                        fprintf(fid, ['<td> Using Load :',num2str(j),'</td>']);
                        fprintf(fid, ['<td>Noise Level:',num2str(noise),' </td></tr>']);
                        fprintf(fid, ['<tr><td></td><td></td><td><img src="',strcat('IDgraph',num2str(i),num2str(j),num2str(l),num2str(m),num2str(N),'.png'),'" width="800" height="400"></td></tr>']);
                        fclose(fid);
                %IDENTIFY
            for l=1:length(IDMETHOD);
                    R = IDMETHOD{l}(ze,nn);
                    THETA = [(-1)*R.a(2:end), R.b]';
                    %   prediction = M*THETA;
                    for m = 1:length(TESTLOAD);
                        v =  METHOD{k}(steps,magnV,deadT,TESTLOAD,SYSTEMS,i,m,start,Ts);
                        v(:,2) = dev(v(:,2),start); v(:,3) = dev(v(:,3),start);                                                  % create validation data set and plot
                        zv = iddata(v(:,3) , v(:,2) , Ts);       % Output, Input, Stepsize                                                    % true response
                        Mv = buildmatrix(zv,nn);
                        %plot & save
                        f = figure();
                        subplot(1,2,1);
                        plot(tspan,zv.inputdata);
                        axis([0 steps+50 -0.5 (magnV(i)*1.5)]);
                        subplot(1,2,2);
                        plot(tspan,zv.outputdata,tspan,Mv*THETA);
                        saveas(f, strcat('graph',num2str(i),num2str(j),num2str(l),num2str(m),num2str(N),'.png'));
                        close
                        %write to HTML
                        fid = fopen('results.html','a')
                        fprintf(fid, ['<tr><td>System :',num2str(i),'</td>']);
                        fprintf(fid, ['<td>Load :',num2str(m),'</td>']);
                        fprintf(fid, ['<td>ID Method :',num2str(l),'</td></tr>']);
                        fprintf(fid, ['<tr><td></td><td></td><td><img src="',strcat('graph',num2str(i),num2str(j),num2str(l),num2str(m),num2str(N),'.png'),'" width="800" height="400"></td></tr>']);
                        fclose(fid);
                    end
                
                
                
                
                
                
                
                
                
                
            end
        end
    end
end
end


 
 
        

steps = 500;    start = 50;     Ts = 0.5;       tspan = 1:Ts:steps;     order = 1:15;       deadT = 0;
NN1 = struc(order,order,deadT);         %% Struc creates a matrix of model-order combinations for a specified range of na, nb, and nk values
IDMETHOD = {@(data,orders) Iv4(data,orders),@(data,orders) Arx(data,orders)};%, @(data,orders) statespace(data,orders),};% @(data,orders) TFest(data,orders)};%@(data,orders,M) Arx(data,orders,M)};%, ;@(data,orders) TFest(data,orders),
METHOD   = {@(steps,magn,deadT,LOAD,SYSTEMS,i,j,start,Ts) eulerI(steps,magn,deadT,LOAD,SYSTEMS,i,j,start,Ts)};
LOAD     = {@(t,i,magn,start) step(t,i,magn,start), @(t,i,magn,start) pulse(t,i,magn,start), @(t,i,magn,start) ramp(t,i,magn,start)}; 
SYSTEMS  = {@(L,var) lag1(L,var), @(L,var) lag2(L,var)};                 % @(L,var)lag3(L,var)};            
magnE    = [10 10 100 10 10]; magnV = [20 20 150 20 20];          % define a suitable input change for each of the systems

% HTML
fid = fopen('results.html','w');fprintf(fid, ['<table align="center"><tr><td width="60"></td><td width="60"></td><td width="60"></td></tr>']);
                                                 
for i=1:length(SYSTEMS);                    %   e.g. cstr
    for j=1:length(LOAD);                   %   e.g. step
        for k=1:length(METHOD);             %   e.g. Euler
            % ESTIMATION
            e = METHOD{k}(steps,magnE,deadT,LOAD,SYSTEMS,i,j,start,Ts);
            e(:,2) = dev(e(:,2),start); e(:,3) = dev(e(:,3),start);                                    % REMOVE EQUILIBRIUM VALUES input,% output
            % VALIDATION
            v = METHOD{k}(steps,magnE,deadT,LOAD,SYSTEMS,i,j,start,Ts);
            v(:,2) = dev(v(:,2),start); v(:,3) = dev(v(:,3),start);                                    % REMOVE EQUILIBRIUM VALUES % input , output
            % CREATE IDDATA OBJECTS
            ze = iddata(e(:,3) , e(:,2) , Ts);       % Output, Input, Stepsize
            
            % MODEL ORDER ESTIMATION
            % ORDER SELECTION BASED ON RISSANEN MDL CRITERION
            %[nn, vmod] = selstruc(arxstruc(ze(:,:,1),zv(:,:,1),NN1),'mdl');%
            % ORDER SELECTION BASED ON AKAIKE AIC CRITERION
            [nn, vmod] = selstruc(arxstruc(ze(:,:,1),ze(:,:,1),NN1),'aic'); % The data sets ze and zv need not be of equal size. ( from ARXstruc help )
            % They could, however, be the same sets, in which case the computation is faster.
            M = buildmatrix(ze,nn);
            
            %identify
            for l=1:length(IDMETHOD);
                R = IDMETHOD{l}(ze,nn);
                theta = [(-1)*R.a(2:end), R.b]';
                pred = M*theta;
                %result{i,j,k,l} = IDMETHOD{l}(ze,nn);
                %                 inputplotvec = ze.inputdata;
                %                 outputplotvec= ze.outputdata;
                % For each type of input, how well does the theta identified by the method above combined with that input predict the output?
                
                for m = 1:length(LOAD);
                    v =  METHOD{k}(steps,magnV,deadT,LOAD,SYSTEMS,i,m,start,Ts);
                    v(:,2) = dev(e(:,2),start); v(:,3) = dev(v(:,3),start);                                                  % create validation data set and plot
                    zv = iddata(v(:,3) , v(:,2) , Ts);       % Output, Input, Stepsize                                                    % true response
                    Mv = buildmatrix(zv,nn);
                    %plot & save
                    f = figure();
%                     subplot(2,2,1);
%                     plot(tspan,ze.inputdata);
%                     axis([0 steps+10 -5 (magnE(i)+10)]);
%                     subplot(2,2,2);
%                     plot(tspan,ze.outputdata,tspan,pred);
                    subplot(1,2,1);
                    plot(tspan,zv.inputdata);
                    axis([0 steps+10 -5 (magnE(i)+10)]);
                    subplot(1,2,2);
                    plot(tspan,zv.outputdata,tspan,Mv*theta);
                    %axis([0 steps+10 -5 (magnE(i)+10)]);
                    saveas(f, strcat('graph',num2str(i),num2str(j),num2str(l),num2str(m),'.png'));
                    %write to HTML
                    fid = fopen('results.html','a')
                    fprintf(fid, ['<tr><td>System :',num2str(i),'</td>']);
                    fprintf(fid, ['<td>Load :',num2str(j),'</td>']);
                    fprintf(fid, ['<td>ID Method :',num2str(l),'</td></tr>']);
                    fprintf(fid, ['<tr><td></td><td></td><td><img src="',strcat('graph',num2str(i),num2str(j),num2str(l),num2str(m),'.png'),'" width="800" height="400"></td></tr>']);
                    fclose(fid);
                end
                
                
                
                
                
                
                
                
                
                
            end
        end
    end
end



 
 
        
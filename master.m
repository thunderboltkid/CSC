clear all
steps = 800;  start = 150;     Ts = 1;       tspan = 1:Ts:steps;     order = 1:15;       deadT = 20;  nmax = 0.8;
NN1 = struc(order,order,(0:deadT)); % Struc creates a matrix of model-order combinations for a specified range of na, nb, and nk values
IDMETHOD = {@(data,orders) Armax(data,orders)};%,@(data,orders) Iv4(data,orders), @(data,orders) Armax(data,orders)};% @(data,orders) TFest(data,orders)};%@(data,orders,M) Arx(data,orders,M)};%, ;@(data,orders) TFest(data,orders),
METHOD_E   = {@(steps,magn,deadT,LOAD,SYSTEMS,i,j,start,Ts,noise) eulernoise(steps,magn,deadT,LOAD,SYSTEMS,i,j,start,Ts,noise)};
METHOD   = {@(steps,magn,deadT,LOAD,SYSTEMS,i,j,start,Ts) euler(steps,magn,deadT,LOAD,SYSTEMS,i,j,start,Ts)};
LOAD     = {@(t,i,magn,start) step(t,i,magn,start), @(t,i,magn,start) ramp(t,i,magn,start), @(t,i,magn,start) pulse(t,i,magn,start)}; 
%TESTLOAD   = {@(t,i,magn,start) step(t,i,magn,start)};%, @(t,i,magn,start) pulse(t,i,magn,start), @(t,i,magn,start) ramp(t,i,magn,start)};
SYSTEMS  = {@(L,var) lag2(L,var)};%, @(L,var) lag2(L,var)};                 % @(L,var)lag3(L,var)};            
magnE    = [1 1 1 1 1]; magnV = [1 1 1 1 1];          % define a suitable input change for each of the systems
N = 0;
% HTML Iv4
%fid = fopen('results.html','w');fprintf(fid, ['<table align="center"><tr><td width="60"></td><td width="60"></td><td width="60"></td></tr>']);
Ematrix = zeros(length(LOAD),deadT);
% for X = 1:10;
LN = zeros(length(LOAD),deadT);
for deadT = 1:deadT
noise = 0.3;%for noise = 0.1:0.1:nmax;
    N = N + 1;
for i=1:length(SYSTEMS);                    %   e.g. cstr
    for j=1:1:length(LOAD);                   %   e.g. step
        for k=1:length(METHOD_E);             %   e.g. Euler
            % ESTIMATION
            e = METHOD_E{k}(steps,magnE,deadT,LOAD,SYSTEMS,i,j,start,Ts,noise);
            e(:,2) = dev(e(:,2),start); e(:,3) = devd(e(:,3),start,deadT)      ;                              
            % CREATE IDDATA OBJECTS
            ze = iddata(e(:,3) , e(:,2) , Ts);       % Output, Input, Stepsize
            % MODEL ORDER ESTIMATION
            % ORDER SELECTION BASED ON RISSANEN MDL CRITERION
            %[nn, vmod] = selstruc(arxstruc(ze(:,:,1),zv(:,:,1),NN1),'mdl');%
            % ORDER SELECTION BASED ON AKAIKE AIC CRITERION
            [nn, vmod] = selstruc(arxstruc(ze(:,:,1),ze(:,:,1),NN1),'aic'); % arxstruc(ze,zv,n) The data sets ze and zv need not be of equal size. ( from ARXstruc help )
            % They could, however, be the same sets, in which case the computation is faster.
            M = buildVmatrix(ze,nn);
                           
            
%                         f = figure();
%                         subplot(1,2,1);
%                         plot(tspan,ze.inputdata);
%                         axis([0 steps+50 -0.5 (magnE(i)*1.5)]);
%                         subplot(1,2,2);
%                         plot(tspan,ze.outputdata);
%                         %saveas(f, strcat('IDgraph',num2str(i),num2str(j),num2str(N),'.png'));
%                         close
%             
%                         %write to HTML
%                         fid = fopen('results.html','a')
%                         fprintf(fid, ['<tr><td>ID by using System :',num2str(i),'</td>']);
%                         fprintf(fid, ['<td> Using Load :',num2str(j),'</td>']);
%                         fprintf(fid, ['<td>Noise Level:',num2str(noise),' </td></tr>']);
%                         fprintf(fid, ['<tr><td></td><td></td><td><img src="',strcat('IDgraph',num2str(i),num2str(j),num2str(N),'.png'),'" width="800" height="400"></td></tr>']);
%                         fclose(fid);
                %IDENTIFY
            for l=1:length(IDMETHOD);
                    R = IDMETHOD{l}(ze,nn);
                    THETA = [(-1)*R.a(2:end), R.b]';
                    
                    for m = 1:length(LOAD);
                        v =  METHOD{k}(steps,magnV,deadT,LOAD,SYSTEMS,i,m,start,Ts);
                        v(:,2) = dev(v(:,2),start); 
                        v(:,3) = devd(v(:,3),start,deadT);
                        zv = iddata(v(:,3) , v(:,2) , Ts);      
                        Mv = buildVmatrix(zv,nn);
                        Pred = Mv*THETA;
                        % Quantify Errors
                        
%                                         E = 0;
%                                         for q = 1:steps;
%                                             err = abs(zv.outputdata(q) - Pred(q))/zv.outputdata(q);
%                                             E = E+err;
%                                         end
%                                         Efactor = (E/steps)*100;
                        EF = Efactor(steps,zv.outputdata,Pred);
                        w = floor(deadT);
                        LN(j,w) = EF;
                        %plot & save
%                         figure (1);
%                         hFig = figure(1);
%                         set(hFig, 'Position', [0 0 900 400]);
%                         subplot(1,3,1);
%                         plot(tspan,zv.inputdata);
%                         axis([0 steps+50 -0.5 (magnV(i)*1.5)]);
%                         subplot(1,3,2);
%                         plot(tspan,zv.outputdata);
%                         axis([0 steps+50 -0.5 (magnV(i)*1.5)]);
%                         subplot(1,3,3);
%                         plot(tspan,Mv*THETA);
%                         axis([0 steps+50 -0.5 (magnV(i)*1.5)]);
%                         saveas(f, strcat('graph',num2str(i),num2str(j),num2str(l),num2str(m),num2str(N),'.png'));
%                         close
                        %write to HTML
%                         fid = fopen('results.html','a');
%                         fprintf(fid, ['<tr><td>System :',num2str(i),'</td>']);
%                         fprintf(fid, ['<td>Load :',num2str(m),'</td>']);
%                         fprintf(fid, ['<td>ID Method :',num2str(l),'</td></tr>']);
%                         fprintf(fid, ['<tr><td></td><td>Error factor:''</td><td><img src="',strcat('graph',num2str(i),num2str(j),num2str(l),num2str(m),num2str(N),'.png'),'" width="1000" height="400"></td></tr>']);
%                         fclose(fid);


% LOAD by NOISE matrix


                    end
          
            end
        end
    end
end
%end
 Ematrix = Ematrix + LN;
 end
 
 
        
function D = Ivx(data,orders)

        % DATA PREPARATION
%             InputPoles = orders(1);
%             OutputPoles= orders(2);
%             Deadtime   = orders(3);
%          
% D = ivx(data,'na',InputPoles,'nb',OutputPoles,'nk',Deadtime)
%D = bj(data,[InputPoles,OutputPoles,Deadtime]);
D = ivx(data,orders)
end
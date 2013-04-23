function D = Arx(data,orders)

         % DATA PREPARATION
            InputPoles = orders(1);
            OutputPoles= orders(2);
            Deadtime   = orders(3);
         
D = arx(data,'na',InputPoles,'nb',OutputPoles,'nk',Deadtime)

%D1 = [d.a]
end
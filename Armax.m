function D = Armax(data,orders)

         % DATA PREPARATION
            InputPoles = orders(1);
            OutputPoles= orders(2);
            Deadtime   = orders(3);
         
D = armax(data,'na',InputPoles,'nb',OutputPoles,'nk',Deadtime)
end
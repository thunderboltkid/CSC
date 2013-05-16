function D = TFest(data,orders)
        % DATA PREPARATION
        np = [orders(1)];
%         nz = [orders(2)];
%         iodelay = [orders(3)];
%        
       D = tfest(data,np)%,nz,iodelay);
       
end
function D = TFest(data,orders)
       % DATA PREPARATION
       np = [orders(1)];

       
       D = tfest(data,np)
       
end
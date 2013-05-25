function F = devd(a,start,deadT)

x = a((deadT+1):size(a));
x = x - ones(size(x),1) * mean(x(1:(start-1-deadT)));
F = [zeros(deadT,1);x];
end
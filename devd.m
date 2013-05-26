function F = devd(a,start,deadT)
x = a((deadT+1):size(a));
X = x - ones(length(x),1) * mean(x(1:(start-1-deadT)));
y = a(1:deadT);
y = y - ones(length(y),1) * mean(x(1:(start-1-deadT)));
F = [y;X];
end
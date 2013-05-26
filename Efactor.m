function EF = Efactor(steps,outputdata,Pred)
E = 0;
for q = 1:steps;
    err = abs(outputdata(q) - Pred(q))/outputdata(q);
    E = E+err;
end
EF = (E/steps)*100;
end
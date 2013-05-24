function L = pulsenoise(t,i,magn,start);
    period = 1;
    if t >= start;
        if t <= start+period;
        L = magn(i)+0.1*sin(0.1*t)+0.5*rand;
        else
        L = 0.1*sin(0.1*t)+0.5*rand;
        end
    else
        L = 0.1*sin(0.1*t)+0.5*rand;
    end
  end
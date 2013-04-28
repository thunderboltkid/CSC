function L = pulse(t,i,magn,start);
    period = 1;
    if t >= start;
        if t <= start+period;
        L = magn(i);
        else
        L = 0;
        end
    else
        L = 0;
    end
  end
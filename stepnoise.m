 function L = stepnoise(t,i,magn,start);
      if t >= start;
        L = magn(i)+0.1*sin(0.1*t)+0.5*rand;
    else
        L = 0.1*sin(0.1*t)+0.5*rand;
    end
  end
 function L = step(t,i,magn,start);
      if t >= start;
        L = magn(i);
    else
        L = 0;
    end
  end

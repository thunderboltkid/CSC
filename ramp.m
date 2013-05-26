 function L = ramp(t,i,magn,start)
  period = 50;
      if t > start;
              if t < start+period;
                  L = magn(i)*((t-start)/period);
              elseif t >= start+period;
                  L = magn(i);
              end
      else
          L = 0;
      end   
  end
 
 function L = rampnoise(t,i,magn,start)
  period = 20;
      if t > start;
              if t < start+period;
                  L = (magn(i)*((t-start)/period))+0.1*sin(0.1*t)+0.5*rand;
              elseif t >= start+period;
                  L = magn(i)+0.1*sin(0.1*t)+0.5*rand;
              end
      else
          L = 0.1*sin(0.1*t)+0.5*rand;
      end   
  end
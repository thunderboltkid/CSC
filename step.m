 function L = step(t,i,magn,start);
      if t >= start;
        L = magn(i);
    else
        L = 0;
    end
  end
%  
%   function L = ramp(t,i,magn);
%   period = 10;
%   if t > 10
%       if t < 10+period;
%           L = magn(i)*((t-10)/period);
%       end
%   else
%       L = 0;
%   end
%  end

%  function L = pulse(t,i,magn);
%   period = 1;
%     if t > 10;
%         if t < 10+period;
%         L = magn(i);
%         end
%     else
%         L = 0;
%     end
%   end
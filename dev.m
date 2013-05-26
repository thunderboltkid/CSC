function F = dev(a,start)

F = a - ones(length(a),1) * mean(a(1:(start-1)));

end
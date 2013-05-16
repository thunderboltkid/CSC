function L = leastsqmatrix(ze,nn);
M = buildmatrix(ze,nn);
y = ze.outputdata;
Theta = M\y;
A = [1,(-1)*Theta(1:nn(1))'];
B = [Theta((1+nn(1)):(nn(1)+nn(2)))'];
L = idpoly(A,B);
end




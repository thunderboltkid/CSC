function M = buildVmatrix(ze,nn);

X(:,2) = ze.inputdata;
X(:,1) = ze.outputdata;
y = ze.outputdata;
Dx = nn(1);                     % estimated orders in x and m (input and output) Luyben 526
Dm = nn(2);
Dd = nn(3);
tspan = 1:length(ze.inputdata);

M = [];

for i = 1:length(X(:,1));
    rx = [];                    % rows of output variables
    rm = [];                    % and input variables
    for j = 0:(Dx-1);
        if (i-j)>0;
            rx = [rx X(i-j,1)];
        elseif (i-j)<=0;
            rx = [rx 0];        % fill up rows with 0s
        end
    end
    for j = 0:(Dm+Dd-1);
        if (i-j)>0;
            rm = [rm X(i-j,2)];
        elseif (i-j)<=0;
            rm = [rm 0];
        end
    end
    R = [rx rm];                        % combine in- and outputs into rows
    M = [M ; R];                        % concatenate into matrix
    
end
%M = [ones(size(M(:,1))),M]

end
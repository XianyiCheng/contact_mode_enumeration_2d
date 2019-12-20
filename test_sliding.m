
P{1} = [0,1;1,0.5;1,-0.5;-1,0]';
N{1} = [0,-1;-1,0;-1,0;1,0]';

P{2} = [-1,0]';
N{2} = [1,0]';

P{3} = [-1,1;-1,0;0,-1;1,-1]';
N{3} = [1,0;1,0;0,1;0,1]';

P{4} = [1,0;0,1;-1,0;0,-1]';
N{4} = [-1,0;0,-1;1,0;0,1]';

P{5} = [0,1;-1,0]';
N{5} = [0,-1;1,0]';
%%
k = 4;
Pe = P{k}; Ne = N{k};
M = contact_mode_enumeration(Pe,Ne);
fprintf('Total numer of modes: %d.\n', size(M,2));
for i = 1:size(M,2)
    m = M(:,i);
    c = repmat('s',numel(m),1);
    c(m==1) = 'f';
    c(m==2) = 'r';
    c(m==3) = 'l';
    fprintf(c);
    fprintf('\n');
end
    
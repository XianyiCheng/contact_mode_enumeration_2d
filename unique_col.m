function [U] = unique_col(xs)

tol = 1e-6;
xs = xs(:,~all(abs(xs)<tol,1));
xs = xs./vecnorm(xs,1);

nx = size(xs,2);
U = zeros(size(xs,1),1);
for i = 1:nx
    xs_i = xs(:,i);
    if all(vecnorm(U - xs_i)>tol) && ~all(xs_i==0)
        U = [U, xs_i];
    end
end
U(:,1)=[];
end


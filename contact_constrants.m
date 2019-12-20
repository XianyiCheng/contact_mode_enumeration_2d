function A = contact_constrants(P, N)
% in 2d
% P:contact points
% N: directions that must be positve
% G: grasp map
Num_c = size(P,2);
G = [];
for i = 1:Num_c
    p = P(:,i);
    n = N(:,i);
    g = [[n(2);-n(1)],n,p;0,0,1];
    inv_g = [g(1:2,1:2)', -g(1:2,1:2)'*p;0,0,1];
    ad_invg = [inv_g(1:2,1:2),[inv_g(2,3);-inv_g(1,3)];0,0,1];
    G = [G,ad_invg'*[0,1,0]'];
end
A = G';

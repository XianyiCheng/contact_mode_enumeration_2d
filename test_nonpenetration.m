addpath('../cone_functions')
addpath('../tform_functions')
addpath('../utils')

%%
Pe = [0,1;1,0.5;1,-0.5;-1,0]';
Ne = [0,-1;-1,0;-1,0;1,0]';
A = contact_constrants(Pe, Ne);
[V, E, F, edge_modes, face_modes, region_modes,~] = non_penetration(A)
%%
Pe = [-1,0;1,0]';
Ne = [1,0;-1,0]';
A = contact_constrants(Pe, Ne);

[V, E, F, edge_modes, face_modes, region_modes,~] = non_penetration(A)

%%
Pe = [-1,0]';
Ne = [1,0]';
A = contact_constrants(Pe, Ne);
[V, E, F, edge_modes, face_modes, region_modes,~] = non_penetration(A)
%%
Pe = [-1,0;0,1]';
Ne = [1,0;0,-1]';
A = contact_constrants(Pe, Ne);
[V, E, F, edge_modes, face_modes, region_modes,~] = non_penetration(A)
%% matt's book p206
Pe = [-1,1;-1,0;0,-1;1,-1]';
Ne = [1,0;1,0;0,1;0,1]';
A = contact_constrants(Pe, Ne);
[V, E, F, edge_modes, face_modes, region_modes,~] = non_penetration(A)
function [V, E, F, edge_modes, face_modes, region_modes, face_support] = non_penetration(A)
% for now we only consider the 2D case
% A = [a1;a2;...;an] for n contacts. ai: contact screw
% from the physics of contacts: ai != all zeros; ai != aj; ai != -aj;
% 0: inactive, 1:active
% 
% return: in cols
% V: the span of non-penetration cone
% E: the edges/intersections of faces of non-penetration cone
% F: the faces of non-penetration cone
% edge_modes; face_modes; region_modes
tol = 1e-6;
num_c = size(A,1);
d = rank(A); % d != 0
if d == 1 % 
    if num_c == 1
        ns = null(A);
        V = [A',ns,-ns];
        E = [];
        F = A';
        edge_modes = [];
        face_modes = 1;
        region_modes = 0;
        face_support = logical(ones(size(V,2),1));
        return
    else
        ns = null(A);
        V = [ns,-ns];
    end
        
else
    V = [];
    ind = nchoosek(1:num_c,d-1);
    for i = 1:size(ind,1)
        Ai = A(ind(i,:),:);
        if rank(Ai) == d-1
            ns_i = null(Ai);
            w = [ns_i, -ns_i];
            x = w(:,all(A*w>=-tol,1));
            if ~isempty(x)
                V = [V,x];
            end
        end
    end
    V = unique_col(V);
end
S = abs(A*V)<tol;
E = V(:,sum(S,1)>1);
edge_modes = S(:,sum(S,1)>1);
Se = abs(A*E)<tol;
face_ind = sum(Se,2)>=2;
if sum(face_ind)>0 && rank(V)>1
    F = A(face_ind,:)';
    face_modes = zeros(num_c,sum(face_ind));
    face_support = zeros(size(V,2),sum(face_ind));
    region_modes = ones(num_c,1);
    for k = 1:sum(face_ind)
        support_ind = abs(F(:,k)'*V)<tol;%Se(face_ind(k),:);
        face_support(:,k) = support_ind';
        em = S(:,support_ind);
        face_modes(:,k) = all(em,2);
        region_modes = region_modes&face_modes(:,k);
    end
else
    region_modes = [];
    face_modes = [];
    F = [];
    face_support = [];
end
 
end
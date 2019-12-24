% Enumerate contact modes for a 2D rigid bodd
% not specify sliding directions
% contact mode: 0:separation 1:fixed 2: sliding
%
% Sliding direction is defined as the velocity of the object about the contact
% point, measured when facing the object (positive normal direction).
%
% @param      P      2xn matrix, coordinates of the n contact points. P =
%                    [p1,p2,p3,...]
% @param      N      2xn matrix, the n contact normals (point to the object). N
%                    = [n1,n2,n3,...]
% @param      print  If true, print the list of modes.
%
% @return     contact_modes: 2 x k matrix, the k possible contact modes.
%
function contact_modes = contact_mode_enumeration_nsd(P, N, print)

D = [N(2,:);-N(1,:)];
A = contact_constrants(P, N); % A: contact non-penetration constraints A*v >=0
T = contact_constrants(P, D); % T: contact sliding contraints, T = [t1;t2;...;tn]

tol = 1e-6;
[V, E, F, edge_modes, face_modes, region_modes, face_support] = non_penetration(A);
edge_modes = int8(edge_modes);
face_modes = int8(face_modes);
region_modes = int8(region_modes);
num_c = size(A,1);
face_sliding_modes = [];

for i = 1:size(T,1)
    t = T(i,:);
    if ~isempty(E)
        active_edges_ind = edge_modes(i,:)==1;
        active_edges = E(:,active_edges_ind);
        sliding_mode = edge_modes(:,active_edges_ind);
        sliding_mode(i,abs(t*active_edges) > tol) = 2;
        edge_modes(:,active_edges_ind) = sliding_mode;
    end
    if ~isempty(F)
        active_face_ind = face_modes(i,:)==1;
        slide_modes = face_modes(:,active_face_ind);
        face_vector_inds = logical(face_support(:,active_face_ind));
        for k = 1:sum(active_face_ind)
            slide_mode = slide_modes(:,k);
            face_vectors = V(:,face_vector_inds(:,k)');
            p = t*face_vectors;
            if all(p>tol)||all(p<-tol)
                slide_mode(i) = 2;
                face_sliding_modes = [face_sliding_modes,slide_mode];
            elseif all(abs(p)<=tol)
                face_sliding_modes = [face_sliding_modes,slide_mode];
            else
                face_sliding_modes = [face_sliding_modes,slide_mode];
                slide_mode(i) = 2;
                face_sliding_modes = [face_sliding_modes,slide_mode];
            end
        end
    end
end

contact_modes = [region_modes,edge_modes,face_sliding_modes];
contact_modes = [zeros(num_c,1),contact_modes];
contact_modes = unique(contact_modes','rows')';

if nargin > 2 && print == true
    fprintf('Total numer of modes: %d.\n', size(contact_modes,2));
    for i = 1:size(contact_modes,2)
        m = contact_modes(:,i);
        c = repmat('s',numel(m),1); % separation
        c(m==1) = 'f'; % fixed
        c(m==2) = 'l'; % sliding
        fprintf(c);
        fprintf('\n');
    end
end
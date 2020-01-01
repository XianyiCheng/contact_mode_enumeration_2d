% Enumerate contact modes for a 2D rigid body.
%
% contact mode: 0:separation 1:fixed 2: right sliding 3: left sliding
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
function contact_modes = contact_mode_enumeration(P, N, print)

D = [N(2,:);-N(1,:)];
A = contact_constrants(P, N); % A: contact non-penetration constraints A*v >=0
T = contact_constrants(P, D); % T: contact sliding contraints, T = [t1;t2;...;tn]

tol = 1e-6;
[V, E, F, edge_modes, face_modes, region_modes, face_support] = non_penetration(A);
edge_modes = int8(edge_modes);
face_modes = int8(face_modes);
region_modes = int8(region_modes);
num_c = size(A,1);
edges_sliding = [];
edge_sliding_modes = [];
face_sliding_modes = [];
face_sliding_vectors = [];
face_sliding_normals = [];

for i = 1:size(T,1)
    t = T(i,:);
    if ~isempty(E)
        active_edges_ind = edge_modes(i,:)==1;
        active_edges = E(:,active_edges_ind);
        sliding_mode = edge_modes(:,active_edges_ind);
        sliding_mode(i,t*active_edges > tol) = 2;
        sliding_mode(i,t*active_edges < -tol) = 3;
        edge_modes(:,active_edges_ind) = sliding_mode;
    end
    if ~isempty(F)
        active_face_ind = face_modes(i,:)==1;
        slide_modes = face_modes(:,active_face_ind);
        face_vector_inds = logical(face_support(:,active_face_ind));
        face_normals = F(:,active_face_ind);
        for k = 1:sum(active_face_ind)
            slide_mode = slide_modes(:,k);
            face_vectors = V(:,face_vector_inds(:,k)');
            face_normal = face_normals(:,k);
            p = t*face_vectors;
            if all(p>tol)||all(p<-tol)||all(abs(p)<=tol)
                if all(p>tol)
                    slide_mode(i) = 2;
                elseif all(p<-tol)
                    slide_mode(i) = 3;
                end
                face_sliding_modes = [face_sliding_modes,slide_mode];
                face_sliding_vectors = [face_sliding_vectors,{face_vectors}];
                face_sliding_normals = [face_sliding_normals,face_normal];
            else
                ns = null([t;face_normal']);
                ns = [ns,-ns];
                ns = ns(:,all(A*ns>-tol,1));
                edges_sliding = [edges_sliding,ns];
                edge_sliding_modes = [edge_sliding_modes, repmat(slide_mode,1,size(ns,2))];
                % positive sliding
                slide_mode(i) = 2;
                face_sliding_modes = [face_sliding_modes,slide_mode];
                face_sliding_vectors = [face_sliding_vectors,{[ns,face_vectors(:,p>tol)]}];
                face_sliding_normals = [face_sliding_normals,face_normal];
                % negative sliding
                slide_mode(i) = 3;
                face_sliding_modes = [face_sliding_modes,slide_mode];
                face_sliding_vectors = [face_sliding_vectors,{[ns,face_vectors(:,p<-tol)]}];
                face_sliding_normals = [face_sliding_normals,face_normal];
            end
        end
    end
end
edges_sliding = [edges_sliding, E];
edge_sliding_modes = [edge_sliding_modes, edge_modes];

contact_modes = [region_modes,edge_sliding_modes,face_sliding_modes];
contact_modes = [zeros(num_c,1),contact_modes];
contact_modes = unique(contact_modes','rows')';

if nargin > 2 && print == true
    fprintf('Total numer of modes: %d.\n', size(contact_modes,2));
    printModes(contact_modes);
end
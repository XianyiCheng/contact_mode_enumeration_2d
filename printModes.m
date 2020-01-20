
%
% Prints modes.
%
% @param      contact_modes  kDim x kNum matrix, a list of contact modes. !
%
% @return     { description_of_the_return_value }
%
function texts = printModes(contact_modes, print)
texts = [];
for i = 1:size(contact_modes,2)
    m = contact_modes(:,i);
    c = repmat('s',numel(m),1);
    c(m==1) = 'f';
    c(m==2) = 'r';
    c(m==3) = 'l';
    new_line = sprintf('%s\n',c);
    texts = [texts new_line];
end
texts(end) = []; % remove the last ENTER
if nargin == 2 && print == false
    return;
end
disp(texts);
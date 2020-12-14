function isAvailable=Sigma_isToolbox_available(name_of_toolbox)

% isAvailable==1 : this toolbox exists
% isAvailable==0 : this toolbox do not exists

v = ver;
isAvailable = any(strcmp(cellstr(char(v.Name)), name_of_toolbox));

end
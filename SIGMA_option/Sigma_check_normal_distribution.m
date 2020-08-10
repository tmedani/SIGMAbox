
function feature_result = Sigma_check_normal_distribution(feature_result)
% check if the feature have normal disctibution 
% return 1 if is the cas and 0 if not normal on the field 
% feature_result.is_normal_distribution

X = feature_result.o_best_features_matrix;
h = zeros(size(X,1),1);
p = zeros(size(X,1),1);

for l_feat = 1 : size(X,1)
    l_feat
[h(l_feat),p(l_feat)] = kstest(X(l_feat,:)) ;
%vartestn(X)
end
% check if vartestn
feature_result.is_normal_distribution = ~h;
end

function feature_result=Sigma_feature_assembling...
                              (init_method,init_parameter,feature_result)
%%%------------------------------------------------------------------------
%   feature_result=Sigma_feature_assembling
%                           (init_method,init_parameter,feature_result)
%  Function task:
% This function is used to get the final feature matrix,
% it assembles the output of the differents methods used in the session of
% the feature extraction
% The normalisation with the zscore is computed in this function
% 
%  Inputs :
%
%  Outputs :
%
%
%--------------------------------------------------------------------------
%
%
%  Main Variables
%
%  Dependencies
%
%%  NB: this code is copyrighted.
%  Please refer to copyright info in the file footer.
%%%------------------------------------------------------------------------


if init_parameter.sigma_show_comment==1
    disp('==============  Matrix feature assembly     ==================')
end

if isempty(feature_result)
    return;
end

% waiting 
    wait_title = 'Feature Matrix';
    wait_message = ' ...';
    h_wait = Sigma_waiting(wait_title, wait_message);
    
   
%% SECTION 1 : b- Matrix feature assembly (o_features_matrix)
% This script assemble the final features matrix according
%to the number of subjects and methods
o_features_matrix=[]; % The final matrix of features resulting
%from the methods chosen by the user
o_features_matrix_id=[];
channel_method=[]; % Index to identify the methods inside the
%features_matrix, number of the line and the method
size_matrix=[]; % features matrix size, used just to check

for Nmethode=1:length(init_parameter.method)
    % if init_parameter.method(Nmethode)==1
    %     continue
    % else
    % code to get the name of the actual metho
    s1=feature_result.used_method(Nmethode);
    s2=(init_method(init_parameter.method(Nmethode)).method_name);
    
    if strcmp(s1,s2)
        size_matrix=[size_matrix; size(feature_result.(init_method...
            (init_parameter.method(Nmethode)).method_out))];
        % Matrix feature assembly
        o_method=(init_method(init_parameter.method(Nmethode)).method_out);
        o_features_matrix=[o_features_matrix;feature_result.(o_method)];
        
        toto=[(init_method(init_parameter.method(Nmethode)).method_out)...
            '_band'];
        o_features_matrix_id=[o_features_matrix_id; feature_result.(toto)];
        B = repmat( init_method(init_parameter.method(Nmethode)...
            ).method_number,[size(feature_result.(init_method...
            (init_parameter.method(Nmethode)).method_out),1),1] );
        % This variabel is used in order to identify the methods and
        %       channel for the next analysis
        channel_method=[channel_method; (1:length(B))' B];
        clear (init_method(init_parameter.method(Nmethode)).method_out)
        clear B
    end
    % end
    % romove the individual method from the results
    if init_parameter.remove_individual_features=='Y'
        % romove field from structure
        feature_result=rmfield(feature_result,(o_method));
        feature_result=rmfield(feature_result,toto);
    end
    
end


%% Comput the cross terme here ??
if init_parameter.compute_cross_term_feature==1
    % Compute the cross terms
    [feature_matrix_all_term, ~,...
        feature_matrix_cross_term_id] = Sigma_creat_cross_term_feature...
        (o_features_matrix);
    o_features_matrix=feature_matrix_all_term;
    feature_result.feature_matrix_cross_term_id=...
        feature_matrix_cross_term_id;
elseif isfield(feature_result,'feature_matrix_cross_term_id')
    feature_result = rmfield(feature_result,...
        'feature_matrix_cross_term_id');
end
feature_result.nb_epoch=size(o_features_matrix,2);
feature_result.nb_features=size(o_features_matrix,1);

feature_result.channel_method=channel_method;
feature_result.o_features_matrix=o_features_matrix;
feature_result.o_features_matrix_id=o_features_matrix_id;
feature_result.o_features_matrix_id_infos=...
    {' N° Method  N°Channel   N°Band '};


%% Normalistion of the feature matrix & save the mean and the std
[Z,mu,sigma] = (zscore((feature_result.o_features_matrix)'));
feature_result.o_features_matrix_normalize=Z';
feature_result.o_features_matrix_mean=mu';
feature_result.o_features_matrix_std=sigma';

%% Check the separabality of the data 
label=feature_result.label;
[linear_Separability, Theta_perceptron] = ...
                 Sigma_check_linear_separability(o_features_matrix,label);

feature_result.linear_Separability=linear_Separability;

%% Check the variance of the feature
% If the variance is somewhere eqaule to zeros == remplace par the rearest
zero_variance = find(var(feature_result.o_features_matrix') ==0);
if ~isempty(zero_variance)
    feature_result.o_features_matrix(zero_variance,:) = ...
        ((feature_result.o_features_matrix(zero_variance-1,:)+feature_result.o_features_matrix(zero_variance+1,:)))/2;
    feature_result.zero_variance = zero_variance;
end
%% Display the results
if init_parameter.sigma_show_comment==1
    % Testing the size of the matrixs
    if init_parameter.compute_cross_term_feature==1
        nfeat=sum(size_matrix(:,1));
        condition = ( (size(o_features_matrix,1)==nfeat*(nfeat+1)) &&...
            (size(o_features_matrix,2)==size_matrix(1,2)) );
    else
        %nfeat=sum(size_matrix(:,1));
        condition = ((size(o_features_matrix,1)==sum(size_matrix(:,1)))...
            && (size(o_features_matrix,2)==size_matrix(1,2)) );
    end
    if condition
        display('====================   Informations   =================')
        display('The features matrix has the right dimension')
        display(['The dimension of the feature matrix is: ' ...
            num2str(size(o_features_matrix))])
        display(['The list of subject is: ' ...
            num2str(init_parameter.subject)])
        display(['The number of subject is: ' ...
            num2str(init_parameter.nb_subject)])
        display(['The number of epochs of each subject is: ' ...
            num2str((feature_result.nb_epoch))])
        display(['The total number of epochs is: '...
            num2str(sum(feature_result.nb_epoch))])
        
        display(['The list of the used method(s) is: '...
            num2str((init_parameter.method))])
        display(['The total number of method(s) is: '...
            num2str(length(init_parameter.method))])
        
        
        display(['The filters vector is: ' ...
            num2str((init_parameter.apply_filter))])
        display(['The filters are applied for the methods: '...
            num2str(init_parameter.method(find...
            (init_parameter.apply_filter==1)))])
        display(['The total number of applied filter is: '...
            num2str(sum(init_parameter.apply_filter))])
        display(['The selected band(s):' sprintf('\n ') ...
            sprintf('  %s\n ',init_parameter.selected_freq_list{:})])
        display(['The total number of bands is: ' ...
            num2str((init_parameter.nb_bands))])
        display(['The total number of channels is: ' ...
            num2str((init_parameter.nb_channels))])
        display(['The total number of features is: '...
            num2str(size(o_features_matrix,1))])
        fprintf (['The used methods for features are: \n  \t      '  ...
            sprintf('%s\n  \t      ', feature_result.used_method{:})]);
        
        disp('The matrix feature is normalized with the zscore here')
        disp(['Your data are linear Separability [yes (1) No(0)] ' ...
                                            num2str(linear_Separability)])
    end
    
    clear Nmethode
    disp('==============  End of Matrix feature assembly   ===============')
end

%% Display the results  sigma_write_logFile==1;
if init_parameter.sigma_write_logFile==1
    % Testing the size of the matrixs
    if ( (size(o_features_matrix,1)==sum(size_matrix(:,1))) &&...
            (size(o_features_matrix,2)==size_matrix(1,2)) )
        logFilename=init_parameter.logFilename;
        fid = fopen(logFilename,'a');
        
        fprintf(fid,'\n %s','== Informations : Sigma Feature assembling ==');
        fprintf(fid,'\n %s','The features matrix has the right dimension');
        fprintf(fid,'\n %s',['The dimension of the feature matrix is : '...
            num2str(size(o_features_matrix))]) ;
        fprintf(fid,'\n %s',['The list of subject is : '...
            num2str(init_parameter.subject)]);
        fprintf(fid,'\n %s',['The number of subject is : '...
            num2str(init_parameter.nb_subject)]);
        fprintf(fid,'\n %s',['The number of epochs of each subject is : '...
            num2str((feature_result.nb_epochs))]);
        fprintf(fid,'\n %s',['The total number of epochs is : '...
            num2str(sum(feature_result.nb_epochs))]);
        fprintf(fid,'\n %s',['The list of the used method(s) is : '...
            num2str((init_parameter.method))])   ;
        fprintf(fid,'\n %s',['The total number of method(s) is : ' ...
            num2str(length(init_parameter.method))]);
        fprintf(fid,'\n %s',['The filters vector is  : ' ...
            num2str((init_parameter.apply_filter))]);
        fprintf(fid,'\n %s',['The filters are applied for the methods : ' ...
            num2str(init_parameter.method(find...
            (init_parameter.apply_filter==1)))]);
        fprintf(fid,'\n %s',['The total number of appliyed filter is : ' ...
            num2str(sum(init_parameter.apply_filter))]);
        fprintf(fid,'\n %s',['The selected band(s)\n :' sprintf('\n ') ...
            sprintf('     %s\n ',init_parameter.selected_freq_list{:})]);
        fprintf(fid,'\n %s',['The total number of bands is : ' ...
            num2str((init_parameter.nb_bands))]);
        
        fprintf(fid,'\n %s',['The total number of channels is : ' ...
            num2str((init_parameter.nb_channels))]);
        fprintf(fid,'\n %s',['The total number of features is : ' ...
            num2str(length(channel_method))]);
        
        fprintf(fid,'\n %s',sprintf ...
            (['The used methods for features are: \n  \t      '  ...
            sprintf('%s\n  \t      ', feature_result.used_method{:})]));
        fclose(fid);
    end
end
     
    
    delete(h_wait)

end

%%
% % %----------------------------------------------------------------------
% % %                  Brain Computer Interface team
% % %
% % %                            _---~~(~~-_.
% % %                          _{        )   )
% % %                        ,   ) -~~- ( ,-' )_
% % %                       (  `-,_..`., )-- '_,)
% % %                      ( ` _)  (  -~( -_ `,  }
% % %                      (_-  _  ~_-~~~~`,  ,' )
% % %                        `~ -^(    __;-,((()))
% % %                              ~~~~ {_ -_(())
% % %                                     `\  }
% % %                                       { }
% % %   File created by Takfarinas MEDANI
% % %   Creation Date : 03/11/2016
% % %   Updates and contributors :
% % %
% % %   Citation: [creator and contributor names], comprehensive BCI
% % %             toolbox, available online 2016.
% % %
% % %   Contact info : francois.vialatte@espci.fr
% % %   Copyright of the contributors, 2016
% % %   Creative Commons License, CC-BY-NC-SA
% % %----------------------------------------------------------------------


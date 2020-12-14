function [epochs_for_calibration, epochs_for_test, itteration]=Sigma_divide_data(features_results,selected_subject,rate)
% functio [epochs_for_calibration, epochs_for_test]=Sigma_divide_data(features_results,selected_subject,calibration_rate)
% This function divid the data of the selected_subject into two part 
% Training/or calibration data with the rat [0 1] (or 0 100 %) from the
% epochs of the selected subject and take the rest as the test part
% Inputs : 
% features_results : structure (outpurt of the Sigma_feature_extration ) with the field :
%                   o_features_matrix : the feature matrix 
%                   labels : vector of lables of the epoches
%                   epochs : vectores containif the number of the epoches
%                   for each subject
% selected_subject : the index of the subject to treat, should an integer
%                   between 1 and the max (nb_subject) available in the data
% rate : the rate of the calibration part among the total number of epoches
%                    of the current subject
% Outputs : 
% epochs_for_calibration : index of the calibration epoches
% epochs_for_test : index of the test part 
% itteration : contain the number of iteration to reach the outputs
% NB: This function take in account the balacement, the number of the
% epochs of the positive classe is equale to the numbre of the element of
% the negative classe (+/-1) when it's possible
% after 20 itteration the difference is increased to (+/- 2)
% after 50 //                   //             // to (+/- 5)
% after 100 //                  //             // to (+/- 10)
% otherwise an error message
% IMPORTANT : In order to test the performances of the results, the order
% of the epochs must be canhged according to the new organisation in the
% data. A new label vector shoud be defined according to the index of the
% outputs
%%
%% -----------------
%% Get the data 
o_features_matrix=features_results.o_features_matrix;
%o_features_matrix_r=o_features_matrix(1:10,:);
labels=features_results.labels;
epochs=features_results.epochs;

%% Get the subject to study
% selected_subject=2; % as an input of the function

nb_epochs=epochs(selected_subject);
selected_epochs=sum(epochs(1:selected_subject-1))+1:sum(epochs(1:selected_subject));
selected_labels=labels(selected_epochs);

%% Find the classes of this epoches 
classes=unique(selected_labels);

%% Get the rate of the part os subject for the calibration 
calibration_rate=rate; % should a double between 0 and 1

%% Construc the vector of  calibration/training and teste
epochs_for_calibration=nan(1,round(calibration_rate*nb_epochs));
disp(['There is ' num2str(length(epochs_for_calibration)) ' epochs for calibration'])
disp(['There is ' num2str(length(selected_epochs)-length(epochs_for_calibration)) ' epochs for test'])

%epochs_for_test=nan(1,nb_epochs-length(epochs_for_calibration));

%% Fill the vectors of calibration
%ratio_balancement=0; % the ratio between the two classes on the calibration set
diff_classes=10; % the diference between the elements of the two classes
itteration=0; % number of iteration
%interval=[0.75 1.25]; % the default values for the tests
max_iteration=[10 20 50 100];
diff_max=[1 2 5 10]; % the initial and optimal value
itter=1;
diff_max_0=1;
max_iteration_0=10;
%while (ratio_balancement<interval(1) || ratio_balancement>interval(2))
while diff_classes>diff_max_0
    
    msize = numel(selected_epochs);
    epochs_for_calibration=selected_epochs(randperm(msize,length(epochs_for_calibration)));
    labels_of_calibration=labels(epochs_for_calibration);

    classe_1=find(labels_of_calibration==classes(1));
    classe_2=find(labels_of_calibration==classes(2));

    %ratio_balancement=length(classe_1)/length(classe_2);
    diff_classes=abs(length(classe_2)-length(classe_1));
    itteration=itteration+1;
        if itteration>max_iteration_0
            itter=itter+1;
            % controle de la boucle  
            max_iteration_0=max_iteration(itter);
            diff_max_0=diff_max(itter);
            warning(['SIGAM>> New thershold is selected ... max iteration = ' num2str(max_iteration_0)])

        end
    epochs_for_calibration=sort(epochs_for_calibration);
end

%%% Get the rest ==> epochs of testing 

ir=[]; % get the inedex of the same value, ir : Index to Romove
for i=1:length(selected_epochs)
ind = find(epochs_for_calibration==selected_epochs(i));
    if ~isempty(ind)
        ir=[ir i];
    end
end
toto=selected_epochs;
toto(ir)=[];

epochs_for_test=toto;

end 
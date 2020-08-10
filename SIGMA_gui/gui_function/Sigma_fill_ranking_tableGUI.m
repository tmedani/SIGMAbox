function Sigma_fill_ranking_tableGUI(handles)

% File created by T MEDANI on 21/02/2018
% give the right shape to data

if handles.init_parameter.compute_cross_term_feature==1
    performance_ranking = nan(size(handles.input_feature.performance_ranking));
else
    performance_ranking = handles.input_feature.performance_ranking;
end
% give the right shape to data
% Aurélien
%data = num2cell(handles.input_feature.o_features_matrix_id(handles.input_feature.idx_best_features, :));
% takfa
data = handles.input_feature.best_organisation;
data_infos = handles.input_feature.best_organisation_infos;
data = data(:,2:4);
data_infos = data_infos(:,2:4);

% Names of the EEG channels
channel_name = handles.init_parameter.channel_name;

% Names of the custom feaures
if find(handles.init_parameter.method==98)
    subject_custom_feature_name = handles.input_feature.o_custom_feature_subject_name(1,:);
end

if find(handles.init_parameter.method==99)
%    data_custom_feature_name = handles.input_feature.o_custom_feature_data_name(:,1);
    data_custom_feature_name = handles.input_feature.o_custom_feature_data_name(1,:);
end

bands_name = handles.init_parameter.bands_list;

%%% Remplissage du tableau (variable data)
for cF = 1:size(data,1)
    % Aurélien
    %        data{cF,1} =  handles.input_method(data{cF,1}).method_name;    
    % Takfa, correction dans le cas de Synchroniation, deux channels et
    % pas que un seul
    method_number=(data{cF,1});
    method_name=handles.input_method(data{cF,1}).method_name;
    data{cF,1} =  [method_name ' (method N°: ' num2str(method_number) ')'];
    if method_number~=98 && method_number~=99
        y = data{cF,2};
        %y=str2num(x);
        if length(y) == 1
            data{cF,2}= [ 'Channel(s) : ' num2str(data{cF,2}) '  ; ( '  (channel_name{y} ) ' ) '];
            %            data{cF,2} = [channel_name{y} ' |  (ch ' num2str(y) ')'];
        elseif length(y) == 2 % synchrony measuer
            y1 = y(1);
            y2 = y(2);
            % Display only the channel number
            %couple=['ch' num2str(y1) ' vs ch' num2str(y2) ];
            % Display only the channel names
            couple = [channel_name{y1} ' / ' channel_name{y2} ' | (ch ' num2str(y1) ' / ' num2str(y2) ')'] ;
            data{cF,2}=couple;
        end
        %display the bands names
        z = data{cF,3};
        if isnan(z)
            z=8; % the all frequency
        end
        bands = [bands_name{z} ' | (band N° :' num2str(z) ' )'];
        data{cF,3} = bands;
        
        %data{cF,4} = performance_ranking(cF);
    elseif  method_number==98 % custom feature from subject
        y = data{cF,2};
        if length(y) == 1
            data{cF,2}= [ 'Observation(s) : ' num2str(data{cF,2}) '  ; ( '  (subject_custom_feature_name{y} ) ' ) '];
            %            data{cF,2} = [channel_name{y} ' |  (ch ' num2str(y) ')'];
        elseif length(y) == 2 % synchrony measuer
            y1 = y(1);
            y2 = y(2);
            % Display only the channel number
            %couple=['ch' num2str(y1) ' vs ch' num2str(y2) ];
            % Display only the channel names
            couple = [channel_name{y1} ' / ' channel_name{y2} ' | (ch ' num2str(y1) ' / ' num2str(y2) ')'] ;
            data{cF,2}=couple;
        end
        %display the bands names
        %z = data{cF,3};
        bands = 'Not specified';
        data{cF,3} = bands;
        %data{cF,4} = performance_ranking(cF);
    elseif  method_number == 99 % custom feature from data
        y = data{cF,2};
        if length(y) == 1
            data{cF,2}= [ 'Observation(s) : ' num2str(data{cF,2}) '  ; ( '  (data_custom_feature_name{y} ) ' ) '];
            %            data{cF,2} = [channel_name{y} ' |  (ch ' num2str(y) ')'];
        elseif length(y) == 2 % synchrony measur
            y1 = y(1);
            y2 = y(2);
            % Display only the channel number
            %couple=['ch' num2str(y1) ' vs ch' num2str(y2) ];
            % Display only the channel names
            couple = [channel_name{y1} ' / ' channel_name{y2} ' | (ch ' num2str(y1) ' / ' num2str(y2) ')'] ;
            data{cF,2}=couple;
        end
        %display the bands names
        %z = data{cF,3};
        bands = 'Not specified';
        data{cF,3} = bands;
        %data{cF,4} = performance_ranking(cF);
    end
    data{cF,4} = performance_ranking(cF);
    data{cF,5} = handles.input_feature.is_normal_distribution(cF);
end

handles.FRRV_table.ColumnName(1) = {'Method (Number)'};
handles.FRRV_table.ColumnName(2) = {'Channel(s)/Observation(s)'};
handles.FRRV_table.ColumnName(3) = {'Frequency [Hz]'};
handles.FRRV_table.ColumnName(4) = {'Score [cos(theta)]'};
handles.FRRV_table.ColumnName(5) = {'Normal Distribution'};

% a verifier 
%handles.FRRV_table = SIGMA_adapt_coulum_width_to_data(handles.FRRV_table,data);
dataSize = size(handles.FRRV_table.ColumnName);
% Create an array to store the max length of data for each column
maxLen = zeros(1,dataSize(2));
% Find out the max length of data for each column
% Iterate over each column
for i=1:dataSize(2)
      % Iterate over each row
%      for j=1:dataSize(1)
      for j=1:size(data,1)
          len = length(data{j,i});
          % Store in maxLen only if its the data is of max length
          if(len > maxLen(1,i))
              maxLen(1,i) = len;
          end
      end
end
% Some calibration needed as ColumnWidth is in pixels
cellMaxLen = num2cell(maxLen*7);
% Create UITABLE with required arguments
%hTable=uitable('parent',gcf,'units','pixels','position',[20 20 400 300]);

set(handles.FRRV_table, 'units','pixels');
%set(hTable, 'Data', data);
% Set ColumnWidth of UITABLE
set(handles.FRRV_table, 'ColumnWidth', cellMaxLen);


% handles.FRRV_table.ColumnWidth = {220  200  250 100};

%handles.FRRV_table.Position = [0 0.15 1 0.8];
handles.FRRV_table.TooltipString='List of the best ranked features';
% display data in the table
set(handles.FRRV_table, 'Data', data)

end
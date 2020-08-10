function [hTable] = SIGMA_adapt_coulum_width_to_data(hTable,data)

% Assume data is provided
% data = {'data1','data2','data3','very large data which does not fit in column';'a','b','c','smallerstringthatfits'};
% Find the size of datadataSize = size(handles.FRRV_table.ColumnName);
% Create an array to store the max length of data for each column

dataSize = size(hTable.ColumnName);

maxLen = zeros(1,dataSize(2));
% Find out the max length of data for each column
% Iterate over each column
for i=1:dataSize(2)
      % Iterate over each row
      for j=1:dataSize(1)
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

set(hTable, 'units','pixels');
%set(hTable, 'Data', data);
% Set ColumnWidth of UITABLE
set(hTable, 'ColumnWidth', cellMaxLen);
end
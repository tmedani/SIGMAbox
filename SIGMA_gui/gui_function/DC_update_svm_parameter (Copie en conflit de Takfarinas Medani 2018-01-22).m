function handles = DC_update_svm_parameter(handles, hObject)


kernel = get(handles.SVME_pum_kernel, 'String');
selected_kernel = get(handles.SVME_pum_kernel, 'Value');
c_kernel={kernel{selected_kernel}};
handles.input.c_kernel = c_kernel;



% Gaussian value
c_gaussian_value=str2num(get(handles.SVME_edit_GV_low, 'String')):...
    str2num(get(handles.SVME_edit_GV_step, 'String')):...
    str2num(get(handles.SVME_edit_GV_high, 'String'));
handles.input.c_gaussian_value = c_gaussian_value;

% polynomial value
c_polynomial_value= str2num(get(handles.SVME_edit_PV_low, 'String')):...
    str2num(get(handles.SVME_edit_PV_step, 'String')):...
    str2num(get(handles.SVME_edit_PV_high, 'String'));
handles.input.c_polynomial_value = c_polynomial_value;
% hyper parameter
handles.input.c_constraint = str2num(get(handles.SVME_edit_cons_low, 'String')):str2num(get(handles.SVME_edit_cons_step, 'String')):str2num(get(handles.SVME_edit_cons_high, 'String'));

% % modification takfa
% if (strcmp(c_kernel, 'polynomial') == 1)
%     condition = length(c_polynomial_value);
% else
%     if (strcmp(c_kernel, 'rbf') == 1)
%         condition = length(c_gaussian_value);
%     else % the case of the 'linear'
%         condition = 1;
%     end
% end
%handles.input.condition=condition;

% other parameters

tolkkt = str2num(get(handles.SVME_edit_kkttol, 'String'));
if(tolkkt <= 0)
    handles.input.c_tolkkt = 0.5;
    set(handles.SVME_edit_kkttol, 'String', '0.05');
else
   handles.input.c_tolkkt = tolkkt;
end

violation = str2num(get(handles.SVME_edit_violation, 'String'));
if(violation <= 0)
    handles.input.c_violation = 0.1;
    set(handles.SVME_edit_violation, 'String', '0.01');
else
   handles.input.c_violation = violation;
end

retest = str2num(get(handles.SVME_edit_retest, 'String'));
if(retest < 0.5)
    handles.input.c_retest = 1;
    set(handles.SVME_edit_retest, 'String', '1');
else
    handles.input.c_retest = retest;
end

stability = str2num(get(handles.SVME_edit_stability, 'String'));
if(stability < 0.5)
    handles.input.c_stability = 30;
    set(handles.SVME_edit_stability, 'String', '30')
else
    handles.input.c_stability_test =  stability;
end

disp(handles.input)












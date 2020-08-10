function handles = Call_sigma_apply_model_gui(handles, ~)


if( isfield(handles, 'selected_model') )
    Sigma_apply_model_aure_gui(handles);
else
    msgbox('SIGMA : Please select model before');
end
end



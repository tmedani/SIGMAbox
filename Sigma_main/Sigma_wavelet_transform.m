function features_results=Sigma_wavelet_transform(init_parameter,~,features_results,s_EEG,Nsubj,Nepochs,Nmethode)


o_wavelet_transform_ch=[];
temp0=[];

if (Nepochs==1)
    o_wavelet_transform_epo=[];
    if Nsubj==1
        features_results.o_wavelet_transform=[];
    end
end




%% Initialization for the wavelet transform features
% This line should be implemented from the initialisation process
%wt_kurtosis_method=sum(init_parameter.method==26); % the kurtosis
wt_kurtosis_method=logical(find(unique(init_parameter.method)==26)); % the kurtosis
%wt_std_method=sum(init_parameter.method==27); % The standard deviation
wt_std_method=logical(find(unique(init_parameter.method)==27)); % the kurtosis

%% INITIALISAION OF THE DESIRED METHODS
%% Kurtosis
if wt_kurtosis_method==1
    o_wt_kurtosis_ch=[]; % you shoul specify the size...
    if (Nepochs==1)
        o_wt_kurtosis_epo=[];
        if Nsubj==1
            features_results.o_wt_kurtosis=[];
        end
    end
end

%% Standard deviation
if wt_std_method==1
    o_wt_std_ch=[];
    if (Nepochs==1)
        o_wt_std_epo=[];
        if Nsubj==1
            features_results.o_wt_std=[];
        end
    end
end

%% Add here the initialisation of the methods for feature extraction from the wavelets



%% General wavelet parameters
wavelet_type=init_parameter.wavelet_transform_param.wavelet_type;
Cwt=wavelet_type;
wavelet_center_freq=init_parameter.wavelet_transform_param.wavelet_center_freq;
Fc=wavelet_center_freq;
FreqEch=init_parameter.sampling_rate;

%% Apply a filter here according to the choice of the user
apply_filter=init_parameter.apply_filter(Nmethode);

% Loop over all the channel
for Nchannel=1:size(s_EEG.data,1)
    i_EEG=s_EEG.data(Nchannel,:,Nepochs); % loard the data associated for the actual epochs (Nepochs) for the Nchannel
    if (apply_filter==1) % check if the filter will be applied for the actual method Nmethode
        for Nband=1:init_parameter.nb_bands
            Min=init_parameter.selected_freq_bands(Nband,1); % minimum frequency for the selected band
            Max=init_parameter.selected_freq_bands(Nband,2); % maximal frequency for the selected band
            frqsmp=init_parameter.wavelet_transform_param.step_frequency;
            minscal = 1/(Fc * FreqEch / Min); % scale
            maxscal = 1/(Fc * FreqEch / Max);
            step = frqsmp.*(maxscal-minscal)/(Max-Min);
            scale = fliplr(1./[minscal:step:maxscal]);
            Sig=i_EEG(:);
            
            o_wavelet_transform0 =cwt(Sig,scale,Cwt);
            o_wavelet_transform_ch =[o_wavelet_transform_ch,{o_wavelet_transform0}];
            
            
            % Track the identification of the method, channel and band,
            if((Nsubj==1)&&(Nepochs==1))
                temp0=[temp0; init_parameter.method(Nmethode) Nchannel init_parameter.selected_band(Nband) ];
            end
            
            %% Here we can extrac now the features from the wavelet transformation
            % Make here a test on the chosen method for the wavelet transform
            %% wt kurtosis
            if wt_kurtosis_method==1
                wt_magnitude = abs(o_wavelet_transform0);
                wt_kurtosis = kurtosis(wt_magnitude(:));
                o_wt_kurtosis_ch =[o_wt_kurtosis_ch,wt_kurtosis];
            end
            
            %% wt standard devaition
            if wt_std_method==1
                wt_magnitude = abs(o_wavelet_transform0);
                wt_std = std(wt_magnitude(:));
                o_wt_std_ch =[o_wt_std_ch,wt_std];
            end
            
            
            
        end
    else
        
        %% In case without filtring ==> all frequency bands
        Min=init_parameter.wavelet_transform_param.minimal_frequency;
        Max=init_parameter.wavelet_transform_param.maximal_frequency;
        FreqEch=init_parameter.sampling_rate;
        minscal = 1/(Fc * FreqEch / Min);
        maxscal = 1/(Fc * FreqEch / Max);
        step = frqsmp.*(maxscal-minscal)/(Max-Min);
        scale = fliplr(1./[minscal:step:maxscal]);
        
        Sig=i_EEG(:);
        o_wavelet_transform0 =cwt(Sig,scale,Cwt);
        o_wavelet_transform_ch =[o_wavelet_transform_ch,{o_wavelet_transform0}];
        
        % Track the identification of the band
        if ((Nsubj==1)&&(Nepochs==1))
            temp0=[temp0;init_parameter.method(Nmethode) Nchannel nan];
        end
        
        %% Here we can extrac now the features from the wavelet transformation
        %% Make here a test on the shoesen method for the wavelet transform
        if wt_kurtosis_method==1
            wt_magnitude = abs(o_wavelet_transform0);
            wt_kurtosis = kurtosis(wt_magnitude(:));
            o_wt_kurtosis_ch =[o_wt_kurtosis_ch,wt_kurtosis];
        end
        %% wt standard devaition
        if wt_std_method==1
            wt_magnitude = abs(o_wavelet_transform0);
            wt_std = std(wt_magnitude(:));
            o_wt_std_ch =[o_wt_std_ch,wt_std];
        end
        
        
    end
end

o_wavelet_transform_epo=o_wavelet_transform_ch';
features_results.o_wavelet_transform=[features_results.o_wavelet_transform o_wavelet_transform_epo];

% This line is not needed, because it used for the extraction and it's not
% a value on each row
%features_results.o_wavelet_transform=o_wavelet_transform;
features_results.o_wavelet_transform=[];

if ((Nsubj==1)&&(Nepochs==1))
    features_results.o_wavelet_transform_band=temp0;
    features_results.o_wavelet_transform_band=[];
    features_results.o_wavelet_transform_infos='The results of this method are not saved, they are used to comput the derivated method wt_XXX';
end

%% In case of the methods associated for the wavelet transform
% Make here a test on the shoesen method for the wavelet transform

%% Curtosis of the wavelet transform
if wt_kurtosis_method==1
    o_wt_kurtosis_epo=o_wt_kurtosis_ch';
    features_results.o_wt_kurtosis=[features_results.o_wt_kurtosis o_wt_kurtosis_epo];
    %features_results.o_wt_kurtosis=o_wt_kurtosis;
    
    if ((Nsubj==1)&&(Nepochs==1))
        temp0(:,1)=26*ones(size(temp0(:,1))); % 26 is the number of the wt_kurtosis method
        features_results.o_wt_kurtosis_band=temp0;
    end
end

%% Standard deviation of the wavelet transform
if wt_std_method==1
    o_wt_std_epo=o_wt_std_ch';
    features_results.o_wt_std=[features_results.o_wt_std o_wt_std_epo];
    %features_results.o_wt_std=o_wt_std;
    if ((Nsubj==1)&&(Nepochs==1))
        temp0(:,1)=27*ones(size(temp0(:,1))); % 27 is the number of the wt_kurtosis method
        features_results.o_wt_std_band=temp0;
    end
end
end






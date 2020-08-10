function Sigma_visualisating_multiplot(EEG,start_time,end_time)
%==========================================================================
%% This script is part of the BCI toolbox, it's used by the toolbox to 
%prepare data in order to be used by the eegLab functions
%==========================================================================
%%The input is an EEG signal to be displayed.

% start_time : information of the start time to plot. it's the start of the
% currently window.

% end_time : Information on the end_time to plot.it's the end of the
% currently diplayed window.

% Acquire the channel names and the number of channels from the EEG.

ch_names= EEG.labels;
nb_chan = length(ch_names);

%Prepare a chanloc structure according to eegLab reference.
chanlocs = struct('theta',0 , ...
                   'radius',0  , ...
                   'labels',0,...
                   'sph_theta',0,...
                   'sph_phi',0,...
                   'sph_radius',0,...
                   'X',0,...
                   'Y',0,...
                   'Z',0);		
		
bad_chans= EEG.bad;		
%iteratte over all channel in order to fill-in all necessary informations 
%for the channels
for channel = 1:nb_chan
   
        if isempty(find(bad_chans==channel))
       % attribute X,Y,Z possitions of the 3D plan
       chanlocs(channel).X=EEG.locations(channel).X;
       chanlocs(channel).Y=EEG.locations(channel).Y;
       chanlocs(channel).Z=EEG.locations(channel).Z;
      
       X=chanlocs(channel).X;
       Y=chanlocs(channel).Y;
       Z=chanlocs(channel).Z;
        
      % compute the radius and the theta according to eegLab 
      [angle radius] = cart2topo(X,Y,Z);
             
       chanlocs(channel).theta= angle;       
       chanlocs(channel).radius= radius;
       
       %give the channel name
       chanlocs(channel).labels=ch_names{channel};      
       
       %and the spherical informations
       chanlocs(channel).sph_theta=EEG.locations(channel).sph_theta;
       chanlocs(channel).sph_phi=EEG.locations(channel).sph_phi;
       chanlocs(channel).sph_radius=EEG.locations(channel).sph_radius;
       
       EEG.chanlocs(channel)=chanlocs(channel);
        else
            % attribute X,Y,Z possitions of the 3D plan
       chanlocs(channel).X=EEG.locations(channel).X;
       chanlocs(channel).Y=EEG.locations(channel).Y;
       chanlocs(channel).Z=EEG.locations(channel).Z;
      
       X=chanlocs(channel).X;
       Y=chanlocs(channel).Y;
       Z=chanlocs(channel).Z;
        
      % compute the radius and the theta according to eegLab 
      [angle radius] = cart2topo(X,Y,Z);
             
       chanlocs(channel).theta= [];       
       chanlocs(channel).radius= [];
       
       %give the channel name
       chanlocs(channel).labels=ch_names{channel};      
       
       %and the spherical informations
       chanlocs(channel).sph_theta=[];
       chanlocs(channel).sph_phi=[];
       chanlocs(channel).sph_radius=[];
       
       EEG.chanlocs(channel)=chanlocs(channel);
            
            
       end
       
    
end



%prepare the data
data =EEG.data(:,start_time:end_time);


figure
plottopo(data,chanlocs);


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
% % %   File modified by Joffrey THOMAS
% % %   Creation Date : 08/09/2017
% % %   Updates and contributors :
% % %
% % %   Citation: [creator and contributor names], comprehensive BCI
% % %             toolbox, available online 2016.
% % %           
% % %   Contact info : joffrey.thomas.18@eigsi.fr        
% % %   Copyright of the contributors, 2016
% % %   Creative Commons License, CC-BY-NC-SA
% % %----------------------------------------------------------------------
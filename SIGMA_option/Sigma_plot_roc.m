function Sigma_plot_roc(labels,pos_score,roc_title,nb_feature)
% This function Plot the roc curves and if nb_feature is included, 
% annotation is added to the plot

figure('color',[1 1 1]);
grid on; grid minor; hold on
[Xa,Ya,~,AUC,OPTROCPT] = perfcurve(labels,pos_score,1);
plot(Xa,Ya,'r*',0:1,0:1,'g',1:-0.1:0,0:0.1:1,'y',OPTROCPT(1),OPTROCPT(2),...
    'ks','markersize',15)
xlabel('False positive rate','FontSize',15)
ylabel('True positive rate','FontSize',15)
title(roc_title,'FontSize',20)

if nargin==3
dim = [0.3 0.0 0.6 0.3];
str =['Max AUC = ' num2str(AUC*100,4) '% for Nb feat = :  ' num2str(nb_feat) ];
htxtbox =annotation('textbox',dim,'String',str,'FitBoxToText','on','Tag' ...
        , 'somethingUnique');
end
if nargin==4
    dim = [0.3 0.0 0.6 0.3];
    nb_feat=nb_feature;
    str =['Max AUC = ' num2str(AUC*100,4) '% for Nb feat = :  ' num2str(nb_feat) ];
    htxtbox =annotation('textbox',dim,'String',str,'FitBoxToText','on','Tag', 'somethingUnique');
end
end
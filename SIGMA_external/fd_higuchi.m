
function [FD]=fd_higuchi(x,kmax)
%-----------------------------------
%[FD,r2,k_all,L_avg]=fd_higuchi(x,kmax)----------------------------------
% Higuchi estimate in [1]
% [1] T Higuchi, “Approach to an irregular time series on the basis of the fractal
% theory,�? Phys. D Nonlinear Phenom., vol. 31, pp. 277–283, 1988.
%---------------------------------------------------------------------
N=length(x);

DBplot=0;

if(nargin<2 || isempty(kmax)), kmax=floor(N/10); end

FD=[]; L=[];


% what values of k to compute?
ik=1; k_all=[]; knew=0;
while( knew<kmax )
    if(ik<=4)
        knew=ik;
    else
        knew=floor(2^((ik+5)/4));
    end
    if(knew<=kmax)
        k_all=[k_all knew];
    end
    ik=ik+1;
end


%---------------------------------------------------------------------
% curve length for each vector:
%---------------------------------------------------------------------
inext=1; L_avg=zeros(1,length(k_all));
for k=k_all
    
    L=zeros(1,k);
    for m=1:k
        ik=1:floor( (N-m)/k );
        scale_factor=(N-1)/(floor( (N-m)/k )*k);
        
        L(m)=sum( abs( x(m+ik.*k) - x(m+(ik-1).*k) ) )*(scale_factor/k);
    end

    L_avg(inext)=mean(L);
    inext=inext+1;    
end

x1=log2(k_all); y1=log2(L_avg);
c=polyfit(x1,y1,1);
FD=-c(1);



if(nargout>1)
    y_fit=c(1)*x1 + c(2);
    y_residuals=y1-y_fit;

    r2=1-(sum( y_residuals.^2 ))./( (N-1).*var(y1) );
end


if(DBplot)
    figure(42); clf; hold all;
    plot(log2(k_all),log2(L_avg),'o');
    y_fit=c(1)*log2(k_all) + c(2);
    plot(log2(k_all),y_fit,'-');
% $$$     ylim([-5 15]);
end

    
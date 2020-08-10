function D=fd_katz(x)
%---------------------------------------------------------------------
% Katz estimate in [2]
% [2] MJ Katz, Fractals and the analysis of waveforms. Computers in Biology and Medicine,
% vol. 18, no. 3, pp. 145–156. 1988
%---------------------------------------------------------------------
N=length(x);
p=N-1;

% 1. line-length
for n=1:N-1
    L(n)=sqrt( 1 + (x(n)-x(n+1)).^2 );
end
L=sum(L);

% 2. maximum distance:
d=zeros(1,p);
for n=1:N-1
    d(n)=sqrt( n.^2 + (x(1)-x(n+1)).^2 );
end
d=max(d);



D=log(p)/(log(d/L)+log(p));
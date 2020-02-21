function [g,x,u_standardnorm]=compute_g(u_uniform)

u_standardnorm=norminv(u_uniform);
[N,~]=size(u_standardnorm);
%% evaluate g
g=[];x=[];
for i=1:N
    [g(i,:),x(i,:)]=LSF(u_standardnorm(i,:));
end
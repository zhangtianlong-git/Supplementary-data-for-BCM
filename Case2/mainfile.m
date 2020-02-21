% function mainfile
addpath(genpath(pwd));
rand('seed',sum(100*clock))
clear;clc
t1 = clock;
c=1e40;
NN=200000;%the pool
M=3;   %the number of variables
u_uniform_add=[];
u_c=[normcdf(-3);normcdf(0);normcdf(3)];
%hold on
for i=1:M
    u=repmat(normcdf(-3),3,M);
    u(:,i)=u_c;
    u_uniform_add=[u_uniform_add;u];
    %plot3(u(:,1),u(:,2),u(:,3),'-g');
end
%plot3(u_c,u_c,u_c,'-g');
u_uniform_add=[u_uniform_add;repmat(u_c,1,M)];
u_uniform_add=unique(u_uniform_add,'rows');
u_uniform=[];
coordinate=[];
g=[];
u_uniform_pool=lhsdesign(NN,M);
u_standardnorm_pool=norminv(u_uniform_pool);
u_standardnorm=[];
iter=0;  %the number of iteratiom
pf_curve=[];
box=[];
dd=[];
par=0.2;
%%
while  length(g)<500 %flag_stop==0 || flag_cov==0
iter=iter+1
[g_add,coordinate_add,u_standardnorm_add]=compute_g(u_uniform_add);
u_uniform=[u_uniform;u_uniform_add];
coordinate=[coordinate;coordinate_add];
u_standardnorm=[u_standardnorm;u_standardnorm_add];
g=[g;g_add];
label=sign(g);
label(find(label==0),:)=-1;
%[bestacc,bestg] = SVMcg(label,u_uniform);
% [bestacc,bestg] = SVMcg(label,u_standardnorm);
cmd = [' -c ',num2str( c ),'-g',num2str( 1/M )];
model = svmtrain(label,u_standardnorm, cmd);
y=[];
label_pool=zeros(NN,1);
[label_pool,~,y] = svmpredict(label_pool,u_standardnorm_pool, model);
%enrich
[MM,~]=size(coordinate_add);
for j=1:MM
    d(:,j)=(sum((u_standardnorm_pool-repmat(u_standardnorm_add(j,:),NN,1)).^2,2)).^(1/2);
end
dd=[dd,d];
d=[];
d_sto=min(dd');
d_max=max(d_sto);
g_pool=y;
u_p=abs(g_pool);
l_p=d_sto'./(1+exp(-20*(d_sto'-par*d_max)));
i_p=u_p./l_p;
[~,order]=sort(i_p);
u_uniform_add=u_uniform_pool(order(1),:);
pf_curve(length(g),1)=length(find(label_pool<0))/NN;
pf_curve(length(g),1)
if sqrt(var(pf_curve(length(g)-5:length(g)),1))/mean(pf_curve(length(g)-5:length(g))) < 1e-3
    break;
end
end
the_number_of_points=length(g)
t2 = clock;
t = etime(t2,t1)
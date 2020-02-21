function [g,x]=LSF(u)
%% define the applied pressure
%%
R = eye(3); %correlation matrix
mean = [38310 23940 12];
% COV=[0.2 0.2 0.1];
stdv = [38310*0.2 23940*0.2 12*0.1];
probdata.Lo=chol(R,'lower');  %% please further check this!!!!!!!!!!!!!!!!!!!!!!
%specify the type of distribution:
%1-normal,2-lognormal,3-beta,4-uniform,5-truncated normal,6-standard normal
marg(1,:)=[1 1 1];  %6 for standard normal distribution
marg(2,:)=mean;
marg(3,:)=stdv;
probdata.marg=marg';
x=parameter_distribution(probdata,u);
%% read fos
warning off
delete '*.tmp'
delete 'flac_fos.txt'
delete 'Request.txt'
delete 'flac.log'
delete 'RequestNew.txt'

dlmwrite('FlacInput.txt',x,'delimiter','\n');

system('type nul>Request.txt');
while exist('RequestNew.txt') == 0
    pause(0.1)
end
a=textread('flac.log','%s','delimiter',' ');
[flag,location]=ismember({'larger','smaller'},a);
a{location(location>0)}
g = flag(1);
end
function [g,x]=LSF(u)
%% define the applied pressure
%%
R = eye(6); %correlation matrix
mean = [2000 30 4 34500 31200 18.5];
% COV=[0.2 0.2 0.1];
stdv = [110 1.79 0.48 3950 6310 1];
probdata.Lo=chol(R,'lower');  %% please further check this!!!!!!!!!!!!!!!!!!!!!!
%specify the type of distribution:
%1-normal,2-lognormal,3-beta,4-uniform,5-truncated normal,6-standard normal
marg(1,:)=[1 1 1 1 1 1];  %6 for standard normal distribution
marg(2,:)=mean;
marg(3,:)=stdv;
probdata.marg=marg';
x=parameter_distribution(probdata,u);
%% read fos
warning off
delete '*.tmp'
delete 'flac_fos.txt'
delete 'message.txt'
delete 'flac.log'
delete 'message_new.txt'

dlmwrite('flac_input_x.txt',x,'delimiter','\n');

system('type nul>message.txt');
while exist('message_new.txt') == 0
    pause(0.1)
end
a=textread('flac.log','%s','delimiter',' ');
[flag,location]=ismember({'larger','smaller'},a);
g = flag(1);
end
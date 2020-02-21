function x=parameter_distribution(probdata,u)
u=u';
Lo = probdata.Lo;  %lower matrix of correlation matrix
z = Lo * u;   %correlated standard normal variables

marg=probdata.marg;   %get marginal parameters of distributions

nrv=length(u);    %number of random variables
x=zeros(nrv,1);    %initial variables in physical space

for i=1:nrv
    switch marg(i,1)  %type of distribution
        case 1 %Normal distribution
            mean=marg(i,2);
            stdv=marg(i,3);
            x(i,:)=z(i,:)*stdv+mean;
        case 2 %Lognormal distribution
            mean = marg(i,2);
            stdv = marg(i,3);
            cov = stdv/mean;
            zeta = (log(1+cov^2))^0.5;
            lambda = log(mean) - 0.5*zeta^2;
            x(i,:)=exp(z(i,:)*zeta+lambda);
        case 3 %Beta distribution
            mean = marg(i,2);
            stdv = marg(i,3);
            a    = marg(i,4);  %left bound
            b    = marg(i,5);  %right bound
            par_guess = 1;
            par = fminsearch('betapar',par_guess,optimset('fminsearch'),a,b,mean,stdv);
            q = par;
            r = q*(b-a)/(mean-a) - q;

            x01 = fminbnd('zero_beta',0,1,optimset('fminbnd'),q,r,normcdf(z(i,:)));
            % Transform x01 from [0,1] to [a,b] interval
            x(i,:) = a + x01 * ( b - a );
        case 4 %Uniform distribution
            z1=normcdf(z);
            a = marg(i,4); %left bound
            b = marg(i,5); %right bound
            x(i,:) = a + (b-a) *z1(i,:);
        case 5 %Truncated normal marginal distribution
            %need to be further checked!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
            mean = marg(i,2);
            stdv = marg(i,3);
            xmin = marg(i,4);
            xmax = marg(i,5);
%             x(i,:) = mean + stdv * inv_norm_cdf( ...
%                        ferum_cdf(1,(xmin-mean)/stdv,0,1) + ...
%                        (ferum_cdf(1,(xmax-mean)/stdv,0,1)-ferum_cdf(1,(xmin-mean)/stdv,0,1)) * ferum_cdf(1,z(i,:),0,1) ...
%                                               );
            x(i,:)=mean+stdv*norminv(normcdf((xmin-mean)/stdv)+(normcdf((xmax-mean)/stdv)-normcdf((xmin-mean)/stdv))*normcdf(z(i,:)));
%             Imin = find(x(i,:)<xmin); x(i,Imin) = xmin;
%             Imax = find(x(i,:)>xmax); x(i,Imax) = xmax;
        case 6 %Standard normal distribution
            x(i,:)=z(i,:);
    end
end

%generate data
N=100;
rng('shuffle','twister');
a=1.5*rand;
b_lim=(rand-0.5)*20;
%outlier ratio  y=a*-10+b  10a+b

r=0;
num_outlier=N*r;
noise=(rand(N-num_outlier,1)-0.5)/5;
x=(rand(N-num_outlier,1)-0.5)*20;
y=a*x+b_lim+noise;%-13->-3
x_outlier=(rand(num_outlier,1)-0.5)*20;
y_outliers=rand(num_outlier,1)*15*a+b_lim;
x=[x;x_outlier];
y=[y;y_outliers];
x_syn=linspace(-10,10);
y_syn=a*x_syn+b_lim;
%IRLS,initial parameters
parameter_old=[0;0];
parameter_new=[1;1];
X=[x,ones(100,1)];
W=eye(100);
while norm(parameter_new-parameter_old)>=0.001
    %update parameter
    parameter_old=parameter_new;
    parameter_new=(X'*W*X)\(X'*W*y);
    W=diag(0.5*(y-X*parameter_new).^-1);
end
y_irls=X*parameter_new;

%---------------------L1-------------------------------%

%min[0,0,1.....1]*[m;n;t1;.....tn]
%Ax<=b            [-X -I][p;t]<=-y    [X -I][p;t]<=y
%A=[X 1;X -1]   b=[y;y]
f_lim=[0;0;ones(100,1)];
A_lim=[-X,-eye(100);X,-eye(100)];
b_lim=[-y;y];
xlm_solution=linprog(f_lim,A_lim,b_lim);
y_L1=X*xlm_solution(1:2);

%---------------------L?-------------------------------%

%min[0,0,1]*[m;n;t]
%Ax<=b            [X -1][p;t]<=y    [-X -1][p;t]<=-y
%A=[X 1;X -1]   b=[y;y]
f_lim=[0;0;1];
A_lim=[X,-ones(100,1);-X,-ones(100,1)];
b_lim=[y;-y];
xlm_solution=linprog(f_lim,A_lim,b_lim);
y_lim=X*xlm_solution(1:2);







plot(x,y,'ob',x_syn,y_syn,'g',x,y_irls,'r',x,y_L1,'b',x,y_lim,'y');
legend('points','Synth. model','irls model','LP-L1','LP-Linf','Location','northwest')




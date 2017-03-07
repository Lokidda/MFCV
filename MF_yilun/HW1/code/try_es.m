rsc_run=1000;
N=100;          %number of points
sample_size=3;  %3 for circle
p=0.99;         %success rate



%--------------------------epsilon=0.05--------------------------%
epsilon=0.7;
nb_inlier_opt=0;
num_outlier=N*epsilon;
num_inlier=N-num_outlier;
tau=0.1;
points_best=zeros(2,N);
rng('shuffle','twister');
points=generateData2(tau,num_outlier,num_inlier);
[nb_inlier,x_r,y_r,radius]=exhaustive_search(N,sample_size,points,tau);

%plot points
theta=linspace(0,2*pi);
x_rans=radius*cos(theta)+x_r;
y_rans=radius*sin(theta)+y_r;
plot(points(1,1:num_inlier),points(2,1:num_inlier),'or',points(1,num_inlier+1:100),points(2,num_inlier+1:100),'ob',x_rans,y_rans,'k');
axis square;
xlim([-10 10]);
ylim([-10 10]);

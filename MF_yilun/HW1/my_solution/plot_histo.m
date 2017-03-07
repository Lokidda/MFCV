rsc_run=1000;
N=100;          %number of points
sample_size=3;  %3 for circle
p=0.99;         %success rate



%--------------------------epsilon=0.05--------------------------%
epsilon=0.05;
nb_in=zeros(rsc_run,1);
nb_inlier_opt=0;
num_outlier=N*epsilon;
num_inlier=N-num_outlier;
tau=0.1;
ite_num=ceil(log(1-p)/log(1-(1-epsilon)^sample_size));
points_best=zeros(2,N);
for i=1 : rsc_run
   rng('shuffle','twister');
   points=generateData2(tau,num_outlier,num_inlier);
   [nb_in(i),x_r,y_r,radius,inlier_data]=ransac_main(points,ite_num,N,tau);
   if nb_inlier_opt<nb_in(i)
       nb_inlier_opt=nb_in(i);
       points_best=points;
       radius_best=radius;
       center_x_best=x_r;
       center_y_best=y_r;
       inlier_best=inlier_data;
   end
end
%plot histogram
subplot(2,4,1);
histogram(nb_in,100);
xlim([0,100]);
xlabel('nb of detected inliers');
ylabel('nb of experiments');
%plot points
subplot(2,4,5);
theta=linspace(0,2*pi);
x_syn=5*cos(theta);
y_syn=5*sin(theta);
x_rans=radius_best*cos(theta)+x_r;
y_rans=radius_best*sin(theta)+y_r;
plot(points_best(1,:),points_best(2,:),'or',inlier_best(1,:),inlier_best(2,:),'ob',x_rans,y_rans,'k',x_syn,y_syn,'g');
axis square;
xlim([-10 10]);
ylim([-10 10]);
legend('RANSAC outliers','RANSAC inliers','RANSAC model','Synth. model','Location','southoutside');

%--------------------------epsilon=0.2--------------------------%
epsilon=0.2;
nb_in=zeros(rsc_run,1);
nb_inlier_opt=0;
num_outlier=N*epsilon;
num_inlier=N-num_outlier;
tau=0.1;
ite_num=ceil(log(1-p)/log(1-(1-epsilon)^sample_size));
points_best=zeros(2,N);
for i=1 : rsc_run
   rng('shuffle','twister');
   points=generateData2(tau,num_outlier,num_inlier);
   [nb_in(i),x_r,y_r,radius,inlier_data]=ransac_main(points,ite_num,N,tau);
   if nb_inlier_opt<nb_in(i)
       nb_inlier_opt=nb_in(i);
       points_best=points;
       radius_best=radius;
       center_x_best=x_r;
       center_y_best=y_r;
       inlier_best=inlier_data;
   end
end
%plot histogram
subplot(2,4,2);
histogram(nb_in,100);
xlim([0,100]);
xlabel('nb of detected inliers');
ylabel('nb of experiments');
%plot points
subplot(2,4,6);
theta=linspace(0,2*pi);
x_syn=5*cos(theta);
y_syn=5*sin(theta);
x_rans=radius_best*cos(theta)+x_r;
y_rans=radius_best*sin(theta)+y_r;
plot(points_best(1,:),points_best(2,:),'or',inlier_best(1,:),inlier_best(2,:),'ob',x_rans,y_rans,'k',x_syn,y_syn,'g');
axis square;
xlim([-10 10]);
ylim([-10 10]);
legend('RANSAC outliers','RANSAC inliers','RANSAC model','Synth. model','Location','southoutside');

%--------------------------epsilon=0.3--------------------------%
epsilon=0.3;
nb_in=zeros(rsc_run,1);
nb_inlier_opt=0;
num_outlier=N*epsilon;
num_inlier=N-num_outlier;
tau=0.1;
ite_num=ceil(log(1-p)/log(1-(1-epsilon)^sample_size));
points_best=zeros(2,N);
for i=1 : rsc_run
   rng('shuffle','twister');
   points=generateData2(tau,num_outlier,num_inlier);
   [nb_in(i),x_r,y_r,radius,inlier_data]=ransac_main(points,ite_num,N,tau);
   if nb_inlier_opt<nb_in(i)
       nb_inlier_opt=nb_in(i);
       points_best=points;
       radius_best=radius;
       center_x_best=x_r;
       center_y_best=y_r;
       inlier_best=inlier_data;
   end
end
%plot histogram
subplot(2,4,3);
histogram(nb_in,100);
xlim([0,100]);
xlabel('nb of detected inliers');
ylabel('nb of experiments');
%plot points
subplot(2,4,7);
theta=linspace(0,2*pi);
x_syn=5*cos(theta);
y_syn=5*sin(theta);
x_rans=radius_best*cos(theta)+x_r;
y_rans=radius_best*sin(theta)+y_r;
plot(points_best(1,:),points_best(2,:),'or',inlier_best(1,:),inlier_best(2,:),'ob',x_rans,y_rans,'k',x_syn,y_syn,'g');
axis square;
xlim([-10 10]);
ylim([-10 10]);
legend('RANSAC outliers','RANSAC inliers','RANSAC model','Synth. model','Location','southoutside');

%--------------------------epsilon=0.7--------------------------%
epsilon=0.7;
nb_in=zeros(rsc_run,1);
nb_inlier_opt=0;
num_outlier=N*epsilon;
num_inlier=N-num_outlier;
tau=0.1;
ite_num=ceil(log(1-p)/log(1-(1-epsilon)^sample_size));
points_best=zeros(2,N);
for i=1 : rsc_run
   rng('shuffle','twister');
   points=generateData2(tau,num_outlier,num_inlier);
   [nb_in(i),x_r,y_r,radius,inlier_data]=ransac_main(points,ite_num,N,tau);
   if nb_inlier_opt<nb_in(i)
       nb_inlier_opt=nb_in(i);
       points_best=points;
       radius_best=radius;
       center_x_best=x_r;
       center_y_best=y_r;
       inlier_best=inlier_data;
   end
end
%plot histogram
subplot(2,4,4);
histogram(nb_in,100);
xlim([0,100]);
xlabel('nb of detected inliers');
ylabel('nb of experiments');
%plot points
subplot(2,4,8);
theta=linspace(0,2*pi);
x_syn=5*cos(theta);
y_syn=5*sin(theta);
x_rans=radius_best*cos(theta)+x_r;
y_rans=radius_best*sin(theta)+y_r;
plot(points_best(1,:),points_best(2,:),'or',inlier_best(1,:),inlier_best(2,:),'ob',x_rans,y_rans,'k',x_syn,y_syn,'g');
axis square;
xlim([-10 10]);
ylim([-10 10]);
legend('RANSAC outliers','RANSAC inliers','RANSAC model','Synth. model','Location','southoutside');


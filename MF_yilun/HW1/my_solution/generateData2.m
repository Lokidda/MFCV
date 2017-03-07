function points=generateData2(tau,num_outlier,num_inlier)


count_in=0;
inlier=zeros(num_inlier,2);

while count_in<num_inlier
   angle=rand*2*pi;
   xx=5*cos(angle)+(rand-0.5)/5;
   yy=5*sin(angle)+(rand-0.5)/5;
   if abs(norm([xx,yy])-5)<=tau
       count_in=count_in+1;
       inlier(count_in,:)=[xx,yy];
   end
end



count_out=0;
outlier=zeros(num_outlier,2);
while count_out<num_outlier
   xx=(rand-0.5)*20;
   yy=(rand-0.5)*20;
   if abs(norm([xx,yy])-5)>tau
       count_out=count_out+1;
       outlier(count_out,:)=[xx,yy];
   end
end



points=[inlier;outlier]';




%plot(points(1:num_inlier,1),points(1:num_inlier,2),'bo');%plot inlier
%hold on;
%plot(points(num_inlier+1:N,1),points(num_inlier+1:N,2),'ro');%plot outlier
%axis square;
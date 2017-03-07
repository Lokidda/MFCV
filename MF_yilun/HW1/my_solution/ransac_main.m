function [nb_inlier_best,x_r,y_r,radius,inlier_data]=ransac_main(points,ite_num,N,tau)




%plot(points(1:num_inlier,1),points(1:num_inlier,2),'bo');%plot inlier points
%plot(points(num_inlier+1:N,1),points(num_inlier+1:N,2),'ro');%plot outlier
%axis([-10,10,-10,10]);%rescale plot


%initial detected inliers number
nb_inlier_best=0;
%start ransac

for i=1 : ite_num
   samples = datasample(points,3,2);
   x1=samples(1,1);
   y1=samples(2,1);
   x2=samples(1,2);
   y2=samples(2,2);
   x3=samples(1,3);
   y3=samples(2,3);
 %  points=points';
   %fit the circle from 3 points
   A=[1,(x2-x1)/(y2-y1);1,(x3-x1)/(y3-y1)];
   if y2~=y1 && y3~=y1  %Ax=b
       b=[(y1+y2)/2+(x2-x1)*(x2+x1)/(2*(y2-y1));(y1+y3)/2+(x3-x1)*(x3+x1)/(2*(y3-y1))];
       sol=pinv(A)*b;
       %get circle center
       r_y=sol(1);
       r_x=sol(2);      
       %get circle radius
       radius_temp=norm([r_y-y1,r_x-x1]);
     %initial temp
       inlier_temp=zeros(2,0);
     %find inliers
     for j=1 : N    
       x_temp=points(1,j);
       y_temp=points(2,j);
     %judge if error within distance threshold
       if abs(norm([x_temp-r_x,y_temp-r_y])-radius_temp)<=tau
        %  temp_num_in=temp_num_in+1;
          inlier_temp=[inlier_temp,points(:,j)];
       end
     end
     %update best circle model
     if size(inlier_temp,2)>nb_inlier_best
       nb_inlier_best=size(inlier_temp,2);
       x_r=r_x;
       y_r=r_y;
       radius=radius_temp;
       inlier_data=inlier_temp;
     end 
   end
end

%theta=linspace(0,2*pi);
%x=radius*cos(theta)+x_r;
%y=radius*sin(theta)+y_r;
%plot(x,y,'g');
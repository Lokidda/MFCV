function  [nb_inlier_best,x_r,y_r,radius]=exhaustive_search(N,sample_size,points,tau)
    
combi=nchoosek(N,sample_size);
combos=combntns(1:N,3);
nb_inlier_best=0;
for i=1 : combi
   x1=points(1,combos(i,1));   
   y1=points(2,combos(i,1));   
   x2=points(1,combos(i,2));   
   y2=points(2,combos(i,2));   
   x3=points(1,combos(i,3));   
   y3=points(2,combos(i,3));   

  
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
       temp_num_in=0;
     %find inliers
     for j=1 : N    
       x_temp=points(1,j);
       y_temp=points(2,j);
     %judge if error within distance threshold
       if abs(norm([x_temp-r_x,y_temp-r_y])-radius_temp)<=tau
         temp_num_in=temp_num_in+1;
       end
     end
     %update best circle model
     if temp_num_in>nb_inlier_best
       nb_inlier_best=temp_num_in;
       x_r=r_x;
       y_r=r_y;
       radius=radius_temp;
     end 
   end
end

list=root;
flag=0;
bounds=zeros(2,0);


while flag==0%if split exits
 flag=1;
 ub_max=0;
 lb_max=0;
 lb_min=inf;
 select_index=0;
 indicator=inf;
 
  for i =1 : size(list,2)
    %update bound
    if(list(i).inlier_ub>ub_max)
        ub_max=list(i).inlier_ub;
    end
    if(list(i).inlier_lb>lb_max)
        lb_max=list(i).inlier_lb;
    end
    if(list(i).inlier_lb<lb_min)
        lb_min=list(i).inlier_lb;
    end
    %select best node
    if list(i).area<indicator
        indicator=list(i).area;
        select_index=i;
    elseif list(i).area==indicator
        if list(select_index).area<list(i).area
           select_index=i; %node with largest ub
        end
    end
  end
  list=addkids(select_index,list,f,A,b,lb,ub,delta_x,delta_y);
  bounds=[bounds,[ub_max;lb_max]];
  
  %check bad node
  for i=1 : size(list,2)
      if(list(i).inlier_ub<lb_min)
          list(i)=[];
      end
  end
  
  
  
  
 
 
 
end


close;
clear;
clc;
%% --------initial-------------------
load('ListInputPoints.mat');
%number of correspondences
n=size(ListInputPoints,1);
delta=3;
Tx_lb=-size(imread('InputLeftImage.png'),2);
Tx_ub=size(imread('InputLeftImage.png'),2);
Ty_lb=-size(imread('InputLeftImage.png'),1);
Ty_ub=size(imread('InputLeftImage.png'),1);
%% ---------f,A,b prepare------------

% x=[T_x,T_y,z,w_x,w_y], max sigma(z)  =>
f=[0;0;ones(n,1);zeros(2*n,1)];
% zi|xi-xi'+Tx|<=zi_delta
% w_ix=zi*Tx
% envolope: _Tx upper bound, Tx_ lower bound
% w_ix>= Tx_ *Zi
% w_ix>= _Tx *Zi +Tx-_Tx
% w_ix<= Tx+ _Tx*Zi -Tx_
% w_ix<= _Tx*Zi       

%initial_delta
delta_x=zeros(n,1);
delta_y=zeros(n,1);
x1=ListInputPoints(:,1);
x2=ListInputPoints(:,3);
y1=ListInputPoints(:,2);
y2=ListInputPoints(:,4);
delta_x=x1-x2;
delta_y=y1-y2;



A1=@(Tx_lb,Tx_ub,Ty_lb,Ty_ub)[zeros(n,2),diag(delta_x)-delta*eye(n),eye(n),zeros(n)];
A2=@(Tx_lb,Tx_ub,Ty_lb,Ty_ub)[zeros(n,2),-diag(delta_x)-delta*eye(n),-eye(n),zeros(n)];
A3=@(Tx_lb,Tx_ub,Ty_lb,Ty_ub)[zeros(n,2),diag(delta_y)-delta*eye(n),zeros(n),eye(n)];
A4=@(Tx_lb,Tx_ub,Ty_lb,Ty_ub)[zeros(n,2),-diag(delta_y)-delta*eye(n),zeros(n),-eye(n)];
A5=@(Tx_lb,Tx_ub,Ty_lb,Ty_ub)[zeros(n,2),Tx_lb*eye(n),-eye(n),zeros(n)];
A6=@(Tx_lb,Tx_ub,Ty_lb,Ty_ub)[zeros(n,2),-Tx_ub*eye(n),eye(n),zeros(n)];
A7=@(Tx_lb,Tx_ub,Ty_lb,Ty_ub)[zeros(n,2),Ty_lb*eye(n),zeros(n),-eye(n)];
A8=@(Tx_lb,Tx_ub,Ty_lb,Ty_ub)[zeros(n,2),-Ty_ub*eye(n),zeros(n),eye(n)];
A9=@(Tx_lb,Tx_ub,Ty_lb,Ty_ub)[ones(n,1),zeros(n,1),Ty_ub*eye(n),-eye(n),zeros(n)];
A10=@(Tx_lb,Tx_ub,Ty_lb,Ty_ub)[-ones(n,1),zeros(n,1),-Ty_lb*eye(n),eye(n),zeros(n)];
A11=@(Tx_lb,Tx_ub,Ty_lb,Ty_ub)[zeros(n,1),ones(n,1),Ty_ub*eye(n),zeros(n),-eye(n)];
A12=@(Tx_lb,Tx_ub,Ty_lb,Ty_ub)[zeros(n,1),-ones(n,1),-Ty_lb*eye(n),zeros(n),eye(n)];
A=@(Tx_lb,Tx_ub,Ty_lb,Ty_ub)[A1(Tx_lb,Tx_ub,Ty_lb,Ty_ub);A2(Tx_lb,Tx_ub,Ty_lb,Ty_ub);A3(Tx_lb,Tx_ub,Ty_lb,Ty_ub);...
    A4(Tx_lb,Tx_ub,Ty_lb,Ty_ub);A5(Tx_lb,Tx_ub,Ty_lb,Ty_ub);A6(Tx_lb,Tx_ub,Ty_lb,Ty_ub);...
    A7(Tx_lb,Tx_ub,Ty_lb,Ty_ub);A8(Tx_lb,Tx_ub,Ty_lb,Ty_ub);A9(Tx_lb,Tx_ub,Ty_lb,Ty_ub);...
    A10(Tx_lb,Tx_ub,Ty_lb,Ty_ub);A11(Tx_lb,Tx_ub,Ty_lb,Ty_ub);A12(Tx_lb,Tx_ub,Ty_lb,Ty_ub)];

b=@(Tx_lb,Tx_ub,Ty_lb,Ty_ub)[zeros(8*n,1);Tx_ub*ones(n,1);-Tx_lb*ones(n,1);Ty_ub*ones(n,1);-Ty_lb*ones(n,1)];

lb=@(Tx_lb,Tx_ub,Ty_lb,Ty_ub)[Tx_lb;Ty_lb;zeros(n,1);-Inf*ones(2*n,1)];
ub=@(Tx_lb,Tx_ub,Ty_lb,Ty_ub)[Tx_ub;Ty_ub;ones(n,1);Inf*ones(2*n,1)];


%nodes space initial
LP_sol=linprog(-f,A(Tx_lb,Tx_ub,Ty_lb,Ty_ub),b(Tx_lb,Tx_ub,Ty_lb,Ty_ub),[],[],lb(Tx_lb,Tx_ub,Ty_lb,Ty_ub),ub(Tx_lb,Tx_ub,Ty_lb,Ty_ub));
inlier_ub=f'*LP_sol;
inlier_lb=sqrt(sum(sum((abs(delta_x+LP_sol(1))<delta).* ((abs(delta_y+LP_sol(2))<delta))')));
plot_bound=[inlier_ub;inlier_lb];
root = struct('Tx_lb',Tx_lb,'Tx_ub',Tx_ub,...
               'Ty_lb',Ty_lb,'Ty_ub',Ty_ub,...
               'inlier_lb',inlier_lb,'inlier_ub',inlier_ub,...
               'Tx_opt',LP_sol(1),'Ty_opt',LP_sol(2),'area',(Tx_ub-Tx_lb)*(Ty_ub-Ty_lb) );


%% ---------------BnB-----------

%split the space,until the upper bound and lower bound converge within a
%specific space T , linprog this space get best T, plot the variations of
%the two bounds at each split space, get rid of the space, within which the
%upper bound of this space is smaller than the lower bound of any one of
%other space

list=root;
bounds=zeros(2,0);
ub_max=100;
lb_max=0;

while  ub_max-lb_max>=1
 % flag=0;
 % for i=1 : size(list,2)
 %     if list(i).inlier_ub-list(i).inlier_lb>1
 %         flag=1;
 %     end
 % end
 % if flag==0
 %     break;
 % end
 %flag=1;
 ub_max=0;
 lb_max=0;
 lb_min=inf;
 select_index=0;
 indicator=inf;
 
  for i = size(list,2):-1:1
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
    if list(i).inlier_ub-list(i).inlier_lb>=1        
      if list(i).area<indicator
        indicator=list(i).area;
        select_index=i;
      elseif list(i).area==indicator
        if list(select_index).inlier_ub<list(i).inlier_ub
           select_index=i; %node with largest ub
        end
      end
     end
  end
  
  
  
  list=addkids(select_index,list,f,A,b,lb,ub,delta_x,delta_y);
  bounds=[bounds,[ub_max;lb_max]];
  
  %check bad node
  for i=size(list,2):-1:1
      if(list(i).inlier_ub<lb_min)
          list(i)=[];
      end
  end
  %deletlist=[];
  %for i=1:size(list,2)
  %    for j=1:size(list,2)
  %        if(list(i).inlier_ub<list(j).inlier_lb)
  %            deletlist=[deletlist,i];
  %        end
  %    end
  %end
  %list(deletlist)=[];
  
  
end




iterations=1:size(bounds,2);
plot(iterations,-bounds(1,:),'b',iterations,-bounds(2,:),'r');



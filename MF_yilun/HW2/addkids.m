function list=addkids(parent_index,list,f,A,b,lb,ub,delta_x,delta_y)
%if bound not converge,then split
Tx_lb=list(parent_index).Tx_lb;
Tx_ub=list(parent_index).Tx_ub;
Ty_lb=list(parent_index).Ty_lb;
Ty_ub=list(parent_index).Ty_ub;
children=split(Tx_lb,Tx_ub,Ty_lb,Ty_ub,f,A,b,lb,ub,delta_x,delta_y);
%delete parent
list(parent_index)=[];
list=[list children];
%if inlier_ub<lb of any other nodes



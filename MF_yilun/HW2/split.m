function children=split(Tx_lb,Tx_ub,Ty_lb,Ty_ub,f,A,b,lb,ub,delta_x,delta_y)
delta=3;
%%split

 if ((Tx_ub-Tx_lb)>=(Ty_ub-Ty_lb))%split x
     %set child1
     Tx_ub1=(Tx_lb+Tx_ub)/2;
     child1_lp=linprog(-f,A(Tx_lb,Tx_ub1,Ty_lb,Ty_ub),b(Tx_lb,Tx_ub1,Ty_lb,Ty_ub),[],[],lb(Tx_lb,Tx_ub1,Ty_lb,Ty_ub),ub(Tx_lb,Tx_ub1,Ty_lb,Ty_ub));
     inlier_ub1=f'*child1_lp;
     Tx_opt1=child1_lp(1);
     Ty_opt1=child1_lp(2);
     inlier_lb1=sum((abs(delta_x+Tx_opt1)<delta).* ((abs(delta_y+Ty_opt1)<delta)));
     node_child1= struct('Tx_lb',Tx_lb,'Tx_ub',Tx_ub1,...
                  'Ty_lb',Ty_lb,'Ty_ub',Ty_ub,...
                  'inlier_lb',inlier_lb1,'inlier_ub',inlier_ub1,...
                  'Tx_opt',Tx_opt1,'Ty_opt',Ty_opt1,'area',(Tx_ub1-Tx_lb)*(Ty_ub-Ty_lb));
     %set child2
     Tx_lb1=(Tx_lb+Tx_ub)/2;
     child2_lp=linprog(-f,A(Tx_lb1,Tx_ub,Ty_lb,Ty_ub),b(Tx_lb1,Tx_ub,Ty_lb,Ty_ub),[],[],lb(Tx_lb1,Tx_ub,Ty_lb,Ty_ub),ub(Tx_lb1,Tx_ub,Ty_lb,Ty_ub));
     inlier_ub2=f'*child2_lp;
     Tx_opt2=child2_lp(1);
     Ty_opt2=child2_lp(2);
     inlier_lb2=sum((abs(delta_x+Tx_opt2)<delta).* ((abs(delta_y+Ty_opt2)<delta)));
     node_child2= struct('Tx_lb',Tx_lb1,'Tx_ub',Tx_ub,...
                  'Ty_lb',Ty_lb,'Ty_ub',Ty_ub,...
                  'inlier_lb',inlier_lb2,'inlier_ub',inlier_ub2,...
                  'Tx_opt',Tx_opt2,'Ty_opt',Ty_opt2,'area',(Tx_ub-Tx_lb1)*(Ty_ub-Ty_lb));
 else
     %set child1
     Ty_ub1=(Ty_lb+Ty_ub)/2;
     child1_lp=linprog(-f,A(Tx_lb,Tx_ub,Ty_lb,Ty_ub1),b(Tx_lb,Tx_ub,Ty_lb,Ty_ub1),[],[],lb(Tx_lb,Tx_ub,Ty_lb,Ty_ub1),ub(Tx_lb,Tx_ub,Ty_lb,Ty_ub1));
     inlier_ub1=f'*child1_lp;
     Tx_opt1=child1_lp(1);
     Ty_opt1=child1_lp(2);
     inlier_lb1=sum((abs(delta_x+Tx_opt1)<delta).* ((abs(delta_y+Ty_opt1)<delta)));
     node_child1= struct('Tx_lb',Tx_lb,'Tx_ub',Tx_ub,...
                  'Ty_lb',Ty_lb,'Ty_ub',Ty_ub1,...
                  'inlier_lb',inlier_lb1,'inlier_ub',inlier_ub1,...
                  'Tx_opt',Tx_opt1,'Ty_opt',Ty_opt1,'area',(Tx_ub-Tx_lb)*(Ty_ub1-Ty_lb) );
    
     %set child2
     Ty_lb1=(Ty_lb+Ty_ub)/2;
     child2_lp=linprog(-f,A(Tx_lb,Tx_ub,Ty_lb1,Ty_ub),b(Tx_lb,Tx_ub,Ty_lb1,Ty_ub),[],[],lb(Tx_lb,Tx_ub,Ty_lb1,Ty_ub),ub(Tx_lb,Tx_ub,Ty_lb1,Ty_ub));
     inlier_ub2=f'*child2_lp;
     Tx_opt2=child2_lp(1);
     Ty_opt2=child2_lp(2);
     inlier_lb2=sum((abs(delta_x+Tx_opt2)<delta).* ((abs(delta_y+Ty_opt2)<delta)));
     node_child2= struct('Tx_lb',Tx_lb,'Tx_ub',Tx_ub,...
                  'Ty_lb',Ty_lb1,'Ty_ub',Ty_ub,...
                  'inlier_lb',inlier_lb2,'inlier_ub',inlier_ub2,...
                  'Tx_opt',Tx_opt2,'Ty_opt',Ty_opt2,'area',(Tx_ub-Tx_lb)*(Ty_ub-Ty_lb1)); 
 end

 children=[node_child1 node_child2];
 
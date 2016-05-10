function b_plane = plane_constrain(lb1,ub1,lb2,ub2,lb3,ub3,Pclosest,Pinit,bound_dir)

Punk1 = [lb1,lb2,lb3];
planeConstr1 = (Pclosest-Punk1)*(Pclosest-Pinit)';
Punk2 = [lb1,ub2,lb3];
planeConstr2 = (Pclosest-Punk2)*(Pclosest-Pinit)';
Punk3 = [ub1,lb2,lb3];
planeConstr3 = (Pclosest-Punk3)*(Pclosest-Pinit)';
Punk4 = [ub1,ub2,lb3];
planeConstr4 = (Pclosest-Punk4)*(Pclosest-Pinit)';
Punk5 = [lb1,lb2,ub3];
planeConstr5 = (Pclosest-Punk5)*(Pclosest-Pinit)';
Punk6 = [lb1,ub2,ub3];
planeConstr6 = (Pclosest-Punk6)*(Pclosest-Pinit)';
Punk7 = [ub1,lb2,ub3];
planeConstr7 = (Pclosest-Punk7)*(Pclosest-Pinit)';
Punk8 = [ub1,ub2,ub3];
planeConstr8 = (Pclosest-Punk8)*(Pclosest-Pinit)';

if (bound_dir*planeConstr1>0) || (bound_dir*planeConstr2>0) || (bound_dir*planeConstr3>0) || (bound_dir*planeConstr4>0) || (bound_dir*planeConstr5>0) || (bound_dir*planeConstr6>0) || (bound_dir*planeConstr7>0) || (bound_dir*planeConstr8>0)
    b_plane = 1;
else
    b_plane = 0;
end
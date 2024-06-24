function C = setVrestKir(x)
    global Vrest
    Vrest=-70;
    dummy=x.t_end; 
    dummy2=x.I_ext;
   
    x.HH.V = Vrest;

    % short simulation 
    x.I_ext=0;
    x.t_end = 100; % ms, length of the simulation 
    x.sim_dt=0.05;

   

    [V, Ca, mech_state,I] = x.integrate;
    
    C=sum(I(1,:));
    x.t_end=dummy;
    x.I_ext=dummy2;
    % set the Kir and Leak current so the cell membran is in rest
    index1=find(contains(x.HH.Children,'Kir'));
    index2=find(contains(x.HH.Children,'Leak'));
  
    if 0<-x.HH.Kir.gbar*(C-I(1,index1))/I(1, index1);

        x.HH.Kir.gbar=-x.HH.Kir.gbar*(C-I(1,index1))/I(1, index1);
       
    else     
         
         x.HH.Leak.gbar=x.HH.Leak.gbar*(C-I(1,index2))/I(1, index2);

    end
     if (x.HH.Kir.gbar<0)
         'kir'
         -x.HH.Kir.gbar*(C-I(1,index1))/I(1, index1)
         x.HH.Kir.gbar
         %pause
        x.HH.Kir.gbar=0;
    end
     if (x.HH.Leak.gbar<0)
         'Leak'
         x.HH.Leak.gbar*(C-I(1,index2))/I(1, index2)
         x.HH.Leak.gbar
         %pause
        x.HH.Leak.gbar=0;
     end
    x.t_end=dummy;
    x.I_ext=dummy2;
    
    
end
   

    function C = ControlCostPlus2(x,~)
    control=0;
    er=0.1;
    
    %load the data from esther control
    M=load(['example traces for DRG model.txt']);
    startI=200;
   
    x.HH.Hscurrent.gbar=x.HH.Hfcurrent.gbar;
    x.HH.KMs.gbar=x.HH.KMf.gbar;
   
    
    %adjust the Kir current 

    for i=1:4
       setVrestKir(x); 
    end
   

    % for pathology index 5 and 6
    if control==1
        V1= M(:,3)*1000-14.3; %14.3 liquid junction
        V2= M(:,4)*1000-14.3;
    else
        V1= M(:,6)*1000-14.3;
        V2= M(:,7)*1000-14.3;
    end
  
    x.closed_loop = true;
    
    % save the second 10 seconds of simulation
    figure(10)
    IntensityI=0.05;
    dum=x.I_ext-x.I_ext(1);
    x.I_ext=(dum/max(dum))*IntensityI;
    x.reset;
    VV1 = x.integrate;
    
    IntensityI=0.1;
    dum=x.I_ext-x.I_ext(1);
    x.I_ext=(dum/max(dum))*IntensityI;
    x.reset;
    VV2 = x.integrate;
    
    %measure behavior
    
    if  (any(isinf(VV1)) || any(isinf(VV2)) ||  any(isnan(VV1)) ||  any(isnan(VV2)))
        C = 1e3;
        figure(8)
        plot(V), hold on
        '*inf nr'
    
    else
    
         figure(88)
        plot(VV1), hold on 
        plot(VV2), hold on 
        xtools.findNSpikes(VV1);
        xtools.findNSpikes(VV2);


     
        % munber of spikes
        C = xtools.binCost([xtools.findNSpikes(V1)*(1-er) xtools.findNSpikes(V1)*(1+er)],xtools.findNSpikes(VV1));
        C = C+xtools.binCost([xtools.findNSpikes(V2)*(1-er) xtools.findNSpikes(V2)*(1+er)],xtools.findNSpikes(VV2));
        
        % spike timing 
        %low intensity
        D=0;
        n1= xtools.findNSpikes(V1);
        n2= xtools.findNSpikes(VV1);
        temp1=xtools.findNSpikeTimes(V1,n1,0);
        temp2=xtools.findNSpikeTimes(VV1,n2,0);
        
       
        % figure(44)
        % plot(V1), hold on
        % plot(temp1(1)+startI-50, V1(temp1(1)), '*'), hold on
        % figure(44)
        % plot(VV1), hold on
        % plot(temp2(1), VV1(temp2(1)), '*'), hold on

        if min([n1,n2])>0
        for i=1:min([n1 n2])
            D = D+abs(temp1(i)*x.sim_dt+startI-50- temp2(i)*x.sim_dt);
    
        end
        end
         
        nn1= xtools.findNSpikes(V2);
        nn2= xtools.findNSpikes(VV2);
        temp1=xtools.findNSpikeTimes(V2,nn1,0);
        temp2=xtools.findNSpikeTimes(VV2,nn2,0);
      
        if min([nn1,nn2])>0
        for i=1:min([nn1 nn2])
        D = D+abs(temp1(i)*x.sim_dt+startI-50- temp2(i)*x.sim_dt);
        end
        end
        C=C+0.01*D/(n1+nn1);
        if ((xtools.findNSpikes(VV1) + xtools.findNSpikes(VV2))<3)
            C = 1e3;
      
        end
    
    end
    % safety -- if something goes wrong, return a large cost
    if isnan(C)
        C = 1e3; %1e3 = worst value 
    end
    C
    
    end % function


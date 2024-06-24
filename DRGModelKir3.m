    clear
    clear global variable.
    


    for ij=1:1 %funktion für loop 1:10
    tic
    
    addpath(pwd)

    % Add the toolbox 
    x = xolotl;
    %GS= [1.2100    0.0018    2.6082]*1000
    %Set the parameters 
    control=0;  % 1 if control and 0 if pathaology. please also chang in cost function 
    %factor=10; %control
    factor=1 %pathology
    %f2=5
    Iter=1000; % number of iterations (wiederholungen)
    % start conductance
    %CondS=[2.5377*factor*1 2.5377*factor*1 12.7555*factor*1 6.9733*factor*6 6.9733*factor*6 18*factor*1 1 1 242*factor*1 0.0948*factor 106*factor*1]; % richtige reigenfolge 
    %CondS=1.0e+03 *[0.1014*factor*1 0.1014*factor*1 0.4915*factor*1 0.0919*factor*1.0 0.0919*factor*1.0 0.0463*factor*1 0.0010 0.0010 7.2446*factor*1 0.0005*factor 2.6176*factor*1];
    CondS=1.0e+03 *[0.1015*factor*1 0.1015*factor*1 0.0319*factor*1 0.0697*factor*1.0 0.0697*factor*1.0 0.0450*factor*1 0.0010 0.0010 3.4891*factor*1 0.0002*factor 0.2650*factor*1];


    x.t_end = 1500; % ms, length of the simulation 
    x.sim_dt=0.05; % ms, time step for the calculations
    x.dt=0.05;  % ms, time step for output
    startI=200; %ms, when the stiumulus should start 
    durI=500; %ms, length of the stimulus
    diameter=20;% mym

    %bounderies for the conduction values during optimization 
    L=0.25; %gleich lassen 
    U=4; %bis max.10 
    Area=(pi*(0.5*diameter*10^-6)^2)*(10^6);   
    
    % Add the ion channels 
    x.add('compartment', 'HH','A', Area); % (mm2)
    x.HH.add('dzw/Hfcurrent', 'gbar', CondS(1));
    x.HH.add('dzw/Hscurrent', 'gbar', CondS(2));
    x.HH.add('dzw/KAa', 'gbar', CondS(3));
    x.HH.add('dzw/KMf', 'gbar', CondS(4)); 
    x.HH.add('dzw/KMs', 'gbar', CondS(5)); 
    x.HH.add('dzw/Kdr', 'gbar', CondS(6));
    x.HH.add('amarillo/Kir.hpp', 'gbar', CondS(7)); 
    x.HH.add('Leak', 'gbar', CondS(8));
    x.HH.add('dzw/NaV18', 'gbar', CondS(9)); 
    x.HH.add('dzw/NaV19', 'gbar', CondS(10));
    x.HH.add('dzw/Nav17', 'gbar', CondS(11));
    x.HH.Kir.E=-80;
    x.HH.Leak.E=-60;
    x.HH.Cm=1;
    
    % calculate the resting membrane current 
    for i=1:4
        setVrestKir(x);
    end
    
    % set the stimulus 
     IntensityI=0.05; % intensity of the stimulus (nA) (0.050	0.1) from Esther
     nSteps = x.t_end/x.sim_dt;
     I_ext = zeros(nSteps, 1);
     I_ext(:, 1) = [zeros(startI/x.sim_dt,1); ones(durI/x.sim_dt,1); zeros(nSteps-((startI+durI)/x.sim_dt),1) ];
     x.I_ext = IntensityI*I_ext;
    
    % create a parallel pool using default options
    gcp('nocreate');
    % create the xfit object
    p = xfit('particleswarm');
    % tell xfit which xolotl object to use
    p.x = x;
    % tell xfit to simulate in parallel
    p.options.UseParallel = true;
    %p.SimFcn = @ControlCostPlus
    p.SimFcn = @ControlCostPlus2;
    p.options.SwarmSize=50 %set SwarmSize
    p.options.SelfAdjustmentWeight=15.0000
    p.options.SocialAdjustmentWeight=15.0000

    %set the optimization parameters for the PSO. The leak and Kir not
    %included
    NrIonChannels=size(x.HH.Children);
    
    ii=1;
    for i=1:NrIonChannels(2)
        
        if  1>( isequal(x.HH.Children{1,i},'Hscurrent')+ isequal(x.HH.Children{1,i},'KMs'))
            %+isequal(x.HH.Children{1,i},'Leak'))
               %+isequal(x.HH.Children{1,i},'Kir'))
         p.lb(ii) =CondS(i)*L;
         p.ub(ii) = CondS(i)*U; 
          if (isequal(x.HH.Children{1,i},'Leak')==1)
             p.lb(ii)=CondS(i)*0.9999;
             p.ub(ii)=CondS(i)*1.000001;
          end
         if (isequal(x.HH.Children{1,i},'Kir')==1)
             p.lb(ii)=CondS(i)*0.9999;
             p.ub(ii)=CondS(i)*1.000001;
         end
         p.FitParameters{ii,1}=['HH.' x.HH.Children{1,i} '.gbar'];
         ii=ii+1;
                     
        end
       
    end 
    
   
    p.options.MaxIterations=Iter; %max time 
    % runs the optimization 
    p.fit;

    % generates the figures 
    generateFigure(x,control,CondS, p.seed, startI, durI, p);
    save([num2str(ij) '_test.mat'])
    toc
    end


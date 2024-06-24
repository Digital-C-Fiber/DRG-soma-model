function generateFigure(x,control,CondStart, CondEnd, startI, durI, p) 
global Vrest
% load Esthers data
M=load(['example traces for DRG model.txt']);

% Convert so the length of the vectros for p.seed and Cond s are the same 
[NewCondS, NewCondEnd]=convertCondStoopt(x,p,CondStart,CondEnd)

% generate the figure before figure to the optimization 
figure(1)
IntensityI=0.05; % intensity of the stimulus (nA) (0.050	0.1) from Esther
nSteps = x.t_end/x.sim_dt;
I_ext = zeros(nSteps, 1);
I_ext(:, 1) = [zeros(startI/x.sim_dt,1); ones(durI/x.sim_dt,1); zeros(nSteps-((startI+durI)/x.sim_dt),1) ];
x.I_ext = IntensityI*I_ext
x.reset;
x.HH.V = Vrest

x.set('*gbar', CondStart);
% calculate the resting membrane current 
for i=1:4
setVrestKir(x) 
end
[V, Ca, mech_state,I] = x.integrate;

xT=0:x.sim_dt:(x.t_end-x.sim_dt); % time vector
subplot(3,2,1) 
plot(xT,V, 'r'), hold on 
title('Before optimization voltage')
IntensityI=0.1 
dum=x.I_ext-x.I_ext(1);
x.I_ext=(dum/max(dum))*IntensityI
x.reset;
x.HH.V = Vrest;
V = x.integrate;
subplot(3,2,3) 
plot(xT,V,'r'), hold on 
title('Before optimization voltage')
subplot(3,2,5) 
for i=1:length(I(1,:))

plot(xT,I(:,i)), hold on 
end
legend('Hf', 'Hs','Ka','KMf', 'KMs', 'Kdr', 'kir','Leak', 'NaV18', 'NaV19', 'Nav17')
title('Before optimization currents')


 % after optimization 
 %Run a new simulation with the optimal parameters 

x.set('*gbar', NewCondEnd);

for i=1:4
setVrestKir(x) 
end

IntensityI=0.05;
dum=x.I_ext-x.I_ext(1);
x.I_ext=(dum/max(dum))*IntensityI;
x.HH.V = Vrest
[V, Ca, mech_state,I] = x.integrate;

% generate the figure for the results 
subplot(3,2,2) 
plot(xT,V, 'r'), hold on 
if control==1
    subplot(3,2,2)
plot(startI-50+M(:,1)*10^-3,M(:,3)*1000-14.3, 'k'), hold on 
subplot(3,2,4) 
plot(startI-50+M(:,1)*10^-3,M(:,4)*1000-14.3, 'k'), hold on 
else 
    subplot(3,2,2)
    plot(startI-50+M(:,1)*10^-3,M(:,6)*1000-14.3, 'k'), hold on 
    subplot(3,2,4)
plot(startI-50+M(:,1)*10^-3,M(:,7)*1000-14.3, 'k'), hold on 
end
legend('in silico model', 'Experimental data')
title('After optimization voltage')


IntensityI=0.1; 
dum=x.I_ext-x.I_ext(1);
x.I_ext=(dum/max(dum))*IntensityI;
x.HH.V = Vrest
V = x.integrate;
subplot(3,2,4) 
plot(xT,V, 'r'), hold on 
legend('in silico model', 'Experimental data')

title('After optimization voltage')
 
if control==1
    subplot(3,2,1)
plot(startI-50+M(:,1)*10^-3,M(:,3)*1000-14.3, 'k'), hold on 
legend('in silico model', 'Experimental data')

subplot(3,2,3) 
plot(startI-50+M(:,1)*10^-3,M(:,4)*1000-14.3, 'k'), hold on 
legend('in silico model', 'Experimental data')

else 
    subplot(3,2,1)
    plot(startI-50+M(:,1)*10^-3,M(:,6)*1000-14.3, 'k'), hold on 
    subplot(3,2,3)
plot(startI-50+M(:,1)*10^-3,M(:,7)*1000-14.3, 'k'), hold on 
legend('in silico model', 'Experimental data')

end
subplot(3,2,6) 
for i=1:length(I(1,:))
plot(xT,I(:,i)), hold on 
end
legend('Hf', 'Hs','Ka','KMf', 'KMs' ,'Kdr','kir','Leak', 'NaV18', 'NaV19', 'Nav17')

title('After optimization currents')



% generate a new figure for the optimal solution 
 figure(2)
 subplot(1,2,1)
 plot(100*CondEnd./NewCondS), hold on 
 xlabel('Hfcurrent KAa KM Kdr Nav1.8 Nav1.9 Nav1.7')
 ylabel('Change (%)')
 title('The new conductances')
 subplot(1,2,2)
 plot(p.best_cost(1:10))

 % figure(3)
 % x.plot 
 % x.manipulate('Na*.gbar')
 % x.I_ext = IntensityI

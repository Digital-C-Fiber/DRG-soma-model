function  [NewCondS, NewcondEnd]=convertCondStoopt(x,p,CondS,CondEnd)
NrIonChannels=size(x.HH.Children);
NewCondS=[];
NewcondEnd=ones(size(CondS));
ii=1;
for i=1:NrIonChannels(2)  
    if isequal(['HH.' x.HH.Children{1,i} '.gbar'], p.FitParameters{ii});
       NewCondS=[NewCondS CondS(i)];
       NewcondEnd(i)=CondEnd(ii)
       ii=ii+1;
       
    else
        if (isequal([x.HH.Children{1,i}],'Hscurrent'))
          NewcondEnd(i)=CondEnd(ii)
        end 

         if (isequal([x.HH.Children{1,i}],'KMs'))
          NewcondEnd(i)=CondEnd(ii)
        end 
    end
    

end;




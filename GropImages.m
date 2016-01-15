function [ otvet ] = myObrazGroup(viborka)
pogrMax=0;
lenInitial=length(viborka(1,:));
for i=1:lenInitial
    indexesRest(i)=i;
end
indexesMatch=0;
indexesNotMatch=0;
indexesToFinal=0;
indexesToFinalRest=0;
indexesFinal=0;
zzz=0;
while indexesRest;
    zzz=zzz+1;
    len = length(indexesRest);
    for i=1:len
        e=viborka(:,indexesRest(i));
        current=indexesRest(i);
        for j=1:len
            q=viborka(:,indexesRest(j));
            if zzz<2
                pogr(indexesRest(i),indexesRest(j))=abs(sum((e-q)./e))./length(e);            
            end
            if pogr(indexesRest(i),indexesRest(j))<=pogrMax
                if indexesMatch
                    massLen=length(indexesMatch)+1;
                    indexesMatch(massLen)=indexesRest(j);
                else
                    indexesMatch=indexesRest(j);
                end
            else
                if indexesNotMatch==0
                    indexesNotMatch=indexesRest(j);
                else
                    massLen=length(indexesNotMatch)+1;
                    indexesNotMatch(massLen)=indexesRest(j);
                end
            end
        end  
        
        if length(indexesMatch)>=length(indexesToFinal)
            indexesToFinal=indexesMatch;
            indexesToFinalRest=indexesNotMatch;
        end
        indexesMatch=0;
        indexesNotMatch=0;
    end
    if length(indexesToFinal)/length(indexesRest)<0.2
        pogrMax=pogrMax+0.01;
    elseif length(indexesRest) > 1 && length(indexesToFinal)<2
        pogrMax=pogrMax+0.01;
    else
        indexesRest=indexesToFinalRest;
        if indexesFinal
            indexesFinal = [indexesFinal,indexesToFinal];
        else
            indexesFinal = indexesToFinal;
        end
        indexesToFinal=0;
    end
end
otvet = [indexesFinal];

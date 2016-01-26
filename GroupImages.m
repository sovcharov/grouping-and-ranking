function [ otvet ] = GroupImages(viborka)
pogrMax=0; %max average deviation at the time... intitally = 0 (max possible average relative error)
lenInitial=length(viborka(1,:));
for i=1:lenInitial
    indexesRest(i)=i;%this array contains indexes of remaining images to be grouped and ranged
end
indexesMatch=0; %indexes that fit current pogrMax
indexesNotMatch=0; %indexes that do not fit current pogrMax
indexesToFinal=0; %current group of indexes that may go to final array 
indexesToFinalRest=0; %current group of remaining indexes that will be again split into groups
indexesFinal=0; %final array where grouped indexes of images should be placed
percentsOfSize = 20; % at least THAT MANY percents of remaining (not grouped) images qty size of the new candidate group should take   
zzz=0;%variable that prevents from recountig of average relative errors...

%lets count matrix of all average relative errors and put them into matrix
len = length(indexesRest);
for i=1:len
    e=viborka(:,indexesRest(i));%current image 'e' that will be compared with other remaining images
    %current=indexesRest(i);%index of current image, turns out no neede
    for j=1:len
        q=viborka(:,indexesRest(j));%next image 'q' to be compared with current 'e'
        pogr(indexesRest(i),indexesRest(j))=sum(abs((e-q)./e))./length(e); %average relative error for 'e' compared to each image 'q'     
    end
end

%now loop and group indexes
while indexesRest;
    len = length(indexesRest);
    for i=1:len
        for j=1:len
            if pogr(indexesRest(i),indexesRest(j))<=pogrMax %if fits to current max possible error - then index of 'q' goes to group
                if indexesMatch
                    massLen=length(indexesMatch)+1;
                    indexesMatch(massLen)=indexesRest(j);
                else
                    indexesMatch=indexesRest(j);
                end
            else % if not - then then index of 'q' is not goeing to group
                if indexesNotMatch==0
                    indexesNotMatch=indexesRest(j);
                else
                    massLen=length(indexesNotMatch)+1;
                    indexesNotMatch(massLen)=indexesRest(j);
                end
            end
        end
        
        %now compare if current image 'q' got more images 'q' in group then
        %such previous 'q' that got more images in group then any other
        %previous 'q'
        %so if current 'q' got more, then we rewrite indexes of images that will go to final
        %array where grouped indexes will be placed in order
        if length(indexesMatch)>=length(indexesToFinal)
            indexesToFinal=indexesMatch;
            indexesToFinalRest=indexesNotMatch;
        end
        indexesMatch=0;
        indexesNotMatch=0;
    end
    %now let's check if the group we got is effective one... this group
    %should have size of at least 20% of remaining (not grouped) images
    %if group size is less then 20% of remaining images then we increase
    %max possible average relative error and group again remaining images
    %trying to get bigger group
    %otherwise we add group to final array
    if length(indexesToFinal)/length(indexesRest)<(percentsOfSize/100)
        pogrMax=pogrMax+0.01;
    elseif length(indexesRest) > 1 && length(indexesToFinal)<2
        pogrMax=pogrMax+0.01;
    else
        indexesRest=indexesToFinalRest;
        if indexesFinal
            indexesFinal = [indexesFinal,indexesToFinal];
            %indexesFinal2= [indexesFinal2,indexesToFinal,99999]; %this is a test         
        else
            indexesFinal = indexesToFinal;
            %indexesFinal2 = [indexesToFinal,99999]; %this is a test
        end
        indexesToFinal=0;
    end
end
otvet = [indexesFinal];

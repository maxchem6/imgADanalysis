function results=peakAnalysis(filtMat,i,timeVec10,ssimall,dPoint,calibCurr,currMinBound,c)
%Analyze and verify the peak and collected as a table
%Code was written by Pumidech Puthongkham, pp6wr@virginia.edu



if size(timeVec10)==0  %check if there is seed, if not just put zero and done.
    results=[i 0 0 0 0 0 0 0 0 0];
else
    %create data table
    results=zeros(length(timeVec10),10);

    %consider only primary anodic peak current-time trace
    
    itsmooth=mean(filtMat(dPoint-2:dPoint+2,:));   %%%%
     
    indlocold=0; SNcut=0; wold=0; %initialize for compare 1st seed
    for j=1:length(timeVec10)
        indseed=timeVec10(j);
        tseed=indseed/10;
        
        if indseed<=indlocold+0.8*wold 
            %indseed=indlocold+round(wold);
            results(j,1:9)=[i tseed ssimall(j) 0 0 0 0 0 0];
        
        else   
            if indseed <= 10
                itsmooth=itsmooth-min([itsmooth(1:indseed+37) 0]);
                [curr,indloc,w,~]=findpeaks(itsmooth(1:indseed+37),'WidthReference','halfheight','MinPeakHeight',currMinBound,'MinPeakWidth',2,'NPeaks',1);
                curr=curr-min(itsmooth(1:indloc));
            
            elseif indseed <=c-37
                itsmooth=itsmooth-min([itsmooth(indseed-10:indseed+37) 0]);
                [curr,indloc,w,~]=findpeaks(itsmooth(indseed-1:indseed+37),'WidthReference','halfheight','MinPeakHeight',currMinBound,'MinPeakWidth',2,'NPeaks',1);
                curr=curr-min(itsmooth(indseed-4:indloc+indseed));   
                indloc=(indloc+indseed-2);
            else
                itsmooth=itsmooth-min([itsmooth(indseed-10:c) 0]);            
                [curr,indloc,w,~]=findpeaks(itsmooth(indseed-1:c),'WidthReference','halfheight','MinPeakHeight',currMinBound,'MinPeakWidth',2,'NPeaks',1);
                curr=curr-min(itsmooth(indseed-4:c));   
                indloc=(indloc+indseed-2);
            end
            if size(curr)==1
                if indloc-indseed > w
                    if indseed <= 10
                        itsmooth=itsmooth-min([itsmooth(1:indseed+18) 0]);
                        [curr,indloc,w,~]=findpeaks(itsmooth(1:indseed+18),'WidthReference','halfheight','MinPeakHeight',currMinBound,'MinPeakWidth',2,'NPeaks',1);
                        curr=curr-min(itsmooth(1:indloc));
            
                    elseif indseed <=c-18
                        itsmooth=itsmooth-min([itsmooth(indseed-10:indseed+18) 0]);
                        [curr,indloc,w,~]=findpeaks(itsmooth(indseed-1:indseed+18),'WidthReference','halfheight','MinPeakHeight',currMinBound,'MinPeakWidth',2,'NPeaks',1);
                        curr=curr-min(itsmooth(indseed-4:indloc+indseed));   
                        indloc=(indloc+indseed-2);
                    else
                        itsmooth=itsmooth-min([itsmooth(indseed-10:c) 0]);            
                        [curr,indloc,w,~]=findpeaks(itsmooth(indseed-1:c),'WidthReference','halfheight','MinPeakHeight',currMinBound,'MinPeakWidth',2,'NPeaks',1);
                        curr=curr-min(itsmooth(indseed-4:c));   
                        indloc=(indloc+indseed-2);
                    end 
                
                
                end
            end  
            if(size(indloc)==[1 0])
                results(j,1:9)=[i tseed ssimall(j) 0 0 0 0 0 0];
                indloc=0;indseed=0;curr=0;
            else        
                tloc=indloc/10;
                tw=w/10;
                SNcut=0;
                if(curr>= currMinBound)
                    SNcut=1;
                    indlocold=indloc;
                    wold=w;
                end
                conc=curr/calibCurr;
                results(j,1:9)=[i tseed ssimall(j) tloc curr conc tw currMinBound SNcut];
            end
            
        end
        
        
            
        


    end
end
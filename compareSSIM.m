function [timeVec10,ssimall]=compareSSIM(filtMat,modelADn,c,sizeModel)
%compare FSCV color plot with model by sliding window SSIM, then give the possible peak time
%Code was written by Pumidech Puthongkham, pp6wr@virginia.edu

%% Initializing variables
col=floor(c/2)-8;

cutMat=filtMat(275:2:650,1:2:c);
xlocall=zeros(0,0);    
ssimall=zeros(0,0);

coeff=ones(188,9);
coeff(45:85,4:9)=6;
coeff(86:160,2:8)=1.5;

%coeff=ones(188,9);
%coeff(50:80,4:9)=6;
%coeff(81:135,2:8)=1.5;
%% Sliding window for each model to the data
for m=1:sizeModel
    simModel=zeros(1,col);
    for k=1:col
        matCompare=cutMat(:,k:k+8);
        matCompare=matCompare./max(max(matCompare));
        [~,smap]=ssim(matCompare,modelADn{m});
        val=smap.*coeff;
        %simModel(k)=sum(val,'All')/2814.5;
        simModel(k)=sum(val,'All')/3184.5;
    end
    [ssimpeak,xloc,~,~]=findpeaks(simModel,'MinPeakHeight',0.5,'MinPeakDistance',5); %set SSIM cutoff here
    xlocall=[xlocall xloc];    
    ssimall=[ssimall ssimpeak];
end

%% Clean up library
if sizeModel==15
    xlocall=[xlocall xlocall+1];
    ssimall=[ssimall ssimall];
    repxloc = find(accumarray(xlocall.', ones(size(xlocall)))>1);
    timeVec10=(repxloc.*2-1);
    timeVec10=uniquetol(timeVec10,4.9,'DataScale',1);
    [timeVec10,ind,~]=intersect(xlocall.*2-1,timeVec10);  
else
    timeVec10=(xlocall.*2-1)';  %convert back to time*10
    [timeVec10,ind,~]=uniquetol(timeVec10,4.9,'DataScale',1);  %delete repeated peak time
end
ssimall=ssimall(ind);

end
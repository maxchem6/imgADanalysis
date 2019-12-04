function []=imageFSCVAnalysis2()
%analyzes FSCV data for adenosine tranient analysis using an image analysis: structural similiarity index (SSIM).
%Code was written by Pumidech Puthongkham, pp6wr@virginia.edu

clc;
clear;
close all;
warning('off','all')

disp('============================================')
disp('Adenosine 2.0: Image Analysis')
disp('============================================')
pause(1)
choice=0;
while (choice ~= 1 && choice ~= 2)
    prompt0='Enter 1 to make adenosine model from your data, or 2 to use model from the library: ';
    choice=input(prompt0);
end


%% Read calibration data
prompt= 'Enter peak current of 1 uM adenosine calibration (nA): ';
calibCurr=input(prompt);

%% Make adenosine transient models and Find primary peak data point or Use Library

disp('Choose FSCV Color plot files...');
[file,path]=uigetfile('*.txt','Select two or more .hdcv Color files for analysis','MultiSelect','on');

if strcmp(class(file),'char')==1
    totalfile=1;
else
    totalfile=length(file);
end

if choice==1
    [modelADn,dPoint]=makeModel(file,path,totalfile);

    if dPoint < 470 || dPoint > 510   %check adenosine primary peak position
        disp('Unreasonable adenosine primary peak position! Please select new models')
        disp('Program terminated!')
        return
    end
    sizeModel=6;
    disp('Adenosine transient models are created...');
    
elseif choice==2
    load modLib.mat
    disp('Adenosine transient models are loaded...');
    sizeModel=15;
    dPoint=496;
end
pause(1)
%% Identify and Characterize transients from color plots
resultAll=zeros(1,10); 
disp('Data analysis...');
tic
count=0;
for i=1:totalfile
    %load each file
    if(totalfile==1)
        f=fullfile(path,file);
    else
        f=fullfile(path,file{i});
    end
    xyz=load(f);
    disp(['File ',num2str(i),' from ',num2str(totalfile)]);
        
    %background subtraction and smoothing
    [filtMat,r,c]=deDriftandSmooth(xyz);
    %[~,wmin]=min(filtMat(495,:));
    %filtMat=filtMat-filtMat(:,wmin);
    ctime=c/10;
    
    %calculate similarity index and identify preliminary transients
    [timeVec10,ssimall]=compareSSIM(filtMat,modelADn,c,sizeModel);

    %find peak position for only 1st file if using library
    if count==0 && choice==2
        if size(timeVec10)>0
            [~,dPoint,~,~]=findpeaks(filtMat(470:510,timeVec10(1)+5),'SortStr','descend','NPeaks',1);
            if size(dPoint)>0
                dPoint=dPoint+469;
                disp(['dPoint for primary peak is ' num2str(dPoint)]);
                count=1;
            end
        end

    end
    
    %noise level calculation
    currNoise=noiseDet(xyz,dPoint);
    currMinBound=1.33*currNoise;  %Set S/N=1.5 as the LOD in each file
    
    %analyze the preliminary transients
    result=peakAnalysis(filtMat,i,timeVec10,ssimall,dPoint,calibCurr,currMinBound,c);  
    disp(result);
    resultAll=[resultAll; result];
end

%% Result Sorting, Calculate Inter-event time, and Write-Up
resultAll(1,:)=[];
resultPass=resultAll(resultAll(:,9)==1,:);  
%resultFail=resultAll(resultAll(:,9)==0,:);  
%resultNew=[resultPass;resultFail];

cumuTime=(ctime.*(resultPass(:,1)-1))+resultPass(:,4);
diffTime=diff(cumuTime);
resultPass(:,10)=[0;diffTime];
resultTable=array2table(resultPass,'VariableNames',{'File','Seed_s','SSIM','PeakTime_s','Curr_nA','Conc_uM','HalfWidth_s','Noise3_nA','PassSN','InterTime_s'});
repName=sprintf('adenosineResult_%s.xlsx', datestr(now,'yyyy-mm-dd_HHMM'));
writetable(resultTable,repName);
disp('Analysis Complete!');
toc
end
function []=deDrift()
%deDrift use Butterworth filter to correct background drift
%Code is written by Max Puthongkham (pp6wr@virginia.edu) 

warning('off','all')
%File selection UI
[file,path]=uigetfile('*.txt','Choose the .hdcv Color files','MultiSelect','off');
[~,newname,~]=fileparts(file);  %get name of the file
f=fullfile(path,file);
xyz=load(f);
[r,c]=size(xyz); 

%filter the signal by Butterworth Filter (Analyst 2017 142 4317-4321) 
%You can try changing cutoff frequency from 0.03 to something else to
%better detrend your data.
d=designfilt('highpassiir', 'FilterOrder', 2, 'HalfPowerFrequency', 0.03, 'SampleRate', 10, 'DesignMethod', 'butter');

filtPlot=zeros(r,c);
for i=1:r
    filtPlot(i,:)=filtfilt(d,xyz(i,:));
end

colorPlotFSCVmat(filtPlot)
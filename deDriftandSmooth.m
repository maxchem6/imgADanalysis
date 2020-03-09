function [filtPlot,r,c]=deDriftandSmooth(xyz)
%deDrift subtracts background at 1.0 s and use Butterworth filter to correct background drift
%Code was written by Pumidech Puthongkham, pp6wr@virginia.edu

[r,c]=size(xyz); 

%filter the signal by Butterworth Filter (Analyst 2017 142 4317-4321)
d=designfilt('highpassiir', 'FilterOrder', 2, 'HalfPowerFrequency', 0.03, 'SampleRate', 10, 'DesignMethod', 'butter');

filtPlot=zeros(r,c);
for i=1:r
    filtPlot(i,:)=filtfilt(d,xyz(i,:));
    filtPlot(i,:)=smoothdata(filtPlot(i,:),'sgolay',15);
end

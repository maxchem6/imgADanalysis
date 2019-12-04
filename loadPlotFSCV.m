function [r,c,cplotmatrix,newname]=loadPlotFSCV()
%loadPlotFSCV loads .hdcv Color file into numerical .txt for further
%treatment

%Code is written by Pumidech Puthongkham.

%File selection UI
[file,path]=uigetfile('*.txt','Choose the first 5 .hdcv Color files','MultiSelect','on');
[~,newname,~]=fileparts(file{1});  %get name of the file

%Combine 3-min files into the same data matrix
cplotmatrix=zeros(925,1800*length(file));
start=1; last=1800;
for i=1:length(file)
    f=fullfile(path,file(i));
    cplotmatrix(:,start:last)=load(f{1});
    start=start+1800; last=last+1800;
end

%Determine the size (matrix dimension) of color plot
[r,c]=size(cplotmatrix);

end
% function [r,c,cplotmatrix,newname]=loadSinglePlot()
% %loadPlotFSCV loads .hdcv Color file into numerical .txt for further
% %treatment
% 
% %Code is written by Pumidech Puthongkham.
% 
% %File selection UI
% c[file,path]=uigetfile('*.txt','Choose the .hdcv Color files','MultiSelect','off');
% [~,newname,~]=fileparts(file);  %get name of the file
% f=fullfile(path,file);
% cplotmatrix=load(f);
% 
% %Determine the size (matrix dimension) of color plot
% [r,c]=size(cplotmatrix);
% 
% end


%File selection UI
[file,path]=uigetfile('*.txt','Choose the .hdcv Color files','MultiSelect','off');
[~,newname,~]=fileparts(file);  %get name of the file
f=fullfile(path,file);
cpdata=load(f);

%Determine the size (matrix dimension) of color plot
[r,c]=size(cpdata);
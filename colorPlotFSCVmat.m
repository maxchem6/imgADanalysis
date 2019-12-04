function []=colorPlotFSCVmat(xyzmat)
%colorPlotFSCVmat generates a false color plot WITH axis from matlab variable file, then shows the plots

%Code is written by Pumidech Puthongkham.

%Determine the size (matrix dimension) of color plot
[r,c]=size(xyzmat);

%Load conventional false color scheme
load('FSCVmap.mat')                 


%Calculate colorbar max and min 
maxVal=round(max(max(xyzmat)));
minVal=round(maxVal*-2/3,1);
%minVal=-0.7;
%maxVal=1;
% Create axes
figure1=figure;
axes1 = axes('Parent',figure1);
hold(axes1,'on');
% Set the remaining axes properties
% This works only with holding potential -0.4 V, scan rate 400 V/s, and
% 10-Hz frequency.
set(axes1,'XTick',[1   c],'XTickLabel',{'0',num2str(c/10)},'YTick',...
[1 round(r/2) r],'YTickLabel',{'-0.4','1.45','-0.4'},...
'FontName','Arial','FontSize',18);
xlabel('Time (s)')
ylabel('E vs. Ag/AgCl (V)')

axis tight

h=surf(xyzmat);
h.LineStyle='none';

colormap(FSCVmap2)
view(0,90)

caxis([minVal maxVal])
c=colorbar;
c.Label.String='Current (nA)';
c.Ticks=[minVal 0 maxVal];
c.FontSize=18;


end
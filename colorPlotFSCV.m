function []=colorPlotFSCVmat()
%colorPlotFSCV generates false color plot with axis from .hdcv Color.txt file and saves the plots in .tiff.
%Code is written by Max Puthongkham (pp6wr@virginia.edu) and Ryan Borman.

%File selection UI
[file,path]=uigetfile('*.txt','Choose the .hdcv Color files','MultiSelect','off');
[~,newname,~]=fileparts(file);  %get name of the file
f=fullfile(path,file);
xyz=load(f);

%Determine the size (matrix dimension) of color plot
[r,c]=size(xyz);

%Load conventional false color scheme
load('FSCVmap3.mat')                 

%Calculate colorbar max and min 
maxVal=round(max(max(xyz)));     %You can override this by put the number on the RHS instead.
minVal=round(maxVal*-2/3,1);     %You can override this by put the number on the RHS instead.

%Create axes
figure1=figure('Position',[100 100 650 500]);  %You can set figure size by changing last two numbers
axes1 = axes('Parent',figure1);
hold(axes1,'on');

% Set the remaining axes properties: This works only with holding potential -0.4 V, scan rate 400 V/s, and
% 10-Hz frequency. You can override this by changing "-0.4" or "500" or
% "10"
set(axes1,'XTick',[1 c],'XTickLabel',{'0',num2str(c/10)},'YTick',...
    [1 round(r/2) r],'YTickLabel',{'-0.4',-0.4+(r/500),'-0.4'},...
    'FontName','Arial','FontSize',24);  
xlabel('time (s)')
ylabel('E vs. Ag/AgCl (V)')

axis tight

h=surf(xyz);
h.LineStyle='none';

colormap(FSCVmap3)
view(0,90)

caxis([minVal maxVal])
c=colorbar;
c.Label.String='current (nA)';
c.Ticks=[minVal,0,maxVal];
c.FontSize=20;

%Save color plot as a file
name=sprintf('%s.tif',newname);   %.tiff file
%saveas(gcf,name);
set(gcf,'PaperPositionMode','auto')
print(name,'-dtiff','-r300')      %This will save .tiff with 300 dpi, you can change it.

end
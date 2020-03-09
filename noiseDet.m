function currNoise=noiseDet(xyz,dPoint)
%currNoise calculate noise level by Butterworth filter the peaks out

%choose current-time trace
it=xyz(dPoint,:);

%design filter
d=designfilt('highpassiir', 'FilterOrder', 2, 'HalfPowerFrequency', 0.5, 'SampleRate', 10, 'DesignMethod', 'butter');
filtIT=filtfilt(d,it);
filtIT=smoothdata(filtIT,'sgolay',15);

%calculate SD
currNoise=std(filtIT);

end
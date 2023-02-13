clear all; close all; clc;
filepath = 'F:\RecordingData\Recording Data';
fileroad = dir(fullfile(filepath));
for index = 3:187
    sub = index-2;
    if fileroad(index).name(end)=='1'|fileroad(index).name(end)=='2'
        Group{sub} = 'Dyslexia';
    else
        Group{sub} = 'control';
    end
    if fileroad(sub).name(end)=='1'|fileroad(sub).name(end)=='3'
        Gender{sub} = 'male';
    else
        Gender{sub} = 'female';
    end    
    txt = importdata(strcat(filepath,'\',fileroad(index).name,'\A1R.txt'),' ');
    Data = [];
    for i = 2:size(txt,1)
        temp = strsplit(txt{i,1}); Data = [Data;temp];
    end
    Data = cell2table(Data);
    Data.Properties.VariableNames = {'T','LX','LY','RX','RY'};
    T = str2num(char(Data.T));
    LX = str2double(string(char(Data.LX)));
    LY = str2double(string(char(Data.LY)));
    RX = str2double(string(char(Data.RX)));
    RY = str2double(string(char(Data.RY)));
    LX = filloutliers(LX,'linear','movmedian',50);
    LY = filloutliers(LY,'linear','movmedian',50);
    RX = filloutliers(RX,'linear','movmedian',50);
    RY = filloutliers(RY,'linear','movmedian',50);
    X = (LX+RX)/2; Y = (LY+RY)/2;
    Xs = smoothdata(X,'movmedian',5); Ys = smoothdata(Y,'movmedian',5);
    distance = sqrt(diff(Xs).^2+diff(Ys).^2);
    % NVG
    tspan = (100-1):100:(1000-1);
    for j = 1:length(tspan)
        [VG] = fast_NVG(distance(1:tspan(j)),T(1:tspan(j)));
        Adj = full(VG);
        DataMatrix{sub}.Adj{j} = sparse(Adj);
    end
end
save("F:\Data.mat","DataMatrix",'-mat','-v6');
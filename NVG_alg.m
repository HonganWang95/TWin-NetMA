function G=NVG_alg(ts,left,right,G,t)
% Natural visibility algorithm fast based on:
% Lan, X., Mo, H., Chen, S., Liu, Q., & Deng, Y. (2015).
% Fast transformation from time series to visibility graphs.
% Chaos, 25(8), 083105.
% ===============================================================
% Code by: Giovanni Iacobello, Politecnico di Torino (Italy)
% giovanni.iacobello@polito.it
% ===============================================================
%   ts=time series
%   left=first data index
%   right=last data index
%   G=adjacency list (cell array)
%   t=time samples


if left<right
    if var(ts(left:right))~=0 %this check avoids that matlab returns error of infinite recursion for constant time-series
        [~,k]=max(ts(left:right));
        k=k+left-1;
        tsk=ts(k);
        tk=t(k);
        beta=pi; %maximum visibility angle
        for ii=k-1:-1:left
            alfa=atan((ts(ii)-tsk)/(t(ii)-tk));
            if alfa<beta
                G{k}=[G{k};ii];
                beta=alfa;
            end
        end
        beta=-pi; %minimum visibility angle
        for ii=k+1:right
            alfa=atan((ts(ii)-tsk)/(t(ii)-tk));
            if alfa>beta
                G{k}=[G{k};ii];
                beta=alfa;
            end
        end
        G=NVG_alg(ts,left,k-1,G,t);
        G=NVG_alg(ts,k+1,right,G,t);
    else
        for ii=left:right-1
            G{ii}=[G{ii};ii+1]; %add only next node (neighbour) in the series
        end
    end
end

return;
end
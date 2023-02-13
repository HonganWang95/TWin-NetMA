function [VG] = fast_NVG(TS,TT)
% Implementation of natural visibility graph based on:
% Lacasa, L., Luque, B., Ballesteros, F., Luque, J., & Nuno, J. C. (2008).
% From time series to complex networks: The visibility graph.
% PNAS, 105(13), 4972-4975.
% ===============================================================
% Code by: Giovanni Iacobello, Politecnico di Torino (Italy)
% giovanni.iacobello@polito.it
% ===============================================================
% TS: time series (must be a vector)
% TT: time vector (same length od TS)
% VG: sparse adjacency matrix (symmetrical)
%
%%  PRE-PROCESSING CONTROLS
    if isvector(TS)==0 || isvector(TT)==0
        disp('Error size: series and times must be vectors')
        return;
    end
    if length(TS)~=length(TT)
        disp('Error size: series and times must have the same length')
        return;
    end
    if iscolumn(TS)==0
        TS=TS';
    end
    if iscolumn(TT)==0
        TT=TT';
    end
%% RUNNING
    N=size(TS,1);
    B=cell(N,1);
    B=NVG_alg(TS,1,N,B,TT);
    
%% CONVERTING INTO SPARSE MATRIX
    
    Adj_tmp=cell(N,1);
    for ii=1:N
        Adj_tmp{ii}=ones(length(B{ii}),1)*ii;
    end
    target=vertcat(Adj_tmp{:});
    clear A_tmp
    source=vertcat(B{:});
    weight_input=ones(size(target));
    if ~isa(source,'double')
        source=double(source); %"sparse" function requires doubles
    end
    VG=sparse(source,target,weight_input,N,N);
    VG=VG+VG'; %makes adjcency matrix simmetrical

end


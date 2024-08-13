function [pairlist] = buildPairlist(coords,Rmean)
    
    bondlength = Rmean*4.1;
    
    Mdl = ExhaustiveSearcher(coords,'Distance','euclidean');
    Idx = rangesearch(Mdl, coords, bondlength);
    
    T1 = [];
    T2 = [];
    for kk = 1:length(Idx)
        IDX_temp = Idx{kk};
        T2_temp = kk*ones(1,length(IDX_temp));
        T1 = [T1 IDX_temp];
        T2 = [T2 T2_temp];
    end

    %% Make list sparse
    Input = [T1' T2'];
    %Remove excess pairs i.e. (2,3)=(3,2)
    Output = unique(sort(Input,2),'rows');
    %Remove self-pairs i.e. (1,1)
    T = Output(:,1) - Output(:,2);
    Output(T==0,:) = []; 

    T1 = Output(:,1);
    T2 = Output(:,2);
   
    pairlist = [T1 T2];


end
n = 21; %number of factors
files = {'ant-1.7.csv', 'lucene-2.4.csv', 'ivy-2.0.csv', 'xalan-2.7.csv', ...
    'poi-3.0.csv', 'synapse-1.2.csv', 'velocity-1.6.csv', 'jedit-4.3.csv'};

%avgCorr retains average spearman correlation over all datasets
avgCorr = zeros(n,1);
%score retains a score based on the correlation rank over all datasets
score = zeros(n, 1);
for i = 1:length(files)
    csv = importdata(char(files(i)));
    spearman = corr(csv.data);
    avgCorr = avgCorr + spearman(:,n);
    
    %increase the score of the metrics by an amount proportional to their
    %ranking ie first place gets +21 score, second gets +20 score, etc
    [~, idx] = sort(abs(spearman(:,n)), 'descend');
    tempScore = n;
    for j = 1:n
        if (isnan(spearman(idx(j))))
            continue
        end
        score(idx(j)) = score(idx(j)) + tempScore;
        tempScore = tempScore -1;
    end
end

%get topFactors which contains top factors based on score
[~, idx] = sort(score, 'descend');
topFactors = csv.textdata(1,idx+3)'

%get avgCorrFactors which contains top factors based on avg spearman correlation
avgCorr = avgCorr / length(files);
[~, idx] = sort(abs(avgCorr), 'descend');
avgCorrFactors = csv.textdata(1,idx+3)'
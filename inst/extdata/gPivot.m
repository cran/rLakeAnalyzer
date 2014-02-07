function b = gPivot(toPivot,forceUnique)
%GPIVOT Summary of this function goes here
%   Detailed explanation goes here


verCol = 1;
horCol = 2;

if(nargin < 2)
    forceUnique = false;
end


toPivot = sortrows(toPivot,[horCol verCol]);
%Ok, first remove any duplicate rows that are also duplicate values. The
%next check then catches rows with duplicate date/depth fields but not
%duplicate values, that is the most concerning.
toPivot = unique(toPivot,'rows');

if(forceUnique)
    [~,uIndx] = unique(toPivot(:,[horCol verCol]),'rows');
    toPivot = toPivot(uIndx,:);
end

if(size(unique(toPivot(:,[horCol verCol]),'rows'),1) ~= size(toPivot,1))
    error('The two columns being pivoted upon must be completely unique.');
end

colHead = unique(toPivot(:,horCol));
verVals = unique(toPivot(:,verCol));

b = nan(length(verVals)+1,length(colHead)+1);

b(2:end,1) = verVals;
b(1,2:end) = colHead;


for i=2:size(b,2)
    %subset the full dataset where 
    colSet = toPivot(b(1,i)==toPivot(:,horCol),[1 3]);
    indx = 1;
    colSetLen = size(colSet,1);
    for j=2:size(b,1)
        %If the vertical column is equal, great, we've got a match
        if(b(j,1)==colSet(indx,1))
            b(j,i) = colSet(indx,2);
            indx = indx + 1;%we had a match, advance the index
            if(indx > colSetLen)
               break; %Get out of for loop  
            end
        end
    end
end

end


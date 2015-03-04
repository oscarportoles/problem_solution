function [accepted_rejected, bad_channels] = load_editing_template(path, filename, sheets)
file = [path filesep filename];

if nargin < 3
    %Read the sheets' name and keep the sheets that we need  (the ones that
    %start with 'S' and belongs to participants
    [STATUS,sheets] = xlsfinfo(file);
    delete = [];
    for i= 1:length(sheets)
        if ~strcmp(sheets{i}(1),'S')
            delete(end+1) = i;
        end
    end
    sheets(delete) = [];
end
    
%Accepted-Rejected trials information
for i = 1:length(sheets)
    row = str2num(sheets{i}(2:end));
    [num, text,xlsinfo{row}] = xlsread(file,sheets{i},'I10:J153');
end
accepted_rejected = zeros(145, length(sheets));

column = 1;
for i = 1:length(xlsinfo)
    if ~isempty(xlsinfo{i})
        accepted_rejected(1, column) = i;
        p = xlsinfo{i};
        for j=1:length(p)
            if strcmp(p(j,1),'x')
                accepted_rejected(j+1,column) = 1;
            elseif ~strcmp(p(j,1),'x') && ~strcmp(p(j,2),'x')
                accepted_rejected(j+1,column) = -1;
            end
        end
        column = column + 1;
    end
end

%Bad Channel info
for i = 1:length(sheets)
    row = str2num(sheets{i}(2:end));
    [num, text,bc{row}] = xlsread(file,sheets{i},'K10:K153');
end

bad_channels = {};
column = 1;
for i = 1:length(bc)
    if ~isempty(bc{i})
        bad_channels{1, column} = i;
        p = bc{i};
        for j=1:length(p)
            if ~isnan(p{j})
                ch = strsplit((p{j}),',');
                ch_matrix = [];
                for k=1:length(ch)
                    ch_matrix(1,end + 1)=str2num(ch{k});
                end
                bad_channels{j+1, column} = ch_matrix;
            else
                bad_channels{j+1, column} = [];
            end
        end
        column = column + 1;
    end
end



return
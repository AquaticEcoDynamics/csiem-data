clear

%%Needs the import wizard to work
load TableNamesWIRStructered.mat
Names = WIRVarNames(6:end);

VarId = char(zeros(13,8));
for i = 1:13
    VarId(i,:) = ['var00' num2str(354-1+i)]; 
end

for i = 1:13
    
    fprintf('%s,%s,%%,%%,%%,,,N/A,,,Water Quality (Contaminants),\n',VarId(i,:),char(Names(i)));
end


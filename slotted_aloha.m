clc;
clear all;
%%

sensor = 5;
%time
T = 100;
DataSentCount = zeros(1, sensor);
DataRecCount = zeros(1, sensor);
k = zeros(1, sensor);
kmax=15;
b_off = zeros(1,sensor);
%time periods

for t=1:T
    data = rand(1, sensor);
    for i=1:sensor
       if (b_off(i)~=0) 
           data(i)=0;
           b_off(i)=b_off(i)-1;
       end
    end
    Data = data >= 0.5;
    DataSentCount = DataSentCount + Data;
    k = k + Data;
    DataRec = zeros(1, sensor);
    sum=0;
    for i=1:sensor
        if (Data(i)==1)
            sum = sum +1;
        end
    end
    
    if(sum > 1)
        fprintf('Collision Occured !\n');
        [b_off] = Back_off(k, kmax, Data, b_off, sensor);
    elseif(sum == 1)
        fprintf('Transmission Success !\n');
        DataRec = Data;
        DataRecCount = DataRecCount + Data;
    elseif(sum == 0)
        fprintf('No Transmission\n');
    end
    fprintf('--------******--------\n');
end
subplot(2,1,1)
bar(DataSentCount)
subplot(2,1,2)
bar(DataRecCount)
totalsent = 0;
totalrec = 0;
for i = 1:sensor
    totalsent = totalsent+DataSentCount(i);
    totalrec= totalrec+DataRecCount(i);
end
successtransmissionperc=(totalrec/totalsent)*100
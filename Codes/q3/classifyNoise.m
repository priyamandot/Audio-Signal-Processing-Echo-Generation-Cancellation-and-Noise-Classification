function [max_correspond,lag_pressure_sec, c_pressure,lag_waterpump_sec, c_waterpump,lag_ceilingfan_sec, c_ceilingfan,lag_traffic_sec, c_traffic]    = classifyNoise(x,Fs) 

% Load the reference signals
[pressure_ref, fs2] = audioread('pressureaudio.wav');
disp(fs2);
[waterpump_ref, fs3] = audioread('pumpaudio.wav');
disp(fs3);
[ceilingfan_ref, fs4] = audioread('fanaudio.wav');
disp(fs4);
[traffic_ref, fs5] = audioread('trafficaudio.wav');
disp(fs5);

% Cross-correlate the input signal with the reference signals
[c_pressure, lag_pressure] = xcorr(x, mean(pressure_ref, 2));
positive_lag_indices_pressure = find(lag_pressure >= 0);
lag_pressure = lag_pressure(positive_lag_indices_pressure);
c_pressure = c_pressure(positive_lag_indices_pressure);

[c_waterpump, lag_waterpump] = xcorr(x, mean(waterpump_ref, 2));
positive_lag_indices_waterpump = find(lag_waterpump >= 0);
lag_waterpump = lag_waterpump(positive_lag_indices_waterpump);
c_waterpump = c_waterpump(positive_lag_indices_waterpump);

[c_ceilingfan, lag_ceilingfan] = xcorr(x, mean(ceilingfan_ref, 2));
positive_lag_indices_ceilingfan = find(lag_ceilingfan >= 0);
lag_ceilingfan = lag_ceilingfan(positive_lag_indices_ceilingfan);
c_ceilingfan = c_ceilingfan(positive_lag_indices_ceilingfan);

[c_traffic, lag_traffic] = xcorr(x, mean(traffic_ref, 2));
positive_lag_indices_traffic = find(lag_traffic >= 0);
lag_traffic = lag_traffic(positive_lag_indices_traffic);
c_traffic = c_traffic(positive_lag_indices_traffic);

% Scale lag to represent time
lag_pressure_sec = lag_pressure / fs2;
disp(fs2);  
lag_waterpump_sec = lag_waterpump / fs3;
lag_ceilingfan_sec = lag_ceilingfan / fs4;
lag_traffic_sec = lag_traffic / fs5;
 

%threshold values based on max correlation when specific noise present
threshold = [150,500,600,250] ; % pc , wp , cf , tr 
% 
% for k =1: length(lag_waterpump_sec)
% 
%     if(c_waterpump(k)>threshold(2))
% 
%        c_waterpump(k) = c_waterpump(k);
%     else
%        c_waterpump(k) = 0;
%     end
% 
% end              
% 
% 
% for k =1: length(lag_pressure_sec)
% 
%     if(c_pressure(k)>threshold(1))
% 
%         c_pressure(k) = c_pressure(k);
%     else
%         c_pressure(k) = 0;
%     end
% 
% end
% 
% 
% for k =1: length(lag_ceilingfan_sec)
% 
%     if(c_ceilingfan(k)>threshold(3))
% 
%        c_ceilingfan(k) = c_ceilingfan(k);
%     else
%        c_ceilingfan(k) = 0;
%     end
% 
% end
% 
% 
% 
% for k =1: length(lag_traffic_sec)
% 
%     if(c_traffic(k)>threshold(4))
% 
%        c_traffic(k) = c_traffic(k);
%     else
%        c_traffic(k) = 0;
%     end
% 
% end

max1 = max(c_pressure);
max2 = max(c_waterpump);
max3 = max(c_ceilingfan);
max4 = max(c_traffic);

max_correspond = [];
index = 1;
maximum = max([max1,max2,max3,max4]);

        if maximum == max1
            max_correspond(index) = 1;
        end
        if maximum == max2
            max_correspond(index) = 2;
        end
        if maximum == max3
            max_correspond(index) = 3;
        end
        if maximum == max4
            max_correspond(index) = 4;
        end

% max_correspond = zeros( round(length(x)/Fs),1);
% index = 1;
% finalmax=0;                                                                    
% factor = (round(length(c_traffic)/(Fs*10)));
% disp(factor);
% for k = 1: round(length(x)/(Fs))
%     start = round(k * factor * Fs);  % Adjust for the correct indexing in seconds
%     finish = round((k + 1) * factor * Fs);
% 
%     finish = min(finish, length(x));
% 
%     pc = c_pressure(start + 1 : finish);
%     wp = c_waterpump(start + 1 : finish);
%     cf = c_ceilingfan(start + 1 : finish);
%     tr = c_traffic(start + 1 : finish);
% 
% 
%     max1 = max(pc);
%     max2 = max(wp);
%     max3 = max(cf);
%     max4 = max(tr);
% 
% 
%     maximum = max([max1,max2,max3,max4]);
%     disp(maximum);
% 
%     finalmax =max(finalmax,maximum);
% 
%     if maximum == 0
%         max_correspond(index) = 0;
%     else
%         if maximum == max1
%             max_correspond(index) = 1;
%         end
%         if maximum == max2
%             max_correspond(index) = 2;
%         end
%         if maximum == max3
%             max_correspond(index) = 3;
%         end
%         if maximum == max4
%             max_correspond(index) = 4;
%         end
% 
% 
%     end
%     index = index +1;
% 
% end



max_correspond = unique(max_correspond);


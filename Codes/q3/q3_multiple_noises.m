%IF THERE ARE MULTIPLE NOISES   IN THE GIVEN FILE 


% Load the input audio containing multiple noises
[x_stereo, Fs] = audioread("pc_ct_combine.wav");


% Convert stereo to mono
x = mean(x_stereo, 2);

t = (0:length(x)-1) / Fs;

% Plot the original signal
figure;

% Subplot 1: Input signal x
subplot(5,1,1);
plot(t, x);
title('Input signal ');


% Load the reference signals
[pressure_ref, fs2] = audioread('pressure-cooker-ref.mp3');
[waterpump_ref, fs3] = audioread('water-pump-ref.wav');
[ceilingfan_ref, fs4] = audioread('ceiling-fan-ref.wav');
[traffic_ref, fs5] = audioread('city-traffic-ref.mp3');

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
lag_waterpump_sec = lag_waterpump / fs3;
lag_ceilingfan_sec = lag_ceilingfan / fs4;
lag_traffic_sec = lag_traffic / fs5;


threshold = [55,120,600,300] ; % pc , wp , cf , tr 

for k =1: length(lag_waterpump_sec)

    if(c_waterpump(k)>threshold(2))

       c_waterpump(k) = c_waterpump(k);
    else
       c_waterpump(k) = 0;
    end

end

subplot(5,1,3);
plot(lag_waterpump_sec, c_waterpump);
title('Cross-correlation with Water Pump Reference');
xlabel('Time Lag (s)');


for k =1: length(lag_pressure_sec)

    if(c_pressure(k)>threshold(1))

        c_pressure(k) = c_pressure(k);
    else
        c_pressure(k) = 0;
    end

end

subplot(5,1,2);
plot(lag_pressure_sec, c_pressure);
title('Cross-correlation with Pressure Cooker Reference');
xlabel('Time Lag (s)');



for k =1: length(lag_ceilingfan_sec)

    if(c_ceilingfan(k)>threshold(3))

       c_ceilingfan(k) = c_ceilingfan(k);
    else
       c_ceilingfan(k) = 0;
    end

end



subplot(5,1,4);
plot(lag_ceilingfan_sec, c_ceilingfan);
title('Cross-correlation with Ceiling Fan Reference');
xlabel('Time Lag (s)');

for k =1: length(lag_traffic_sec)

    if(c_traffic(k)>threshold(4))

       c_traffic(k) = c_traffic(k);
    else
       c_traffic(k) = 0;
    end

end

subplot(5,1,5);
plot(lag_traffic_sec, c_traffic);
title('Cross-correlation with Traffic Reference');
xlabel('Time Lag (s)');

max_correspond = zeros( round(length(x)/(Fs * 10)),1);
index = 1;

for k = 0: round(length(x)/(Fs * 10))
    start = k * 10 * Fs;  % Adjust for the correct indexing in seconds
    finish = (k + 1) * 10 * Fs;

    finish = min(finish, length(x));

    pc = c_pressure(start + 1 : finish);
    wp = c_waterpump(start + 1 : finish);
    cf = c_ceilingfan(start + 1 : finish);
    tr = c_traffic(start + 1 : finish);

   

    max1 = max(pc);
    max2 = max(wp);
    max3 = max(cf);
    max4 = max(tr);

  
    maximum = max([max1,max2,max3,max4]);

    
    if maximum == 0
        max_correspond(index) = 0;
    else
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
    end
    index = index +1;


end

disp("Detected noises :")

max_correspond = unique(max_correspond);

for i = 1:length(max_correspond)
    if max_correspond(i) == 1
        disp("Pressure Cooker");
    end
    if max_correspond(i) == 2
        disp("Water Pump");
    end
    if max_correspond(i) == 3
        disp("Ceiling fan");
    end
    if max_correspond(i) == 4
        disp("Traffic");
    end
end

if length(max_correspond) == 1 && max_correspond(1) == 0
    disp("Unknown");
end




[x, Fs] = loadAudio("music_city-traffic_hp.wav");
[max_correspond,lag_pressure_sec, c_pressure,lag_waterpump_sec, c_waterpump,lag_ceilingfan_sec, c_ceilingfan,lag_traffic_sec, c_traffic]    = classifyNoise(x,Fs); 

t = (0:length(x)-1) / Fs;

figure;
subplot(5,1,1);
plot(t, x);
title('Input signal ');                        

subplot(5,1,2);
plot(lag_pressure_sec, c_pressure);
title('Cross-correlation with Pressure Cooker Reference');
xlabel('Time Lag (s)');

subplot(5,1,3);
plot(lag_waterpump_sec, c_waterpump);
title('Cross-correlation with Water Pump Reference');
xlabel('Time Lag (s)');

subplot(5,1,4);
plot(lag_ceilingfan_sec, c_ceilingfan);
title('Cross-correlation with Ceiling Fan Reference');
xlabel('Time Lag (s)');

subplot(5,1,5);
plot(lag_traffic_sec, c_traffic);
title('Cross-correlation with Traffic Reference');
xlabel('Time Lag (s)');

disp("Detected noises :");

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
[x, Fs] = loadAudio("q1.wav");

distance = input("Enter distance of the wall from the source in meters :");

alpha = 0.5;
[y1,diff] = generateEcho(x,Fs,alpha,distance);

t1 = (0:length(x) - 1) / Fs;
t2 = (0:length(y1) - 1) / Fs;

audiowrite("q1_output.wav",y1,Fs);

figure;
% Plot the original signal
subplot(3,1,1);
stem(t1, x);
title('Original Signal');
xlabel('Time (seconds)');
ylabel('Amplitude');

% Plot the echoed signal
subplot(3,1,2);
stem(t2, y1);
title('Echoed Signal');
xlabel('Time (seconds)');
ylabel('Amplitude');

% Plot the difference between the two signals
subplot(3,1,3);
stem(t2, diff);
title('Difference (Echo - Original)');
xlabel('Time (seconds)');
ylabel('Amplitude');
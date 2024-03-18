% Med and max echo are generated from q1 output 

[x,fs] = loadAudio("q2_not_so_easy.wav");


[Rmm,lags] = xcorr(x,x); % autocorrelate here 

Rmm = Rmm(lags>0); % values 
lags = lags(lags>0); % get only the positive time 


index = envelope(Rmm,fs);
peak_value = Rmm(index); 


figure(1); 
plot(lags,Rmm);
title("Autocorrelated Signal");
xlabel("time(s)");
ylabel("Rxx");

norm_pks = peak_value/max(Rmm);

figure(2);
stem(index,norm_pks);
title("Peaks and Index");
xlabel("Index value");
ylabel("Attenuation Factor");

% we need to reverse ( i.e to cancel echo )  : so den = 1

numerator = zeros(1,length(x)); % numerator 
numerator(1) = 1;

den = 1;

for k = 2:length(index)

    numerator(index(k)+1) = norm_pks(k); % if z-1 then num = [1 1] so add at d1(k)+1 

end


filtered_signal = filter(den,numerator,x); % reverse filter 

figure(3);
plot(1:length(filtered_signal),filtered_signal);
title("Filtered Signal ");
xlabel ("Sample index");
ylabel("Amplitude");
grid on;

% Play the final audio 
soundsc(filtered_signal,fs);




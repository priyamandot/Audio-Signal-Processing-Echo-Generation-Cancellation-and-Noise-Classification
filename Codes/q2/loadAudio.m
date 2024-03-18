function [x, Fs] = loadAudio(input)
    % Load the audio file
    [x_stereo, Fs] = audioread(input);

    % Convert stereo to mono
    x = mean(x_stereo, 2);
end
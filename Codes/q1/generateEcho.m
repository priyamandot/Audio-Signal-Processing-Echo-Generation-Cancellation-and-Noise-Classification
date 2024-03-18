

function [y1,diff] = generateEcho(x,Fs,alpha,distance)
    timelag = 2*distance/343;
    delta = round(Fs*timelag);
    
    orig = [x;zeros(delta,1)];
    echo = [zeros(delta,1);x]*alpha;
    
    y0 = orig + echo;
    
    next = [y0;zeros(delta,1)];
    echo2= [zeros(2*delta,1);x]*alpha*alpha;
    
    y1 = next + echo2;
    
    diff = zeros(length(y1),1);
    diff(1:length(x)) = y1(1:length(x)) - x;
    diff(length(x)+1: length(y1)) = y1(length(x)+1: length(y1));
    
    y1 = y1/(max(abs(y1)));
    diff = diff/max(abs(diff));

end
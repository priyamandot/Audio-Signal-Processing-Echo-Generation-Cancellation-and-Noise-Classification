function peak_index = envelope(x,fs)
    
    peak_index=[];
    flag_out = 1;
    [~,index] = max(x); % index is the max value index 
    peak_index = [peak_index index]; % peak index array ( to get delay value ) 
   
    cutoff = x(peak_index(1))/25; %To stop the analysis ( value ) 
    % disp(cutoff);

    while flag_out~=0
    
    
        lambda = 0.00000011; % we start from this and keep going down 
        flag_in = 1;
        
        lastMax = peak_index(end); % prev peak maximum index 
        
        while flag_in~=0
            max_in_arr=[];
            y_max=x(lastMax); % value of that max peak index 

            for i=lastMax:length(x)

                if x(i)>=y_max
                    y_max=x(i);
                    max_in_arr=[max_in_arr i]; % add those maximum values index to the array ( values above that line ) 
                else
                    y_max = y_max-lambda*y_max; % keep reducing the slope of the line 
                end
            end

            % Now , out of those max points , we want to choose one max
            % peak point !

            if length(max_in_arr)>=2
                check= -990 ;
                ai = 1;

                for k=2:length(max_in_arr)

                    if x(max_in_arr(k))>check && x(max_in_arr(k)-1)<x(max_in_arr(k)) % choose the peak value among those by doing slope analysis 

                        check=x(max_in_arr(k));
                        ai = max_in_arr(k); % that max index 

                    else
                        
                        continue;
                    end
                    
                end
                
                flag_in=0;
            end

            lambda = lambda*1.01;  % increment lambda
            
        end

        % More than cutoff and min separation between two peaks has to be more than 
        % 0.1Fs , else it might two peaks which are very close to each
        % other 

        if x(ai) >= cutoff && ai>=peak_index(end)+0.1*fs 
            peak_index = [peak_index ai]; 
            % disp(ai);
        else
            flag_out=0;  % peak is less than cutoff , so next peak is def less than the cutoff 
                       % so , we stop the analysis 
        end

    end
end
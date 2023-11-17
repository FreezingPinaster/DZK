% Purpose: Obtains the best brightness level
% T0 is the condition to set, max difference between T1 and T2
% T1 is the initial threshold level
% T2 is the recaculated threshold level using T1

function level = basic_global_threshold(histogram_num,T0)
    % get the size of image array
    [x_len, y_len] = size(histogram_num); 
    % initialise T1 value: average of the max and min brightness values 
    T1 = (max(max(histogram_num)) + min(min(histogram_num)))/2;
    % count the number of pixels with brightness <T and >T respectively
    % to be indexes for G1 and G2 arrays
    columns1 = 1;
    columns2 = 1;

    while 1
        for x = 1:x_len
            for y = 1:y_len
                if histogram_num(x,y) > T1
                    % if >T1, add actual value to G1 array
                    G1(columns1) = histogram_num(x,y);
                    columns1 = columns1 + 1;
                else
                    % if <T1, add actual value to G2 array
                    G2(columns2) = histogram_num(x,y);
                    columns2 = columns2 + 1;
                end
            end
        end
        % get the average values of G1 and G2
        ave1 = mean(G1);
        ave2 = mean(G2);
        % T2 will be the average brightness of the white and black parts
        T2 = (ave1 + ave2)/2;
        % we want T1 to be as close to T2 as possible
        if abs(T2 - T1)<T0   
            break;
        end
        T1 = T2;
        % reset index counter to repeat loop
        columns1 = 1;
        columns2 = 1;
    end
    
    level = T2;
end

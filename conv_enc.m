% Function for convolutional coding
% Input data is xin
% Output is encoded data enc_out and flush bits


function [enc_out,flush] = conv_enc(xin)

data_in = [0 0 0];                 % intilaize the states to zero
s1 = 0;
s2 = 0;
s3 = 0;
enc_out = [];                      % defining the output matrix of encoded data

for cnt = 1:length(xin)
    input = xin(cnt);              % input bit to convolutional encoder
    out_back = xor(s2,s3);         % feedback data

    % new states of the convolutional encoder
    s3_new = s2;
    s2_new = s1;
    s1_new = xor(input,out_back);

    out1 = xor(xor(s1_new,s1),s3); % output encoded bit
    enc_out = [enc_out out1];      % storing data in output array

    % update the states
    s1 = s1_new;
    s2 = s2_new;
    s3 = s3_new;
end                                 % end of for loop

% trellis termination (switch go in down position)
flush = [];                         % initializing the flush matrix

for cnt = 1:3                       % loop for number of flush bits
    out_back = xor(s2,s3);          % feedback data

    % new states
    s3_new = s2;
    s2_new = s1;
    s1_new = xor(out_back,out_back);% setting zero into s1_new

    % output encoded bit
    out1 = xor(xor(s1_new,s1),s3);  %output
    enc_out = [enc_out out1];       % storing encoded bit in output array
    flush = [flush out_back];       % flush bit
 
    % update ths states
    s1 = s1_new;
    s2 = s2_new;
    s3 = s3_new;
end                                 %end of foor loop for flush bits
end                                 % end of function
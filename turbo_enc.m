% Function to turbo encode the data
% Input is input data xin
% Output is the coded data containing both data and flush bits


function [output] = turbo_enc(xin)

num = length(xin);                      % size of input data
[enc_out,flush1] = conv_enc(xin);       % function call for convolutional encoder

% interleaving
output = [];                            % defining output matrix
num_blocks = ceil(num/5114);            % determining number of data blocks
out_inter = [];                         % interleaver output matrix
xin2 = xin;
if num_blocks > 1
    for cnt_block = 1:num_blocks-1      % interlevaing data block by block
        [y] = interl(xin ((((cnt_block-1) *5114) +1):cnt_block*5114));  % function call for interleaver// wyciganie kolejnych paczek z xin
        [enc_out_inter,flush] = conv_enc(y);                          % convolutional encoding the interleaved data
        for cnt = 1:length(y)
            output = [output xin2(cnt) enc_out(cnt) enc_out_inter(cnt)];% storing encoded data in output matrix Xk,Zk ,Zk'
        end
        xin2 = xin2(cnt+1:end);         %odcinanie przetowroznego bloku danych xin2
        enc_out = enc_out(cnt+1:end);   %jak wyzej
    end                                 % end of cnt_block loop
end                                     % end of num_block loop

% interleaving the last block of data
input_interl = xin((( (num_blocks-1) *5114) +1) :end);                  % input to interleaver
[y,interleaved] = interl(input_interl);                                 % function call to interleaver
[enc_out_inter,flush2] = conv_enc(y);                                   % convolution encode the interleaved data
for cnt = 1:length(y)
    output = [output xin2(cnt) enc_out(cnt) enc_out_inter(cnt)];        % storing encoded data in output matrix Xk, Zk, Zk'
end % end of for

% appending flush bits Xk+1, Zk+1, Xk+2, Zk+2, Xk+3, Zk+3, X'k+1,Z'k+1,X'k+2, Z'k+2, X'k+3, Z'k+3
out = [];
m = length(xin);            % length of input data
for cnt1 = 1:length(flush1) % loop for writing flush bits from upper encoder Xk+1, Zk+1, Xk+2, Zk+2, Xk+3, Zk+3
    out = [out enc_out(m+cnt1) flush1(cnt1)];
end                         % end of for
for cnt1 = 1:length(flush2) % loop for writing flush bits from lower encoder X'k+1,Z'k+1,X'k+2,Z'k+2, X'k+3, Z'k+3
    out = [out enc_out_inter(m+cnt1) flush2(cnt1)];
end                         % end of for
output = [output out];
end                         % end of fuction




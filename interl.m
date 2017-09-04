% Function for interleaving the data
% Input is Input_data 40<=k<=5114
% Output is interleaved data y and interleaving matrix interleaved


function[y,interleaved] = interl(Input_data)

K = length(Input_data);                         % length of input data
[interleaved] = interleave(K);                  % function call for generating interleaved matrix array

if length(interleaved) > K                      % if length of input data is smaller than interleaver matrix, pad zeros
    pad_bits = length(interleaved)-K;           % calculate the number of pad bits
    Input_data = [Input_data zeros(1,pad_bits)];% create input data array with pad bits
end                                             % end of if loop

for cnt = 1:length(interleaved)                 % interleaving the data
    y(cnt) = Input_data(interleaved(cnt));      % create array of interleaved data
end                                             % end of for loop

y = y(1:K);                                     % removing padded bits from the interleaved data

end                                             % end of function

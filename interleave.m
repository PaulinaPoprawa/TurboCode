% Function for generating the interleaver matrix based on the size of data
% Input is size of the data K
% Output is interleaver matrix interleaved, 
% number of rows of the matrix R
% number of columns of matrix C
% factor determing the intra row permutation U
% factor determining the inter row permutation T


function [interleaved,R,U,C,T] = interleave(K)

% 1. Determine number of rows of the interleaver matrix
if (K >= 40 ) && ( K <= 159)
    R = 5;
elseif ((K >= 160 ) && ( K <= 200) ) || ((K >= 481) && ( K <= 530))
    R = 10;
else
    R = 20;
end                                                                 % end of if loop

% 2. Determine number to be used in intra permutation p and number of columns C
prim_num = primes(260);                                             % generate a vector of prime numbers from 0 to 260
prim_tab = [3 2 2 3 2 5 2 3 2 6 3 5 2 2 2 2 7 5 3 2 3 5 2 5 2 6 3 3 2 3 2 2 6 5 2 5 2 2 2 19 5 2 3 2 3 2 6 3 7 7 6 3];
prim_num = prim_num(4:end);                                         % removing the first 3 positions from prim_num
cnt = 1;
if ((K >= 481) && ( K <= 530) )
    p = 53;
    C = p;
    V = 2;
else
    p = prim_num(cnt);
    while K > R *(p+1)
        cnt = cnt+1;
        p = prim_num(cnt);
    end                                                             % enf of while loop
    V = prim_tab(cnt);

    if K <= R*(p-1)
        C = p-1;
    elseif ((R*(p-1)) < K ) && (K <= (R*p))
        C = p;
    elseif K > R*p
        C = p+1;
    end                                                             % end of inner ifelse loop
end                                                                 % end of outer if else loop
x = 1:(R*C);                                                        % generating array of data from 1 to size of matrix

% 3. Writing X in matrix form row wise
X = [];
cnt_r = 0;
while cnt_r < R
    X = [X ; x((cnt_r*C)+1 :((cnt_r+1)*C))];
    cnt_r = cnt_r+1;
end                                                                 % end od while loop

% inter row and intrarow permutations
% step 1 primitive root v
% step 2 construct base sequence for intra row permutation
s = 1;
for cnt_s = 2:p-1
    s = [s mod((V*s(cnt_s-1)),p)];
end
% step 3 assign q0
q = 1; % qo=1
cnt_prim = 1;
prim_gen = primes(1000);
prim_gen = prim_gen(4:end);
prim = prim_gen(cnt_prim);
cnt_q = 2;
while cnt_q <= R
    mid_q = gcd(prim,p-1);
    if mid_q == 1
        q(cnt_q) = prim;
        cnt_q = cnt_q+1;
    end
    cnt_prim = cnt_prim+1;
    prim = prim_gen(cnt_prim);
end

% 4. Permute q to get r
if R == 5
    T=fliplr([1:5]);
elseif R == 10
    T=fliplr([1:10]);
elseif (R == 20) && (((2281 <= K) && (K <= 2480)) || ((3161 <= K) && (K <= 3210)))
    T = [20 10 15 5 1 3 6 8 13 19 17 14 18 16 4 2 7 12 9 11];
else
    T = [20 10 15 5 1 3 6 8 13 19 11 9 14 18 4 2 17 7 16 12];
end
r = zeros(1,R);
for cnt_i = 1:R
    r(T(cnt_i)) = q(cnt_i);
end

% 5. Intra row permutation
U = zeros(R,C);
for cnt_i = 1:R
    if C == p
        for cnt_j = 0:p-2
            U(cnt_i,cnt_j+1) = s( (mod((cnt_j*(r(cnt_i))) ,(p-1) ))+1);
        end
    end
    if C == (p+1)
        for cnt_j = 0:p-2
            U(cnt_i,cnt_j+1) = s(( mod((cnt_j*(r(cnt_i))) ,(p-1) ))+1);
        end
        U(cnt_i,p+1) = p;

        % exchanging first and last row
        if K == (R*C)
            new_U = U;
            U(R,C) = new_U(R,1);
            U(R,1) = new_U(R,C);
        end
    end
    if C == (p-1)
        for cnt_j = 0:p-2
            U(cnt_i,cnt_j+1) = (s(( mod((cnt_j*(r(cnt_i))) ,(p-1)))+1))-1;
        end
    end
end
U = U+1;
% performing intra row permutation
intra_row = zeros(R,C);
for cnt_row = 1:R
    for cnt_col = 1:C
        intra_row(cnt_row,cnt_col) = X(cnt_row,U(cnt_row,cnt_col));
    end
end

% % 6. Perform the inter-row permutation for the rectangular matrix based on the pattern ( ) i?{0,1, ,R?1}
inter_row = zeros(R,C);
for cnt = 1:R
    inter_row(cnt,:) = intra_row(T(cnt),:);
end
Y = [];
for cnt_y = 1:C
    Y = [Y (inter_row(:,cnt_y))'];
end
interleaved = Y;

end                                                     % end of function



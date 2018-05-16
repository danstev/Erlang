% Calculates pi to five decimal digits.
%takes a little while, could probably have lowered the 2m figure.
-module(pi).
-export ([pi/2]).
-export ([main/1]).

pi(N,V) when N == 2000001 ->
io:fwrite("~.5f" , [V*4]);

pi(N, V)-> 
% if you wanna see progress: io:fwrite("~p~n" , [N]),
pi(N + 4, V + ((1/N) - (1/(N+2)))).

main(_)->
pi(1,0).


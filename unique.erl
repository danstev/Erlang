% test
-module(unique).
-export ([unique/1]).
-export ([count/1]).
-export ([main/1]).


unique([])-> 
[]; %stops recursion
unique([H|T])->
[H | [X || X <- unique(T), X /= H]].

count([H|T])->
A=unique([H|T]),
{A,length(A)}.

main(_)-> %is this a ok way to call this? unique:main(1). where 1 could be anything?
count([6,5,3,4,5,7,8,7,5,4,3,2,2]).
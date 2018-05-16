-module (ccharcount).
-export ([load/1, count/3, go/2, join/2, split/2, conc/2, splitCount/2, fileSplit/2]).

%Joins together lists
join([],[])->[];
join([],R)->R;
join([H1 |T1],[H2|T2])->
{C,N}=H1,
{C1,N1}=H2,
[{C1,N+N1}]++join(T1,T2).

%splits up the large binary data into twenty lists?
split([],_)->[];
split(List,Length)->
S1=string:substr(List,1,Length),
case length(List) > Length of
   true->S2=string:substr(List,Length+1,length(List));
   false->S2=[]
end,
[S1]++split(S2,Length).

%counts each occurance of the letter
count(Ch, [],N)->N;
count(Ch, [H|T],N) ->
   case Ch==H of
   true-> count(Ch,T,N+1);
   false -> count(Ch,T,N)
end.



rgo([H|T],L,Result)->
N=count(H,L,0),
Result2=Result++[{[H],N}],
rgo(T,L,Result2);
rgo([],L,Result)->Result.

% KEPT THE SAME ABOVE THIS LINE

go(ProcessID, L)->
Alph=[$a,$b,$c,$d,$e,$f,$g,$h,$i,$j,$k,$l,$m,$n,$o,$p,$q,$r,$s,$t,$u,$v,$w,$x,$y,$z],
ProcessID ! {rgo(Alph,L,[])}. %Sending the result back.

load(F)-> %Could probably add in the amount of segments to split it into here
{ok, Bin} = file:read_file(F),
   List=binary_to_list(Bin), %
   Length=round(length(List)/20),
   Ls=string:to_lower(List),
   Sl=split(Ls,Length),
   fileSplit(Sl, length(List)/20). %changed here to send to filesplit
   
%I forgot to add this one into the -export settings, but it compiled anyway and ran fine? why
fileSplit(List, Length)->
ProcessID = spawn(ccharcount,splitCount,[[], 0]),
conc(ProcessID, List).

%when list is empty, stop it.
conc(ProcessID,[]) ->
io:fwrite("~p~n", ["Finished breaking down your file."]); %this doesnt spit out the string, just 'ok'?

%When list is not empty, spawn a new process.
conc(ProcessID,[H | T]) ->
spawn(ccharcount,go, [ProcessID, H]),
conc(ProcessID, T).

%Both splitcounts add up the results they recieve from the concurrent thingys.
%This one stops it. I added this one because it would spit out a count for each split, rather than jsut the last, which is what is required.
splitCount(R, 20)-> receive %i.e last last segment of the segmented list is 20.
{List} ->
R2 = join(R, List),
io:fwrite("~p~n", [R2]),
splitCount(R2, 20+1);
_Other -> {error, unknown}
end;

%recieves every other segment and adds it to the main lists.
splitCount(R, N)-> receive %every other segment of the list goes through here.
{List} ->
R2 = join(R, List),
splitCount(R2, N+1);
_Other -> {error, unknown}
end.
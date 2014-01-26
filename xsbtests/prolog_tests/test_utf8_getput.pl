
test:- test_code('utf8.txt'),fail.
test:- test_char('utf8.txt'),fail.


test_code(File):- 
       open(File,read,Str),
       repeat,
       get_code(Str,Code),
       (Code = -1,close(Str) ; write('put_code: '),put_code(Code),nl,fail),!.

test_char(File):- 
       open(File,read,Str),
       repeat,
       get_char(Str,Char),
%       writeln(Char),
%       write(' '(Char)),
       (Char = -1,close(Str) ; write('put_char: '),put_char(Char), nl,fail),!.



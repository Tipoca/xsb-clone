
test:- test_code('utf8.txt'),fail.
test:- test_char('utf8.txt'),fail.
test:- test_peek_code('utf8.txt'),fail.
test:- test_peek_char('utf8.txt'),fail.
test.

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
       (Char = end_of_file,close(Str) ; write('put_char: '),put_char(Char), nl,fail),!.

test_peek_code(File):- 
       open(File,read,Str),
       repeat,
       peek_code(Str,PeekCode),
       get_code(Str,GetCode),
       (GetCode = -1,close(Str) ; write(peek_vs_get(PeekCode,GetCode)),nl,fail),!.

% test of 'z' to avoid problem with line break / carriage return.
test_peek_char(File):- 
       open(File,read,Str),
       repeat,
       peek_char(Str,PeekChar),
       get_char(Str,GetChar),
       (GetChar = z,close(Str) ; write(peek_vs_get(PeekChar,GetChar)),nl,fail),!.



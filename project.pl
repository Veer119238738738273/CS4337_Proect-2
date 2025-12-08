% project.pl

find_exit(_, _) :-
    write('find_exit not implemented yet'), nl, fail.

valid_map(Map, Start, Exit) :-
    member(Row, Map),
    member(s, Row), Start = (0,0),
    member(Row2, Map),
    member(e, Row2), Exit = (1,1).


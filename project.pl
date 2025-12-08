% project.pl

find_exit(_, _) :-
    write('find_exit not implemented yet'), nl, fail.

valid_map(Map, Start, Exit) :-
    member(Row, Map),
    member(s, Row), Start = (0,0),
    member(Row2, Map),
    member(e, Row2), Exit = (1,1).

cell_at(Map, R, C, Val) :-
    nth0(R, Map, Row),
    nth0(C, Row, Val).

rectangular([Row|Rows]) :-
    length(Row, Len),
    Len > 0,
    maplist(same_length(Row), Rows).

valid_cell(s).
valid_cell(e).
valid_cell(w).
valid_cell(f).

all_valid_cells(Map) :-
    forall(
        ( member(Row, Map),
          member(Cell, Row)
        ),
        valid_cell(Cell)
    ).

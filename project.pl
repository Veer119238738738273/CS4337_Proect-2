% project.pl

find_exit(_, _) :-
    write('find_exit not implemented yet'), nl, fail.

valid_map(Map, Start, Exit) :-
    Map \= [],
    rectangular(Map),
    all_valid_cells(Map),
    findall((R,C), cell_at(Map, R, C, s), Starts),
    findall((R,C), cell_at(Map, R, C, e), Exits),
    Starts = [Start],
    Exits = [Exit].

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

step(Map, (R,C), up, (R1,C)) :-
    R1 is R - 1,
    R1 >= 0,
    cell_at(Map, R1, C, Val),
    Val \= w.

step(Map, (R,C), down, (R1,C)) :-
    R1 is R + 1,
    cell_at(Map, R1, C, Val),
    Val \= w.

step(Map, (R,C), left, (R,C1)) :-
    C1 is C - 1,
    C1 >= 0,
    cell_at(Map, R, C1, Val),
    Val \= w.

step(Map, (R,C), right, (R,C1)) :-
    C1 is C + 1,
    cell_at(Map, R, C1, Val),
    Val \= w.

dfs(Map, Pos, Exit, [Dir|Rest]) :-
    step(Map, Pos, Dir, Next),
    dfs(Map, Next, Exit, Rest).

dfs(_Map, Pos, Pos, []).


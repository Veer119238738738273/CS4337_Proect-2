% project.pl

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
    length(Map, Rows),
    R1 < Rows,
    cell_at(Map, R1, C, Val),
    Val \= w.

step(Map, (R,C), left, (R,C1)) :-
    C1 is C - 1,
    C1 >= 0,
    cell_at(Map, R, C1, Val),
    Val \= w.

step(Map, (R,C), right, (R,C1)) :-
    C1 is C + 1,
    nth0(0, Map, Row),
    length(Row, Cols),
    C1 < Cols,
    cell_at(Map, R, C1, Val),
    Val \= w.

dfs(_Map, Pos, Pos, _Visited, MovesAcc, Path) :-
    reverse(MovesAcc, Path).

dfs(Map, Pos, Exit, Visited, MovesAcc, Path) :-
    step(Map, Pos, Dir, Next),
    \+ member(Next, Visited),
    dfs(Map, Next, Exit, [Next|Visited], [Dir|MovesAcc], Path).

follow(_Map, Pos, [], Pos).
follow(Map, Pos, [Dir|Rest], Final) :-
    step(Map, Pos, Dir, Next),
    follow(Map, Next, Rest, Final).

verify_path(Map, Start, Exit, Moves) :-
    follow(Map, Start, Moves, Final),
    Final = Exit.

find_exit(Map, Path) :-
    var(Path),
    valid_map(Map, Start, Exit),
    dfs(Map, Start, Exit, [Start], [], Path),
    !.

find_exit(Map, Path) :-
    nonvar(Path),
    valid_map(Map, Start, Exit),
    verify_path(Map, Start, Exit, Path).


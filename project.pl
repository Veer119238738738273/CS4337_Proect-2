% project.pl

% Checks that the map is rectangular, contains valid symbols,
% and has exactly one start cell and one exit cell.
valid_map(Map, Start, Exit) :-
    Map \= [],
    rectangular(Map),
    all_valid_cells(Map),
    findall((R,C), cell_at(Map, R, C, s), Starts),
    findall((R,C), cell_at(Map, R, C, e), Exits),
    Starts = [Start],
    Exits = [Exit].

% Reads the value at position (R,C).
cell_at(Map, R, C, Val) :-
    nth0(R, Map, Row),
    nth0(C, Row, Val).

% Ensures every row has the same length.
rectangular([Row|Rows]) :-
    length(Row, Len),
    Len > 0,
    maplist(same_length(Row), Rows).

% valid cell symbols
valid_cell(s).
valid_cell(e).
valid_cell(w).
valid_cell(f).

% True if every cell in the map uses a valid symbol.
all_valid_cells(Map) :-
    forall(
        ( member(Row, Map),
          member(Cell, Row)
        ),
        valid_cell(Cell)
    ).

% Defines valid movement in the four cardinal directions.
% Movement fails if the next cell is a wall or outside the map.
% Goes in this order (Move Up, Move Down, Move Left, Move Right)
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

% Depth-first search. Builds the path by exploring all valid steps.
% Path is returned in the correct order by reversing MovesAcc.
dfs(_Map, Pos, Pos, _Visited, MovesAcc, Path) :-
    reverse(MovesAcc, Path).

dfs(Map, Pos, Exit, Visited, MovesAcc, Path) :-
    step(Map, Pos, Dir, Next),
    \+ member(Next, Visited),
    dfs(Map, Next, Exit, [Next|Visited], [Dir|MovesAcc], Path).

% Shows the movement along a list of directions.
follow(_Map, Pos, [], Pos).
follow(Map, Pos, [Dir|Rest], Final) :-
    step(Map, Pos, Dir, Next),
    follow(Map, Next, Rest, Final).

% Checks that following Moves takes you from Start to Exit.
verify_path(Map, Start, Exit, Moves) :-
    follow(Map, Start, Moves, Final),
    Final = Exit.

% Two modes:
% - Path is a variable. Use DFS to generate a path.
find_exit(Map, Path) :-
    var(Path),
    valid_map(Map, Start, Exit),
    dfs(Map, Start, Exit, [Start], [], Path),
    !.

% - Path is given. Verify that it leads to the exit.
find_exit(Map, Path) :-
    nonvar(Path),
    valid_map(Map, Start, Exit),
    verify_path(Map, Start, Exit, Path).

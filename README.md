Project 2 (CS4337):: 
Maze Validation, Path Verification, and DFS Pathfinding in Prolog
This project implements predicates for checking a maze, verifying a path, and generating a path using depth first search. This document explains how to load the files, run the tests, and understand the outputs.

**The folder must contain the following files:**
project.pl
example.pl
test.pl

All files must be in the same directory. The file must be named exactly project.pl. If Windows hides the extension and shows it as “project”, that is fine.
Starting SWI Prolog
Open SWI Prolog.
Set the working directory to your folder:
?- working_directory(_, 'C:/path/to/your/folder').

Replace the path with your actual directory. Prolog should return:
true.
Loading the project
Load all files:
?- [project, example, test].
You should see true.

Testing valid_map/3
Example:
?- basic_map(M), valid_map(M, S, E).

Expected result:
M unifies with the example maze
S = (1,1)
E = (1,3)

Failure example:
?- bad_map(M), valid_map(M, S, E).
false.

Testing display_map/1
?- basic_map(M), display_map(M).
This prints the maze in a readable visual format.

Testing find_exit/2 (path generation)
When Path is a variable, DFS generates a path:
?- basic_map(M), find_exit(M, P).
Expected:
P = [down, left, down]
There is a cut in this predicate so it returns only one solution.

Testing find_exit/2 (path verification)
Correct path:
?- basic_map(M), find_exit(M, [down,left,down]).
true.
Incorrect path:
?- basic_map(M), find_exit(M, [down,down]).
false.

Testing verify_path/4
?- basic_map(M), valid_map(M, S, E), verify_path(M, S, E, [down,left,down]).
true.
Failure example:
?- basic_map(M), valid_map(M, S, E), verify_path(M, S, E, [up,right]).
false.

Testing dfs/6 directly
?- basic_map(M), valid_map(M, S, E), dfs(M, S, E, [S], [], P).
Expected:
P = [down, left, down]

Testing random maze generation
?- gen_map(4, 10, 10, M), display_map(M), find_exit(M, P).
The first parameter controls complexity.
The second and third are row and column counts.
The fourth unifies with the generated maze.
If a path exists, Prolog returns it.
If not, the query fails.

**Summary of program behavior**
valid_map/3 checks the map structure and finds the start and exit.
step/4 checks if movement in a direction is allowed.
dfs/6 searches for a path from start to exit.
follow/4 simulates the movement.
verify_path/4 checks a user supplied path.
find_exit/2 either generates or verifies a path.

Nothing is hardcoded. The program works for any rectangular maze.

Other Commands:
?- [project, example, test].
?- basic_map(M), valid_map(M, S, E).
?- basic_map(M), display_map(M).
?- basic_map(M), find_exit(M, P).
?- basic_map(M), find_exit(M, [down,left,down]).
?- basic_map(M), find_exit(M, [down,down]).
?- gen_map(4,10,10,M), find_exit(M, P).
These demonstrate validation, DFS generation, and path verification.

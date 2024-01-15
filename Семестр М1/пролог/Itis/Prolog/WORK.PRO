Database file_name(string)
Predicates start andisk
Goal start.
Clauses
	start if makewindow(1, 112, 94, "View files (esc - exit)", 0, 0, 25, 80)
		and andisk.
	andisk if makewindow(2, 45, 47, "", 1, 1, 4, 78)
		and dir("A:\\", "*", Name)
		and assert(file_name(Name))
		and removewindow
		and !.
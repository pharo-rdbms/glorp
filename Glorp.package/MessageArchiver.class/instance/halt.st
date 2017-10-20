debugging
halt
	"Support this so that we can debug inside query blocks. For portability, send it to a different object so that we don't have to care how halt is implemented"

	(Array with: self) halt
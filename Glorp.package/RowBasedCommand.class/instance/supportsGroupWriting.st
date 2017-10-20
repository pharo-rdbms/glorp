testing
supportsGroupWriting
	"Return true if array binding or a similar mechanism can be used to execute us with multiple commands at once. I think in general this can only ever make sense for inserts (and possibly selects under some circumstances). Updates may want to update only part of the fields."
	^false.
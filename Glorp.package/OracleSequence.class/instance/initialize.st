initalize-release
initialize
	super initialize.
	count := 0.
	sequenceIncrement := 1.
	accessProtect := Semaphore forMutualExclusion
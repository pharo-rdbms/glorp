initialize/release
initialize

	transactions := OrderedCollection new.
	accounts := OrderedCollection new.
	seenExpiry := false.
	seenPostFetch := false.
	seenPreWrite:= false.
	seenPostWrite := false.
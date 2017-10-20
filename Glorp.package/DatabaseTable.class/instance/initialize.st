initialize
initialize

	schema := ''.
	fields := OrderedCollection new.
	foreignKeyConstraints := OrderedCollection new: 4.
	uniqueConstraints := OrderedCollection new.
	lockKeyFields := OrderedCollection new.
	indexes := OrderedCollection new.
	isImaginary := false.
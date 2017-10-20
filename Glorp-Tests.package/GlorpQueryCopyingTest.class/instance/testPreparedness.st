tests
testPreparedness
	self deny: query isPrepared.
	query prepare.
	newQuery := query copy.
	self assert: query isPrepared.
	self deny: newQuery isPrepared.
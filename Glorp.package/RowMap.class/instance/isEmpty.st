testing
isEmpty
	self compress.
	self rowsDo: [:each | (self isDeleted: each) ifFalse: [^false]].
	^true.
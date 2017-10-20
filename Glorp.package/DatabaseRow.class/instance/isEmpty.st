testing
isEmpty
	| empty |
	contents isNil ifTrue: [^true].
	empty := self class emptySlot.
	contents do: [:each | each == empty ifFalse: [^false]].
	^true.
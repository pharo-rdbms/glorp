preparing
controlsTables
	"We can end up with a table expression built on top of a base that has the same table. If so, we don't count as controlling that table"

	base isNil ifTrue: [^true].
	base hasDescriptor ifFalse: [^true].
	^(base descriptor tables includes: table) not.
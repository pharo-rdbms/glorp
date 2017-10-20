caching
touch: aTimedProxy
	[| association |
	mutex wait.
	association := aTimedProxy glorpAssociation.
	association isNil ifTrue: [^self].
	association key: nil.	"This indicates that the key should not be reaped at this time."
	self noWaitAdd: aTimedProxy] ensure: [mutex signal].
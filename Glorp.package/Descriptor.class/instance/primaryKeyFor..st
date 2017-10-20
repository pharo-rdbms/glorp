mapping
primaryKeyFor: anObject
	"Find the primary key for anObject. If it's a single field, just return a single value. Otherwise, return a collection. Caller is expected to know what to expect."
	| fields |
	anObject class == self describedClass
		ifFalse: [self error: 'Wrong descriptor for this object'].
	fields := self primaryTable primaryKeyFields.
	^fields size = 1
		ifTrue: [self valueOfField: (fields at: 1) fromObject: anObject]
		ifFalse:
			[fields collect: [:each | self valueOfField: each fromObject: anObject]]
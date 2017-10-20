mapping
primaryKeyCollectionFor: anObject
	"Find the primary key for anObject. Always return it as a collection."
	| fields |
	anObject yourSelf class == self describedClass
		ifFalse: [self error: 'Wrong descriptor for this object'].
	fields := self primaryTable primaryKeyFields.
	^fields collect: [:each | self valueOfField: each fromObject: anObject]
accessing
join: aJoin
	"In addition to setting up the join, use that information to configure our faked up descriptor"
	| tables |
	super join: aJoin.
	tables := self targetTables asArray.
	tables size > 1
		ifTrue: [self error: 'Cannot have multiple tables for a direct toMany'].
	self referenceDescriptor table: tables first.
	"We add a mapping for our value. We don't normally use this, because we expect people to refer directly to the attribute, but it means, for example, that the field shows up in our mapped fields without us having to fake it up. And you could write a query referring to anAttribute myValue if you wanted"
	(self referenceDescriptor newMapping: DirectMapping) 
		from: #myValue to: resultField
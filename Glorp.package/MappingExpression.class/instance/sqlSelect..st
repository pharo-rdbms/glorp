api
sqlSelect: anExpression
	"Only useful for mappings that represent collections. This restricts the range of values in a variable. Most useful as part of an aggregation. e.g. 
    read: SomeClass where: [:each | (each collection select: [:eachItem | eachItem attribute = someValue]) sqlCount > 10]"

	"We may be passed an expression corresponding to either a field, or to a full object, depending on the aggregate function. In either case, build backwards from the first full object"
	| objectExpression newMapping previousJoin |
	objectExpression := self mapping isRelationship 
		ifTrue: [self] ifFalse: [self base].
	newMapping := self mapping class new.
	newMapping attributeName: #temporaryAttributeFromSubselect.
	newMapping referenceClass: self mapping referenceClass.
	newMapping descriptor: self mapping descriptor.
	newMapping linkFields: self mapping linkFields.
	newMapping usesLinkTable: self mapping usesLinkTable.
	previousJoin := self mapping join.
	newMapping join: ((anExpression rebuildOn: previousJoin ultimateBaseExpression startingFrom: self) AND: previousJoin asGlorpExpression).

	^objectExpression base getMapping: newMapping named: ( 'a temporary restricted mapping for #select: based on ', self mapping attributeName).
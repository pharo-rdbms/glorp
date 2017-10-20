initializing
initializeJoinTo: otherTables
	"We haven't been giving a join. See if we can make an educated guess at one by looking for tables with constraints to us. If linkFields is set, it tells us the source field for the relationship between the link table and the target, so in looking for our own relationship to the link table, we exclude that."
	| toConstraints fromConstraints |
	self descriptor tables isEmpty ifTrue: [^self join: Join new].
	(self referenceDescriptor tables isEmpty and: [self referenceDescriptor typeResolver usesInheritance]) ifTrue: [^self join: Join new].
	toConstraints := self oneWayConstraintsFrom: self descriptor tables to: otherTables.
	linkFields isNil ifFalse: [toConstraints := toConstraints reject: [:eachConstraint | eachConstraint targetFields anySatisfy: [:eachField | linkFields includes: eachField]]].
	fromConstraints :=  self oneWayConstraintsFrom: otherTables to: self descriptor tables.
	linkFields isNil ifFalse: [fromConstraints := fromConstraints reject: [:eachConstraint | eachConstraint sourceFields anySatisfy: [:eachField | linkFields includes: eachField]]].

	self join: (self system joinFor: self toTables: otherTables fromConstraints: fromConstraints toConstraints: toConstraints).
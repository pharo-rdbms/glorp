private/expressions
constraints
	"Return a list of the constraints from our link table. If the linkField is set, filter the constraints to those that include that field. "
	| referenceKeys linkTable referenceTables allConstraints relevantConstraints |
	referenceKeys := (self join) targetKeys asOrderedCollection.
	linkTable := referenceKeys first table.
	"If we haven't been told the relevant link table fields, assume we can find them by looking at all the ones that aren't the ones from our source to the link, and all the rest will be from the link to the target"
	allConstraints := linkTable foreignKeyConstraints.
	relevantConstraints := linkFields isNil 
		ifTrue: [allConstraints reject: [:each |  each sourceFields allSatisfy: [:eachSourceField |
			(referenceKeys includes: eachSourceField)]]]
		ifFalse: [allConstraints select: [:each | each sourceFields anySatisfy: [:eachSourceField |
			linkFields includes: eachSourceField]]].

	"Validate that we can handle this case"
	referenceTables := (relevantConstraints collect: [:each | each targetTable]) asSet.
	referenceTables size > 1 ifTrue: [self error: 'Cannot handle this general a case. Try hinting using relevantLinkTableFields:'].
	referenceTables size = 0 ifTrue: [self error: 'No tables found. Did you set up foreign key references in the table definitions?'].

	^relevantConstraints.
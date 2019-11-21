"
This represents an attribute of some other object. It's called a mapping expression because each attribute has a mapping, and when we come to prepare the query, we'll be using that mapping's information to deduce joins, and to print properly.

Instance Variables:
	base	<BaseExpression | MappingExpression>	The expression we are built on, which is to say the expression describing the object of which we are an attribute.
	mapping	<Mapping>	The mapping we correspond to in the base. So if the base was [:each | each owner city] and we are #name, then we the mapping is for the attribute #name in the descriptor for City.
	name	<Symbol>	The name of our attribute. We will use this to determine the mapping.
	outerJoin	<Boolean>	Are we to interpret the join to our parent object's table as being an outer join or not?
	phantom <Boolean> Is this a phantom mapping - one which is not defined in the descriptor explicitly, but is temporarily created to define a reverse relationship, an alsoFetch of subclasses, or some other transient usage.


"
Class {
	#name : #MappingExpression,
	#superclass : #ObjectExpression,
	#instVars : [
		'name',
		'base',
		'outerJoin',
		'mapping',
		'phantom'
	],
	#category : 'Glorp-Expressions'
}

{ #category : #'instance creation' }
MappingExpression class >> named: aSymbol basedOn: anExpression [

	^self new
		named: aSymbol
		basedOn: anExpression
]

{ #category : #preparing }
MappingExpression >> additionalExpressions [
	^self additionalExpressionsOn: self.
]

{ #category : #preparing }
MappingExpression >> additionalExpressionsOn: anExpression [
	"We can get hijacked, so pass in the expression to use rather than just using self"
	| exp |
	self mapping isNil ifTrue: [^#()].
	exp := self mapping joinExpressionFor: anExpression.
	outerJoin ifTrue: [exp beOuterJoin].
	^(self multipleTableExpressionsOn: anExpression), (exp isNil ifTrue: [#()] ifFalse: [Array with: exp]).
]

{ #category : #fields }
MappingExpression >> aliasedTableFor: aDatabaseTable [ 
	^self controlsTables 
		ifTrue: [super aliasedTableFor: aDatabaseTable]
		ifFalse: [base aliasedTableFor: (self mapping translateTable: aDatabaseTable)]
]

{ #category : #fields }
MappingExpression >> aliasedTableFor: aDatabaseTable ifAbsent: aBlock [
	^self controlsTables 
		ifTrue: [super aliasedTableFor: aDatabaseTable ifAbsent: aBlock]
		ifFalse: [base aliasedTableFor: aDatabaseTable ifAbsent: aBlock]
]

{ #category : #preparing }
MappingExpression >> allControlledTables [
	"Return all the tables that we control, directly or indirectly. Basically, if we are a mapping expression with a link table, return the link table as well as any tables of ours."
	| all join |
	self controlsTables ifFalse: [^#()].
	all := Set new.
	all addAll: self tables.
	mapping := self mapping.
	mapping isNil 
		ifFalse: [
			join := mapping join.
			join isNil ifFalse: [all addAll: join allControlledTables]].
	^all.
]

{ #category : #internal }
MappingExpression >> allRelationsFor: rootExpression [
	^self mapping allRelationsFor: rootExpression.
]

{ #category : #preparing }
MappingExpression >> allRelationsFor: rootExpression do: aBlock andBetweenDo: anotherBlock [
	"We might have multiple clauses to print, depending on our mapping"
	self mapping 
		allRelationsFor: rootExpression
		do: aBlock
		andBetweenDo: anotherBlock.
]

{ #category : #accessing }
MappingExpression >> allSourceFields [
	"If we are sending this, then we're treating the expression as a join, for a complex (and probably read-only) relationship. So in that case we want to treat the source fields as the parameters that this expression takes, and specifically the parameters that are based on fields."
	^self inject: OrderedCollection new into: [:sum :each |
		each addToTargetFields: sum.
		sum].
]

{ #category : #accessing }
MappingExpression >> allTargetFields [
	"If we are sending this, then we're treating the expression as a join, for a complex (and probably read-only) relationship. So in that case we want to treat the target fields as being the source fields of the bottom-most mapping. That is, the fields we'll use to connect to the thing we want are the things that our expression's base (which represents the thing we want) would use to connect to the first level mapping arising from it."
	^self penultimateBaseExpression join allSourceFields.
]

{ #category : #preparing }
MappingExpression >> asExpressionJoiningSource: source toTarget: target [
	"Create a general expression which represents this relationship where the values of the targets (which are normally parameters) are supplied out of the context provided by 'target' and the source fields are referencing things out of the context of source. Produces something suitable for ANDing into an expression when doing a join
   Example: If we had CUSTOMER.ADDRESS_ID = ADDRESS.ID as a parameter, and we want to AND this into an expression [:customer | customer address street = 'Main'] then we have customer as a base, and we get 
	(customer.ADDRESS.STREET = 'Main') AND (customer.CUSTOMER.ADDRESS_ID = customer.ADDRESS.ID)
	The primary key expression for the relationship has been translated into field references into the customer and address tables in a particular context."

	| newBase |
	newBase := base asExpressionJoiningSource: source toTarget: target.
	^newBase getMapping: self mapping named: name.
]

{ #category : #api }
MappingExpression >> asOuterJoin [
	outerJoin := true.
]

{ #category : #api }
MappingExpression >> base [

	^base.
]

{ #category : #accessing }
MappingExpression >> bePhantom [
	phantom := true.
]

{ #category : #testing }
MappingExpression >> canBeUsedForRetrieve [
	"Return true if this is a valid argument for a retrieve: clause"
	^self mapping canBeUsedForRetrieve.
]

{ #category : #accessing }
MappingExpression >> canHaveBase [
	"Return true if this type of expression can have a base expression on which other things can be built. Doesn't say whether we actually have a valid one or not."
	^true.
]

{ #category : #testing }
MappingExpression >> canKnit [
	"Return true if, when building objects, we can knit the object corresponding to this expression to a related object. Roughly speaking, is this a mapping expression"
	^true.
]

{ #category : #testing }
MappingExpression >> canPrint [
	"Return true if we can print into a where clause"
	^self hasField.
]

{ #category : #fields }
MappingExpression >> controlsTables [
	| theMapping |
	theMapping := self mappingFromMeOrSubclasses.
	theMapping isNil ifTrue: [^true].
	^theMapping controlsTables
]

{ #category : #converting }
MappingExpression >> convertedDbValueOf: anObject [

	^self mapping convertedDbValueOf: anObject.
]

{ #category : #converting }
MappingExpression >> convertedStValueOf: anObject [

	^self mapping convertedStValueOf: anObject.
]

{ #category : #accessing }
MappingExpression >> descriptor [
	| system theMapping |
	system := self system.
	system isNil ifTrue: [^nil].
	theMapping := self mappingFromMeOrSubclasses.
	theMapping isNil ifTrue: [^nil].
	^system descriptorFor: theMapping referenceClass.
]

{ #category : #iterating }
MappingExpression >> do: aBlock skipping: aSet [
	"Iterate over the expression tree"

	| myField |
	(aSet includes: self) ifTrue: [^self].
	aSet add: self.
	base do: aBlock skipping: aSet.
	aBlock value: self.
	(self hasField and: [(myField := self field) isGlorpExpression])
		ifTrue: [myField do: aBlock skipping: aSet].
]

{ #category : #accessing }
MappingExpression >> field [

	self mapping isNil ifTrue: [self error: '"', name, '" is not a mapped property name in ', base descriptor describedClass name].
	self hasDescriptor ifTrue: [
		"If we have a descriptor, then either we're a mapping to a full object, in which case we can't answer this properly, or we're a direct to-many mapping, in which case we can."
		self mapping mapsSimpleObject
			ifTrue: [^self translateField: self mapping field]
			ifFalse: [self error: '"',name, 
				'" is not an attribute that resolves to a field in the mapped tables for ', 
					base descriptor describedClass name]].
	^base translateField: self mapping field.
]

{ #category : #accessing }
MappingExpression >> fieldFromMeOrSubclasses [
	"Return the field for this mapping, but if the field is not mapped here, and the class uses inheritance, check for subclasses, and use the first subclass mapping we find."

	| subMapping |
	subMapping := self mappingFromMeOrSubclasses.
	^subMapping isNil
		ifTrue: [self field]
		ifFalse: [base translateField: subMapping field]
]

{ #category : #preparing }
MappingExpression >> fieldsForSelectStatement [
	
	^self mapping fieldsForSelectStatement.
]

{ #category : #accessing }
MappingExpression >> hasDescriptor [
	"Does the object that we describe have its own descriptor"
	| myMapping |
	myMapping := self mapping.
	^myMapping notNil and: [myMapping isRelationship]
]

{ #category : #accessing }
MappingExpression >> hasField [

	self mapping isNil ifTrue: [^false].
"If we have a descriptor, then either we're a mapping to a full object, in which case we can't answer this properly, or we're a direct to-many mapping, in which case we can."
	self hasDescriptor ifTrue: [
		^self mapping mapsSimpleObject].
	^true.
]

{ #category : #testing }
MappingExpression >> hasImpliedClauses [
	^self mapping notNil and: [self mapping hasImpliedClauses].
]

{ #category : #initialize }
MappingExpression >> initialize [
	super initialize.
	phantom := false.
]

{ #category : #api }
MappingExpression >> isEmpty [
	"Only useful for mappings that represent collections. This checks to see if the collection has elements by building a not exists subselect."
	
	^self base existenceCheck: self as: #notExists:
]

{ #category : #accessing }
MappingExpression >> join [
	self mapping isNil ifTrue: [^nil].
	^self mapping join.
]

{ #category : #iterating }
MappingExpression >> mappableFieldsDo: aBlock [
	"Used when we are emulating a Join"
	self allSourceFields with: self allTargetFields do: [:source :target |
		source isMappable ifTrue: [aBlock value: source value: target]].
]

{ #category : #iterating }
MappingExpression >> mappableSourceFieldsDo: aBlock [
	"Used when we are emulating a Join"
	self allSourceFields do: [:source |
		source isMappable ifTrue: [aBlock value: source]].
]

{ #category : #accessing }
MappingExpression >> mappedFields [
	
	self mapping isNil ifTrue: [^#()].
	self mapping isRelationship ifTrue: [self error: '"',name, '" is not an attribute that resolves to a field in the mapped tables for ', base descriptor describedClass name].
	^self mapping mappedFields collect: [:each | base translateField: each].
]

{ #category : #internal }
MappingExpression >> mapping [
	mapping isNil ifTrue: [
		| descriptor |
		descriptor := self sourceDescriptor.
		descriptor isNil ifTrue: [^nil].
		mapping := descriptor mappingForAttributeNamed: name].
	^mapping.
]

{ #category : #'private/initialization' }
MappingExpression >> mapping: aMapping [
	mapping := aMapping.
]

{ #category : #accessing }
MappingExpression >> mappingFromMeOrSubclasses [
	"Return the mapping for me, but if the field is not mapped here, and the class uses inheritance, check for subclasses, and use a random one of the subclass mappings."

	| subclassDescriptors |
	self mapping isNil ifFalse: [^self mapping].
	self sourceDescriptor isNil ifTrue: [^self mapping].
	subclassDescriptors := (self sourceDescriptor typeResolver descriptorsRequiringIndependentQueriesFor: self sourceDescriptor describedClass).
	subclassDescriptors do: [:each | 
		| subMapping |
		subMapping := each mappingForAttributeNamed: name.
		subMapping isNil ifFalse: [^subMapping]].
	"If subclasses didn't work, just fall through to the normal error processing."
	^self mapping.
]

{ #category : #testing }
MappingExpression >> mapsSimpleObject [
	^self mapping mapsSimpleObject.
]

{ #category : #accessing }
MappingExpression >> multipleTableExpressions [
	^self multipleTableExpressionsOn: self.
]

{ #category : #accessing }
MappingExpression >> multipleTableExpressionsOn: anExpression [
	^self mapping multipleTableExpressionsFor: anExpression.
]

{ #category : #preparing }
MappingExpression >> mustReGetMappingIfRebuildingOn: newBase [
	"Return true if we need to do a full get: when rebuilding, rather than being able to preserve the mapping that we had before."

	"If we didn't have a mapping yet, then just do a get"
	mapping isNil ifTrue: [^true].
	"If this is a phantom mapping, we must not try to re-get it."
	self phantom ifTrue: [^false].
	"Otherwise, we're a normal mapping, and we don't need to re-get the mapping unless the class is different, probably because of inheritance. But note that in some cases we may not know our descriptor yet."
	self base hasDescriptor ifFalse: [^false].
	self base descriptor isNil ifTrue: [^false].
	^self base descriptor ~= newBase descriptor.
]

{ #category : #accessing }
MappingExpression >> name [

	^name.
]

{ #category : #'private/initialization' }
MappingExpression >> named: aSymbol basedOn: anExpression [

	name := aSymbol.
	base := anExpression.
	outerJoin := false.
]

{ #category : #api }
MappingExpression >> notEmpty [
	"Only useful for mappings that represent collections. This checks to see if the collection has elements by building a not exists subselect."
	
	^self base existenceCheck: self as: #exists:
]

{ #category : #navigating }
MappingExpression >> penultimateBaseExpression [
	"Return the one from the last base expression in our tree. Useful if we want to find the first mapping involved in the expression"
	self base base isNil ifTrue: [^self].
	^self base penultimateBaseExpression.
]

{ #category : #accessing }
MappingExpression >> phantom [
	^phantom
]

{ #category : #accessing }
MappingExpression >> phantom: aBoolean [
	phantom := aBoolean
]

{ #category : #printing }
MappingExpression >> printOnlySelfOn: aStream [

	aStream nextPutAll: name.
	self printTableAliasesOn: aStream.
]

{ #category : #'printing SQL' }
MappingExpression >> printSQLOn: aStream withParameters: aDictionary [ 
	self hasField ifFalse: [^self].
	self field asField printSQLOn: aStream withParameters: aDictionary.
]

{ #category : #'printing SQL' }
MappingExpression >> printSelectSQLOn: aStream withParameters: aDictionary [ 
	self hasField ifFalse: [^self].
	self field asField printSelectSQLOn: aStream withParameters: aDictionary.
]

{ #category : #printing }
MappingExpression >> printTreeOn: aStream [ 
	aStream
		print: base;
		nextPut: $.;
		nextPutAll: (name isString ifTrue: [name] ifFalse: [name printString])
]

{ #category : #'printing SQL' }
MappingExpression >> printUnqualifiedSQLOn: aStream withParameters: aDictionary [ 
	self field asField printUnqualifiedSQLOn: aStream withParameters: aDictionary.
]

{ #category : #navigating }
MappingExpression >> queryLevelBaseExpression [

	^base queryLevelBaseExpression.
]

{ #category : #preparing }
MappingExpression >> rebuildOn: aBaseExpression startingFrom: anExpression withOuterScopeBase: ultimateBaseExpression [
	
	| expression newBase |
	self == anExpression ifTrue: [^aBaseExpression].
	newBase := base rebuildOn: aBaseExpression startingFrom: anExpression
		withOuterScopeBase: ultimateBaseExpression.	
	"For phantom mappings we have to pass through our mapping since they can't compute their own. For the normal case, if we have a mapping, and our base class hasn't changed, then just re-use the same mapping as an optimization."
	expression := (mapping isNil or: [self mustReGetMappingIfRebuildingOn: newBase])
		ifTrue: [newBase get: name]
		ifFalse: [newBase getMapping: self mapping named: name].
	outerJoin ifTrue: [expression asOuterJoin].
	expression phantom: self phantom.
	^expression.
]

{ #category : #api }
MappingExpression >> referenceClass [
	"Return the class that our mapping refers to, if we have a mapping. If we're a base expression, just return our class, and if we're a table expression, just return nil."
	^self mapping referenceClass.
]

{ #category : #testing }
MappingExpression >> representsDerivedObject [
	^self mapping isRelationship.
]

{ #category : #'private/accessing' }
MappingExpression >> requiresDistinct: aBoolean [
	super requiresDistinct: aBoolean.
	base requiresDistinct: aBoolean.
]

{ #category : #testing }
MappingExpression >> returnsDictionary [
	"Return true if we representa  ampping to a dictionary"
	^self mapping isToManyRelationship and: [self mapping collectionType == Dictionary].
]

{ #category : #preparing }
MappingExpression >> rewriteBooleanEquality: relation [
	"If we are a boolean that doesn't have a comparison relation on top of us, replace us with an ' = true'"

	"Only rewrite booleans"
	(self mapping notNil and: [self mapping attribute type = Boolean]) ifFalse: [^self].

	"See if we're already part of an equality comparison, don't rewrite twice"
	(relation = #= | (relation = #<>) | (relation = #IN)) ifTrue: [^self].
	"If we're a boolean function, we don't need or want the comparison. e.g. EXISTS. This is a bit hard to test for."
	(self mapping field isGlorpExpression and: [self mapping field field isNil]) ifTrue: [^self].

	^self get: #= withArguments: (Array with: true asGlorpExpression).
]

{ #category : #accessing }
MappingExpression >> sourceDescriptor [
	^base descriptor.
]

{ #category : #api }
MappingExpression >> sqlSelect: anExpression [
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
]

{ #category : #accessing }
MappingExpression >> system [
	^base system.
]

{ #category : #accessing }
MappingExpression >> table [
	self hasDescriptor ifTrue: [^self descriptor primaryTable].
	^self field table.
]

{ #category : #accessing }
MappingExpression >> tables [

	self controlsTables ifFalse: [^#()].
	^self tablesContainingMe.
]

{ #category : #accessing }
MappingExpression >> tablesContainingMe [
	"Return a list of tables that contain this object, whether or not we control them. This is mostly the same as tables, but will differ for embedded mappings."
	| set |
	self descriptor isNil ifTrue: [^#()].
	set := self descriptor tables asSet.
	^set.
]

{ #category : #preparing }
MappingExpression >> tablesToPrint [

	self hasDescriptor ifFalse: [^#()].
	^self tables collect: [:each |
		self aliasedTableFor: each].
]

{ #category : #preparing }
MappingExpression >> translateField: aDatabaseField [
	| translatedField |
	translatedField := (self mapping translateFields: (Array with: aDatabaseField)) first.
	^super translateField: (translatedField isNil ifTrue: [aDatabaseField] ifFalse: [translatedField]).
]

{ #category : #preparing }
MappingExpression >> translateFields: anOrderedCollection [ 
	"Ugh. Unify these mechnisms"
	^super translateFields: (self mapping translateFields: anOrderedCollection).
]

{ #category : #navigating }
MappingExpression >> ultimateBaseExpression [

	^base ultimateBaseExpression.
]

{ #category : #preparing }
MappingExpression >> validate [
	self mappingFromMeOrSubclasses isNil ifTrue: [self error: 'no mapping for ', self printString].
]

{ #category : #converting }
MappingExpression >> valueInBuilder: anElementBuilder [
	^self valueInBuilder: anElementBuilder as: self base.
]

{ #category : #converting }
MappingExpression >> valueInBuilder: anElementBuilder as: anExpression [
	^self mapping valueIn: anElementBuilder as: anExpression.
]

{ #category : #testing }
MappingExpression >> willPrintAsWhereClause [
	^self hasField.
]

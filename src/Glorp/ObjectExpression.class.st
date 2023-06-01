"
This is a not-especially well-named superclass for expressions that end up mapping to rows in the database, more or less. That is, it's more or less a superclass for things that have the capacity to alias tables, and to have mapping expressions derived from them. Since, depending on your point of view, everything is an object, the name isn't very descriptive. Or if some things aren't considered objects, TableExpression is a good candidate. But we have the common functionality for managing tables, and for keeping a dictionary of our sub-mapping expressions.

Subclasses must implement the following messages:
	accessing
		system
		table
	fields
		controlsTables

Instance Variables:
	fieldAliases	<Dictionary from: DatabaseField to: DatabaseField>	For each field, the corresponding aliased field for our query. So, e.g. PERSON.NAME will map to t1.NAME. These aren't strings, though, these are fields derived from the aliased table.
	mappingExpressions	<Dictionary from: Symbol to: ( MappingExpression | TableExpression) >	Each attribute that's derived from us will be maintained in this dictionary. This is very important, because Glorp relies critically on these expressions being identical. So ""object field == object field"".
	requiresDistinct	<Boolean>	Do the fields that we will cause to be added to the SELECT portion of the query need a DISTINCT wrapped around them?
	tableAliases	<Dictionary from: DatabaseTable to: DatabaseTable>	While the query is being prepared, tables will be assigned aliases. This keeps track of the aliases for the tables that we control. As with fieldAliases, note that this stores table copies with their names altered, not strings.


"
Class {
	#name : #ObjectExpression,
	#superclass : #GlorpExpression,
	#instVars : [
		'mappingExpressions',
		'requiresDistinct',
		'tableAliases',
		'fieldAliases'
	],
	#category : #'Glorp-Expressions'
}

{ #category : #'api-aggregates' }
ObjectExpression >> aggregate: anExpression as: aggregateFunctionName [

	^ self aggregate: anExpression as: aggregateFunctionName where: nil
]

{ #category : #'api-aggregates' }
ObjectExpression >> aggregate: anExpression as: aggregateFunctionName where: whereExpression [
	"Make a subselect of the expression that is our argument, returning an aggregated value. e.g.
session read: GlorpCustomer where: 	[:each |  
	(each aggregate: eachCust accounts as: #countStar where: [:acct | acct price > 1000]]) = 1].
	This is the most general form of aggregation convenience method, and everything else is implemented in terms of it"

	| q expression next objectExpression retrievalExpression basicExpression |
	"We may be passed an expression corresponding to either a field, or to a full object, depending on the aggregate function. In either case, build backwards from the first full object"
	objectExpression := anExpression mapping isRelationship 
		ifTrue: [anExpression] ifFalse: [anExpression base].
	q := Query read: objectExpression referenceClass.
	expression := q baseExpression.
	next := objectExpression.
	[next base isNil] whileFalse: [
		expression := next mapping addPhantomMappingExpressionOn: expression.
		next := next base].
	"We have to force construct the equality expression, because we don't want 'self' rebuilt onto the other base"
	expression := RelationExpression new outerJoin: false; relation: #=; leftChild: expression; rightChild: self.
	q whereClause: expression.
	"We need to rebuild the thing we're using to retrieve in the right context. Also, if we're called directly, the symbol may be wrapped as a constantExpression. Unwrap it"
	basicExpression := anExpression rebuildOn: q baseExpression startingFrom: objectExpression.
	retrievalExpression := (basicExpression get: aggregateFunctionName asGlorpExpression value).
	q retrieve: retrievalExpression.
	whereExpression == nil ifFalse: [
		q AND: (whereExpression asGlorpExpressionOn: basicExpression)].
	^q asGlorpExpressionOn: self ultimateBaseExpression.
]

{ #category : #fields }
ObjectExpression >> aliasTable: aDatabaseTable to: aString [

	| newTable |
	newTable := aDatabaseTable copy.
	newTable name: aString.
	newTable parent: aDatabaseTable.
	newTable schema: ''.
	self tableAliases at: aDatabaseTable put: newTable
]

{ #category : #fields }
ObjectExpression >> aliasedTableFor: aDatabaseTable [

	tableAliases isNil ifTrue: [ ^ aDatabaseTable ].
	aDatabaseTable isAliased ifTrue: [ ^ aDatabaseTable ].
	^ tableAliases at: aDatabaseTable ifAbsent: [
		  (self tables includes: aDatabaseTable)
			  ifTrue: [
			  self error: 'Bug. Expression has only partially aliased tables' ]
			  ifFalse: [
				  | tableExpression |
				  tableExpression := self mappingExpressions
					                     at: aDatabaseTable
					                     ifAbsent: [ nil ].
				  tableExpression isNil
					  ifTrue: [ aDatabaseTable ]
					  ifFalse: [ tableExpression aliasedTableFor: aDatabaseTable ] ] ]
]

{ #category : #fields }
ObjectExpression >> aliasedTableFor: aDatabaseTable ifAbsent: aBlock [

	tableAliases isNil ifTrue: [ ^ aBlock value ].
	aDatabaseTable isAliased ifTrue: [ ^ aDatabaseTable ].
	^ tableAliases at: aDatabaseTable ifAbsent: [ aBlock value ]
]

{ #category : #internal }
ObjectExpression >> anySatisfyDefault: anExpression [

	^ (self system isNil or: [ self system useJoinsForAnySatisfy ])
		  ifTrue: [ self anySatisfyJoin: anExpression ]
		  ifFalse: [ self anySatisfyExists: anExpression ]
]

{ #category : #internal }
ObjectExpression >> anySatisfyExists: anExpression [ 
	| newExpression |
	anExpression isConstantExpression ifTrue: [self error: 'The argument to anySatisfy: must be a block evaluating to a boolean condition.'].
	newExpression := SubSelectExpression 
		named: #anySatisfy:
		basedOn: self
		withArguments: (Array with: anExpression).
	^newExpression.
]

{ #category : #internal }
ObjectExpression >> anySatisfyJoin: anExpression [ 
	| newExpression |
	anExpression isConstantExpression ifTrue: [self error: 'The argument to anySatisfy: must be a block evaluating to a boolean condition.'].
	self base requiresDistinct: true.
	newExpression := CollectionExpression 
		named: #anySatisfy:
		basedOn: self
		withArguments: (Array with: anExpression).
	self base removeMappingExpression: self.
	^newExpression.
]

{ #category : #'api-aggregates' }
ObjectExpression >> asDate [
	"Cast the receiver to be a date"

	^ self
		  getFunction: #cast:
		  withArguments:
		  (Array with: self system platform date asGlorpExpression)
]

{ #category : #'api-aggregates' }
ObjectExpression >> asTimestamp [
	"Cast the receiver to be a timestamp"

	^ self
		  getFunction: #cast:
		  withArguments:
		  (Array with: self system platform timestamp asGlorpExpression)
]

{ #category : #preparing }
ObjectExpression >> assignTableAliasesStartingAt: anInteger prefix: aString [

	| tableNumber prefix |
	self controlsTables ifFalse: [ ^ anInteger ].
	self hasTableAliases ifTrue: [ ^ anInteger ].
	tableNumber := anInteger.
	prefix := aString isNil
		          ifTrue: [ 't' ]
		          ifFalse: [ aString ].
	self tables do: [ :each |
		self aliasTable: each to: prefix , tableNumber printString.
		tableNumber := tableNumber + 1 ].
	^ tableNumber
]

{ #category : #'api-aggregates' }
ObjectExpression >> average: anExpression [

	^ self aggregate: anExpression as: #average
]

{ #category : #testing }
ObjectExpression >> canTranslateFields [
	"Return true if we are a mapping expression and can thus translate from fields into their aliased version for a particular query. More generally, do we respond to translateField:"

	^ true
]

{ #category : #fields }
ObjectExpression >> controlsTables [

	self subclassResponsibility
]

{ #category : #'api-aggregates' }
ObjectExpression >> count: anExpression [
	"Make a subselect of the expression that is our argument, returning a count(*). e.g.
session read: GlorpCustomer where: 	[:each |  (each count: [:eachCust | eachCust accounts]) = 1]."

	^ self aggregate: anExpression as: #countStar
]

{ #category : #'api-aggregates' }
ObjectExpression >> count: anExpression where: filterExpression [
	"Make a subselect of the expression that is our argument, returning a count(*). e.g.
session read: GlorpCustomer where: 	[:each |  (each count: [:eachCust | eachCust accounts]) = 1]."
	^self aggregate: anExpression as: #countStar where: filterExpression.
]

{ #category : #'api-aggregates' }
ObjectExpression >> existenceCheck: anExpression as: functionName [
	"Make a subselect of the expression that is our argument, returning it wrapped in either an exists or a not exists, e.g. 
	session read: GlorpCustomer where: 	[:each |  
		each existenceCheck: eachCust accounts as: #exists:].
	This is the most general form of existence checking convenience method, others are implemented in terms of it. It's very similar to aggregate:as:where:, but simpler."

	| q expression next objectExpression |
	"We may be passed an expression corresponding to either a field, or to a full object, depending on the aggregate function. In either case, build backwards from the first full object"
	objectExpression := anExpression mapping isRelationship 
		ifTrue: [anExpression] ifFalse: [anExpression base].
	q := Query read: objectExpression mapping referenceClass.
	expression := q baseExpression.
	next := objectExpression.
	[next base isNil] whileFalse: [
		expression := next mapping addPhantomMappingExpressionOn: expression.
		next := next base].
	"We have to force construct the equality expression, because we don't want 'self' rebuilt onto the other base"
	expression := RelationExpression new outerJoin: false; relation: #=; leftChild: expression; rightChild: self.
	q whereClause: expression.
	"Just read back a literal constant, we don't actually care about the data"
	q retrieve: ([:each | 'x' ] asGlorpExpression getFunction: #distinct withArguments: #()).
	^self get: functionName withArguments: (Array with: (q asGlorpExpressionOn: self ultimateBaseExpression)).
]

{ #category : #accessing }
ObjectExpression >> fieldAliases [

	fieldAliases isNil ifTrue: [fieldAliases := IdentityDictionary new].
	^fieldAliases.
]

{ #category : #fields }
ObjectExpression >> findFieldNamed: aString [
	| fields |
	fields := OrderedCollection new: 1.
	self tables do: [:each |
		| field |
		field := each fieldNamed: aString ifAbsent: [nil].
		field isNil ifFalse: [fields add: field]].
	fields isEmpty ifTrue: [self error: 'No field named ', aString, ' in ', self printString].
	fields size > 1 ifTrue: [self error: 'Ambiguous field ', aString, ' in ', self printString].
	^ fields at: 1
]

{ #category : #api }
ObjectExpression >> get: aSymbol [ 
	"Return the mapping expression corresponding to the named attribute"

	| reallyASymbol functionExpression |
	reallyASymbol := aSymbol asSymbol.
	functionExpression := self getFunction: aSymbol withArguments: #().
	functionExpression isNil ifFalse: [^functionExpression].
	^self mappingExpressions at: reallyASymbol
		ifAbsentPut: [MappingExpression named: reallyASymbol basedOn: self ]
]

{ #category : #api }
ObjectExpression >> get: aSymbol withArguments: anArray [ 

	| specialExpression functionExpression |
	functionExpression := self getFunction: aSymbol withArguments: anArray.
	functionExpression isNil ifFalse: [^functionExpression].
	specialExpression := self performSpecialExpression: aSymbol withArguments: anArray.
	specialExpression isNil ifFalse: [^specialExpression].
	anArray isEmpty ifTrue: [^self get: aSymbol].
	^RelationExpression
		named: aSymbol
		basedOn: self
		withArguments: anArray
]

{ #category : #api }
ObjectExpression >> getConstant: anObject [
	"Allows us to refer to a constant object easily. This is most useful for subselects, where I can already write something like
   [:each | (each count: subQuery) = 5]
but since the subselect part might be very verbose, I might prefer to put the constant value first. I can't write
   [:each | 5 = (each count: subQuery)]
because then the left-hand side expression doesn't refer back to the block argument, and we can't build the expression correctly. So I can write
   [:each | (each getConstant: 5) = (each count: subQuery)]"

	^ anObject asGlorpExpressionOn: self
]

{ #category : #api }
ObjectExpression >> getField: aField [

	| realField |
	realField := aField isString
		ifTrue: [self findFieldNamed: aField]
		ifFalse: [aField].
	"This might be an expression, most notably a constant expression, in which case it either contains a string or a field. This is awfully ugly"
	realField isGlorpExpression
		ifTrue:
			[realField class == ConstantExpression
				ifTrue:
					[realField := realField value isString
						ifTrue: [realField := self findFieldNamed: realField value]
						ifFalse: [realField]]].
	^self getFieldKnownNotToBeAName: realField
]

{ #category : #api }
ObjectExpression >> getFieldKnownNotToBeAName: aField [
	"The public getField method may, for convenience, be passed a string or a constant expression with a string that is a field name. This is a mess, and can be confused with a constant value. This method does not allow that."

	| realField |
	realField := aField.
	realField isGlorpExpression
		ifTrue:
			[realField class == ConstantExpression ifTrue: [^realField].
			realField class == ParameterExpression
				ifTrue: [realField := realField field]].
	^self getFieldThatsAnActualFieldObject: realField
]

{ #category : #api }
ObjectExpression >> getFieldThatsAnActualFieldObject: aField [
	"If the field isn't from our table, do a getTable first. If we don't know, assume we can get it directly."

	self controlsTables ifFalse: [^self base getFieldThatsAnActualFieldObject: (self translateField: aField)].
	^((self hasDescriptor not) or: [self tables includes: aField table])
		ifTrue:
			[self mappingExpressions
				at: aField
				ifAbsentPut: [self newFieldExpressionFor: aField]]
		ifFalse: [(self getTable: aField table) getField: aField]
]

{ #category : #api }
ObjectExpression >> getMapping: aMapping named: aString [
	"Get a mapping expression given the actual mapping (this is most useful for an anonymous mapping that isn't named or in our descriptor). Only if you really know what you're doing!. Short circuit looking up the mapping, checking for functions, and so on."

	^ self mappingExpressions at: aString
		ifAbsentPut: [ | expression |
			expression := MappingExpression named: aString basedOn: self.
			expression mapping: aMapping.
			expression]
]

{ #category : #api }
ObjectExpression >> getParameter: aDatabaseField [

	^ ParameterExpression forField: aDatabaseField basedOn: self
]

{ #category : #api }
ObjectExpression >> getTable: aTable [
	"This can take a string, a constantExpression containing a string, or a table object"

	| realTable |
	realTable := aTable isString
		ifTrue: [self system tableNamed: aTable]
		ifFalse: [aTable].	"This might be an expression, most notably a constant expression, in which case it either contains a string or a field"
	realTable isGlorpExpression
		ifTrue:
			[realTable value isString
				ifTrue: [realTable := self system tableNamed: realTable value]
				ifFalse: [realTable := realTable value]].
	^self mappingExpressions
		at: realTable
		ifAbsentPut: [TableExpression forTable: realTable basedOn: self]
]

{ #category : #testing }
ObjectExpression >> hasField [

	^ false
]

{ #category : #testing }
ObjectExpression >> hasProvidedAdditionalExpressions [
	"Return true if we have already provided additional expressions to some query. Only important when we're preparing a subselect and don't want to bring in joins that are part of the main query"

	^ self hasTableAliases
]

{ #category : #testing }
ObjectExpression >> hasTableAliases [

	^ tableAliases notNil
]

{ #category : #internal }
ObjectExpression >> includes: anObject [
	"Allow us to specify includes: as a shortcut for (anySatisfy: [:each | each = anObject]). Rather than just call anySatisfy:, we need to go through the get: mechanism, both to avoid the anySatisfy: method on expressions that treats them like a collection, and to make sure we get the default mechanism for anySatisfy: (either joins or exists)"

	^ self
		  get: #anySatisfy:
		  withArguments:
		  (Array with:
			   ([ :each | each = anObject ] asGlorpExpressionOn: self))
]

{ #category : #initialization }
ObjectExpression >> initialize [

	super initialize.
	requiresDistinct := false
]

{ #category : #accessing }
ObjectExpression >> mappingExpressions [

	mappingExpressions isNil ifTrue: [
		mappingExpressions := IdentityDictionary new ].
	^ mappingExpressions
]

{ #category : #accessing }
ObjectExpression >> mappingExpressions: anObject [
	mappingExpressions := anObject
]

{ #category : #'api-aggregates' }
ObjectExpression >> max: anExpression [

	^ self aggregate: anExpression as: #max
]

{ #category : #'api-aggregates' }
ObjectExpression >> min: anExpression [

	^ self aggregate: anExpression as: #min
]

{ #category : #fields }
ObjectExpression >> newFieldExpressionFor: aField [

	^ FieldExpression forField: aField basedOn: self
]

{ #category : #internal }
ObjectExpression >> noneSatisfy: anExpression [

	| newExpression |
	newExpression := SubSelectExpression
		                 named: #noneSatisfy:
		                 basedOn: self
		                 withArguments: (Array with: anExpression).
	^ newExpression
]

{ #category : #internal }
ObjectExpression >> noneSatisfyExists: anExpression [

	| newExpression |
	newExpression := SubSelectExpression
		                 named: #noneSatisfy:
		                 basedOn: self
		                 withArguments: (Array with: anExpression).
	^ newExpression
]

{ #category : #internal }
ObjectExpression >> oneArgumentSpecialSelectors [

	^ #( #anySatisfyDefault: #anySatisfyJoin: #anySatisfyExists:
	     #getTable: #getField: #fieldNamed: #parameter: #noneSatisfy:
	     #noneSatisfyExists: #getConstant: #count: #sum: #min: #max:
	     #average: #sqlSelect: #includes: )
]

{ #category : #internal }
ObjectExpression >> performSpecialExpression: aSymbol withArguments: anArray [

	| symbolToPerform |
	symbolToPerform := self specialSymbolToPerformFor: aSymbol.
	(self zeroArgumentSpecialSelectors includes: symbolToPerform) ifTrue: [^self perform: symbolToPerform].
	(self oneArgumentSpecialSelectors includes: symbolToPerform) ifTrue: [^self perform: symbolToPerform with: anArray first ].
	(self twoArgumentSpecialSelectors includes: symbolToPerform) ifTrue: [^self perform: symbolToPerform with: (anArray at: 1) with: (anArray at: 2)].
	^ nil
]

{ #category : #printing }
ObjectExpression >> printTableAliasesOn: aStream [

	self hasTableAliases ifTrue: [
		aStream nextPutAll: ' '.
		tableAliases keysAndValuesDo: [ :eachKey :eachValue |
			aStream nextPutAll: eachKey name , '->' , eachValue name , ' ' ] ]
]

{ #category : #api }
ObjectExpression >> referenceClass [
	"Return the class that our mapping refers to, if we have a mapping. If we're a base expression, just return our class, and if we're a table expression, just return nil."

	^ self subclassResponsibility
]

{ #category : #'private/accessing' }
ObjectExpression >> removeMappingExpression: anExpression [
	"Private. Normally you would never do this, but in the case of an anySatisfy: or allSatisfy: we want to have each of them as distinct joins, so we will remove the entry from the mappingExpression of the base, making sure that relationship will not be used for anything else. Since any/allSatisfy: is the only valid use of a collection relationship, we don't have to worry about whether it was used for something else earlier."

	self mappingExpressions removeKey: anExpression name
]

{ #category : #'private/accessing' }
ObjectExpression >> requiresDistinct [

	^ requiresDistinct
]

{ #category : #'private/accessing' }
ObjectExpression >> requiresDistinct: aBoolean [

	requiresDistinct := aBoolean
]

{ #category : #internal }
ObjectExpression >> specialSymbolToPerformFor: aSymbol [
	"Avoid polymorphism between things you can send to an expression inside a query block and things you can do to an expression to iterate over an expression true"

	aSymbol == #anySatisfy: ifTrue: [ ^ #anySatisfyDefault: ].
	aSymbol == #select: ifTrue: [ ^ #sqlSelect: ].
	^ aSymbol
]

{ #category : #'api-aggregates' }
ObjectExpression >> sqlAverage [
	"Make a subselect of the expression that is our argument, returning an avg(). e.g.
session read: GlorpCustomer where: 	[:each |  each accounts balance sqlAverage > 100]."

	^ self queryLevelBaseExpression average: self
]

{ #category : #'api-aggregates' }
ObjectExpression >> sqlAvg [
	"Make a subselect of the expression that is our argument, returning an avg(). e.g.
session read: GlorpCustomer where: 	[:each |  each accounts balance sqlAvg > 100]."

	^ self queryLevelBaseExpression average: self
]

{ #category : #'api-aggregates' }
ObjectExpression >> sqlCount [
	"Make a subselect of the expression that is our argument, returning a count(). e.g.
session read: GlorpCustomer where: 	[:each |  each accounts sqlCount = 1]."

	^ self queryLevelBaseExpression count: self
]

{ #category : #'api-aggregates' }
ObjectExpression >> sqlCountWhere: filterExpression [
	"Make a subselect of the expression that is our argument, returning a count(). e.g.
session read: GlorpCustomer where: 	[:each |  each accounts sqlCount = 1]."

	^ self queryLevelBaseExpression count: self where: filterExpression
]

{ #category : #'api-aggregates' }
ObjectExpression >> sqlMax [
	"Make a subselect of the expression that is our argument, returning a max(). e.g.
session read: GlorpCustomer where: 	[:each |  each accounts balance sqlMax = 1]."

	^ self queryLevelBaseExpression max: self
]

{ #category : #'api-aggregates' }
ObjectExpression >> sqlMin [
	"Make a subselect of the expression that is our argument, returning a minimum. e.g.
session read: GlorpCustomer where: 	[:each |  each accounts balance sqlMin = 1]."

	^ self queryLevelBaseExpression min: self
]

{ #category : #'api-aggregates' }
ObjectExpression >> sqlSum [
	"Make a subselect of the expression that is our argument, returning a count(*). e.g.
session read: GlorpCustomer where: 	[:each |  each accounts balance sqlSum = 1]."

	^ self queryLevelBaseExpression sum: self
]

{ #category : #'api-aggregates' }
ObjectExpression >> sum: anExpression [
	"Make a subselect of the expression that is our argument, returning a sum. e.g.
session read: GlorpCustomer where: 	[:each |  (each sum: [:eachCust | eachCust accounts id]) > 5]."

	^ self aggregate: anExpression as: #sum
]

{ #category : #accessing }
ObjectExpression >> system [
	self subclassResponsibility.
]

{ #category : #accessing }
ObjectExpression >> table [

	self subclassResponsibility
]

{ #category : #accessing }
ObjectExpression >> tableAliases [

	tableAliases isNil ifTrue: [
		tableAliases := IdentityDictionary new: 3 ].
	^ tableAliases
]

{ #category : #fields }
ObjectExpression >> translateField: aDatabaseField [

	| newTable rebuilt |
	rebuilt := aDatabaseField isGlorpExpression
		           ifTrue: [
			           aDatabaseField
				           asGlorpExpressionOn: self
				           withUltimateBase: self ultimateBaseExpression ]
		           ifFalse: [ aDatabaseField ].
	newTable := self aliasedTableFor: rebuilt table.
	newTable == rebuilt table ifTrue: [ ^ rebuilt ].
	^ self fieldAliases
		  at: aDatabaseField
		  ifAbsentPut: [ rebuilt withTable: newTable ]
]

{ #category : #fields }
ObjectExpression >> translateFields: anOrderedCollection [

	^ anOrderedCollection collect: [ :each | self translateField: each ]
]

{ #category : #internal }
ObjectExpression >> twoArgumentSpecialSelectors [

	^ #( #aggregate:as: )
]

{ #category : #internal }
ObjectExpression >> zeroArgumentSpecialSelectors [

	^ #( #asOuterJoin #sqlCount #sqlSum #sqlMin #sqlMax #sqlAverage
	     #sqlAvg #isEmpty #notEmpty #asDate #asTimestamp #bePhantom )
]

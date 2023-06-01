"
This is the superclass of Glorp expression tree nodes. These are used to represent the where clause of a query, or things that describe relationships between objects and/or represent boolean expressions evaluated against them. They are typically created by converting a block into an expression using asGlorpExpression. Then they are used in generating the SQL string to be sent to the database.

Subclasses must implement the following messages:
	accessing
		canHaveBase
	api
		base
		get:withArguments:
	converting
		asJoin
	navigating
		ultimateBaseExpression
	preparing
		asExpressionJoiningSource:toTarget:
		rebuildOn:startingFrom:withOuterScopeBase:
	printing
		printOnlySelfOn:
		printTreeOn:


"
Class {
	#name : #GlorpExpression,
	#superclass : #Object,
	#category : #'Glorp-Expressions'
}

{ #category : #'instance creation' }
GlorpExpression class >> new [

	^super new initialize
]

{ #category : #api }
GlorpExpression >> , anExpression [

	^ self get: #, withArguments: (Array with: anExpression asGlorpExpression)
]

{ #category : #api }
GlorpExpression >> AND: anExpression [
	"This method doesn't really have to exist, because it would be inferred using operationFor:, but it's included here for efficiency and to make it a little less confusing how relation expression get created. Note that the two expression must already be  built on the same base!"

	anExpression isNil ifTrue: [^self].
	anExpression == true ifTrue: [^self].
	anExpression == false ifTrue: [^false].
	(anExpression isGlorpExpression and: [anExpression isEmptyExpression]) ifTrue: [^self].
	
	^ RelationExpression named: #AND basedOn: self withArguments: (Array with: anExpression) 
]

{ #category : #api }
GlorpExpression >> AND: anExpression AND: otherExpression [
	"A convenience method to allow easy conjunction of multiple ANDs at the same level"

	^ (self AND: anExpression) AND: otherExpression
]

{ #category : #api }
GlorpExpression >> AND: anExpression AND: otherExpression AND: thirdExpression [
	"A convenience method to allow easy conjunction of multiple ANDs at the same level"
	
	^((self AND: anExpression) AND: otherExpression) AND: thirdExpression
]

{ #category : #api }
GlorpExpression >> AND: anExpression AND: otherExpression AND: thirdExpression AND: fourthExpression [
	"A convenience method to allow easy conjunction of multiple ANDs at the same level"

	^(((self AND: anExpression) AND: otherExpression) AND: thirdExpression) AND: fourthExpression
]

{ #category : #api }
GlorpExpression >> OR: anExpression [
	"This method doesn't really have to exist, because it would be inferred using operationFor:, but it's included here for efficiency and to make it a little less confusing how relation expression get created.  Note that the two expression must already be  built on the same base!"
	anExpression isNil ifTrue: [^self].	
	anExpression == true ifTrue: [^true].
	anExpression == false ifTrue: [^self].
	(anExpression isGlorpExpression and: [anExpression isEmptyExpression]) ifTrue: [^self].
	^RelationExpression named: #OR basedOn: self withArguments: (Array with: anExpression).
]

{ #category : #preparing }
GlorpExpression >> addBoundExpressionsIn: aQuery to: boundExpressions [
]

{ #category : #preparing }
GlorpExpression >> addToTargetFields: aCollection [
	"If we can provide target fields, add them to the collection"

	^ self
]

{ #category : #preparing }
GlorpExpression >> additionalExpressions [

	^ #(  )
]

{ #category : #preparing }
GlorpExpression >> additionalExpressionsIn: aQuery [
	"Return the collection of additional expressions (representing joins) that this expression tree requires. Because some additional expressions may in turn have their own additional expressions (mapping joins represented by general expressions), repeat until we don't get any more."

	| allExpressions newExpressions allNewExpressions expressionsConsidered |
	allExpressions := ExpressionGroup with: self.
	allExpressions addAll: aQuery ordering.
	allExpressions addAll: aQuery grouping.
	allExpressions addAll: aQuery tracing additionalExpressions.
	expressionsConsidered := IdentitySet new.
	allNewExpressions := OrderedCollection new.
	newExpressions := nil.
	[newExpressions := (newExpressions isNil ifTrue: [allExpressions] ifFalse: [newExpressions])
		inject: ExpressionGroup new
		into: [:sum :each |
			((expressionsConsidered includes: each) not and: [
				each queryLevelBaseExpression == aQuery baseExpression]) ifTrue: [
					sum addAll: each additionalExpressions.
					expressionsConsidered add: each].
			sum].
	allNewExpressions addAll: newExpressions children.
	newExpressions isEmpty] whileFalse.
	^ allNewExpressions
]

{ #category : #preparing }
GlorpExpression >> allControlledTables [
	"Return all the tables that we control, directly or indirectly. Basically, if we are a mapping expression with a link table, return the link table as well as any tables of ours."

	^ self tables
]

{ #category : #preparing }
GlorpExpression >> allRelationsFor: rootExpression do: aBlock andBetweenDo: anotherBlock [
	"In any normal relationship, there's only one thing. Just do it"

	aBlock value: rootExpression leftChild value: rootExpression rightChild
]

{ #category : #iterating }
GlorpExpression >> allSatisfy: aBlock [
	"Answer true if aBlock answers true for any element of the receiver.
	 An empty collection answers false."

	self do: [ :each | (aBlock value: each) ifFalse: [ ^ false ] ].
	^ true
]

{ #category : #preparing }
GlorpExpression >> allTables [

	^ self inject: Set new into: [ :sum :each |
		  sum addAll: each tables.
		  sum ]
]

{ #category : #preparing }
GlorpExpression >> allTablesToPrint [

	^ self inject: Set new into: [ :sum :each |
		  sum addAll: each tablesToPrint.
		  sum ]
]

{ #category : #preparing }
GlorpExpression >> allTablesToPrintStoppingAt: aSubSelectBaseExpression [

	^ self inject: Set new into: [ :sum :each |
		  each queryLevelBaseExpression == aSubSelectBaseExpression ifTrue: [
			  sum addAll: each tablesToPrint ].
		  sum ]
]

{ #category : #iterating }
GlorpExpression >> anySatisfy: aBlock [
	"Answer true if aBlock answers true for any element of the receiver.
	 An empty collection answers false."

	self do: [ :each | (aBlock value: each) ifTrue: [ ^ true ] ].
	^ false
]

{ #category : #converting }
GlorpExpression >> asDistinctFieldOn: anExpression [

	^ (self asGlorpExpressionOn: anExpression) get: #distinct withArguments: #()
]

{ #category : #preparing }
GlorpExpression >> asExpressionJoiningSource: source toTarget: target [
	"Create a general expression which represents this relationship where the values of the targets (which are normally parameters) are supplied out of the context provided by 'target' and the source fields are referencing things out of the context of source. Produces something suitable for ANDing into an expression when doing a join
   Example: If we had CUSTOMER.ADDRESS_ID = ADDRESS.ID as a parameter, and we want to AND this into an expression [:customer | customer address street = 'Main'] then we have customer as a base, and we get
	(customer.ADDRESS.STREET = 'Main') AND (customer.CUSTOMER.ADDRESS_ID = customer.ADDRESS.ID)
	The primary key expression for the relationship has been translated into field references into the customer and address tables in a particular context."

	self subclassResponsibility
]

{ #category : #converting }
GlorpExpression >> asField [
	"If we correspond to a single field, return it"

	^ self field
]

{ #category : #converting }
GlorpExpression >> asGeneralGlorpExpression [
	"Convert the result to a general (tree-format) expression, if it's the more limited join expression"

	^ self
]

{ #category : #converting }
GlorpExpression >> asGeneralGlorpExpressionWithFields [
	"Convert the result to a general (tree-format) expression, if it's the more limited join expression."

	^ self
]

{ #category : #api }
GlorpExpression >> asGlorpExpression [

	^ self
]

{ #category : #converting }
GlorpExpression >> asGlorpExpressionForDescriptor: aDescriptor [

	self ultimateBaseExpression descriptor: aDescriptor
]

{ #category : #converting }
GlorpExpression >> asGlorpExpressionOn: aBaseExpression [

	aBaseExpression ultimateBaseExpression == self ultimateBaseExpression
		ifTrue: [ ^ self ].
	^ self rebuildOn: aBaseExpression
]

{ #category : #converting }
GlorpExpression >> asGlorpExpressionOn: aBaseExpression basedOn: oldBaseExpression withUltimateBase: ultimateBaseExpression [

	^ self
		rebuildOn: aBaseExpression
		startingFrom: oldBaseExpression
		withOuterScopeBase: ultimateBaseExpression
]

{ #category : #converting }
GlorpExpression >> asGlorpExpressionOn: aBaseExpression in: aQuery [

	^ self asGlorpExpressionOn: aBaseExpression
]

{ #category : #converting }
GlorpExpression >> asGlorpExpressionOn: anExpression withUltimateBase: aBaseExpression [
	"Build the expression, knowing that some parts of it may refer to an outer context based on aBaseExpression. This is primarily useful for subselect blocks"

	^ self rebuildOn: anExpression startingFrom: self queryLevelBaseExpression withOuterScopeBase: aBaseExpression
]

{ #category : #converting }
GlorpExpression >> asIndependentJoins [
	"If this is an ANDed clause, split it into independent joins"

	^ Array with: self
]

{ #category : #converting }
GlorpExpression >> asJoin [

	self subclassResponsibility
]

{ #category : #converting }
GlorpExpression >> asNonDistinctField [

	^ self
]

{ #category : #preparing }
GlorpExpression >> assignTableAliasesStartingAt: anInteger prefix: aString [

	^ anInteger
]

{ #category : #api }
GlorpExpression >> base [

	self subclassResponsibility
]

{ #category : #accessing }
GlorpExpression >> beOuterJoin [

	^ self
]

{ #category : #preparing }
GlorpExpression >> bindingType [

	^ self type
]

{ #category : #testing }
GlorpExpression >> canBeUsedForRetrieve [
	"Return true if this is a valid argument for a retrieve: clause"

	^ false
]

{ #category : #testing }
GlorpExpression >> canBind [
	"Return true if this represents a value that can be bound into a prepared statement"

	^ false
]

{ #category : #testing }
GlorpExpression >> canHaveBase [
	"Return true if this type of expression can have a base expression on which other things can be built. Doesn't say whether we actually have a valid one or not."

	^ self subclassResponsibility
]

{ #category : #testing }
GlorpExpression >> canKnit [
	"Return true if, when building objects, we can knit the object corresponding to this expression to a related object. Roughly speaking, is this a mapping expression"

	^ false
]

{ #category : #testing }
GlorpExpression >> canPrint [
	"Return true if we can print into a where clause"

	^ true
]

{ #category : #testing }
GlorpExpression >> canTranslateFields [
	"Return true if we are a mapping expression and can thus translate from fields into their aliased version for a particular query."

	^ false
]

{ #category : #introspection }
GlorpExpression >> className [

	^ self class name
]

{ #category : #iterating }
GlorpExpression >> collect: aBlock [

	| newCollection |
	newCollection := OrderedCollection new.
	self do: [:each | newCollection add: (aBlock value: each)].
	^newCollection
]

{ #category : #preparing }
GlorpExpression >> condenseBooleanEquality [

	^ self
]

{ #category : #preparing }
GlorpExpression >> condenseBooleanEqualityExpressions [

	^ self
]

{ #category : #preparing }
GlorpExpression >> condensePrimaryKeyComparison [

	^ self
]

{ #category : #preparing }
GlorpExpression >> condensePrimaryKeyComparisons [

	^ self
]

{ #category : #iterating }
GlorpExpression >> detect: aBlock [ 
	"Evaluate aBlock with each of the receiver's elements as the argument.
	Answer the first element for which aBlock evaluates to true."

	^self detect: aBlock ifNone: [self notFoundError]
]

{ #category : #iterating }
GlorpExpression >> detect: aBlock ifNone: exceptionBlock [
	"Evaluate aBlock with each of the receiver's elements as the argument.
	Answer the first element for which aBlock evaluates to true."

	self do: [ :each | (aBlock value: each) ifTrue: [ ^ each ] ].
	^ exceptionBlock value
]

{ #category : #displaying }
GlorpExpression >> displayString [

	| stream |
	stream := String new writeStream.
	self printOnlySelfOn: stream.
	^ stream contents
]

{ #category : #iterating }
GlorpExpression >> do: aBlock [
	"Iterate over the expression tree"

	self do: aBlock skipping: Dialect identitySetClass new
]

{ #category : #iterating }
GlorpExpression >> do: aBlock skipping: aSet [
	"Iterate over the expression tree. Keep track of who has already been visited, so we don't get trapped in cycles or visit nodes twice."

	(aSet includes: self) ifTrue: [ ^ self ].
	aSet add: self.
	aBlock value: self
]

{ #category : #api }
GlorpExpression >> equals: anExpression [

	^ RelationExpression
		  named: #=
		  basedOn: self
		  withArguments: (Array with: anExpression)
]

{ #category : #accessing }
GlorpExpression >> field [

	^ nil
]

{ #category : #accessing }
GlorpExpression >> fieldFromMeOrSubclasses [
	"For mapping expression, return the field for this mapping, but if the field is not mapped, and the class uses inheritance, check for subclasses, and use a random one of the subclass mappings. For all others, just return the field."

	^ self field
]

{ #category : #converting }
GlorpExpression >> generalExpressionPart [
	"If we have a mixture of joins and general expressions, return only the general part"

	^ self
]

{ #category : #api }
GlorpExpression >> get: aSymbol withArguments: anArray [

	self subclassResponsibility
]

{ #category : #api }
GlorpExpression >> getFunction: aSymbol withArguments: anArray [

	| expression |
	expression := FunctionExpression
		              for: aSymbol
		              withArguments: anArray
		              basedOn: self.
	expression isNil ifTrue: [ ^ nil ].
	^ expression
]

{ #category : #api }
GlorpExpression >> getFunction: aSymbol withArguments: anArray in: system [

	| expression |
	expression := FunctionExpression
		              for: aSymbol
		              withArguments: anArray
		              basedOn: self
		              system: system.
	expression isNil ifTrue: [ ^ nil ].
	^ expression
]

{ #category : #preparing }
GlorpExpression >> hasBindableExpressionsIn: aCommand [

	^ false
]

{ #category : #accessing }
GlorpExpression >> hasDescriptor [

	^ false
]

{ #category : #testing }
GlorpExpression >> hasImpliedClauses [
	"Return true if this implies additional SQL clauses beyond just a single field expression"

	^ false
]

{ #category : #testing }
GlorpExpression >> hasProvidedAdditionalExpressions [
	"Return true if we have already provided additional expressions to some query. Only important when we're preparing a subselect and don't want to bring in joins that are part of the main query"

	^ true
]

{ #category : #testing }
GlorpExpression >> hasTableAliases [

	^ false
]

{ #category : #initialization }
GlorpExpression >> in: anExpression [

	^ RelationExpression
		  named: #IN
		  basedOn: self
		  withArguments: (Array with: anExpression)
]

{ #category : #initialization }
GlorpExpression >> initialize [
]

{ #category : #iterating }
GlorpExpression >> inject: anObject into: aBlock [

	| sum |
	sum := anObject.
	self do: [ :each | sum := aBlock value: sum value: each ].
	^ sum
]

{ #category : #inspecting }
GlorpExpression >> inspectorHierarchies [

	| hierarchy |
	hierarchy := ((Smalltalk at: #Tools ifAbsent: [ ^ #(  ) ])
		              at: #Trippy
		              ifAbsent: [ ^ #(  ) ])
		             at: #Hierarchy
		             ifAbsent: [ ^ #(  ) ].
	^ Array with: (hierarchy
			   id: #expression
			   label: 'Expression Tree'
			   parentBlock: [ :each | nil ]
			   childrenBlock: [ :each | each inspectorChildren ])
]

{ #category : #converting }
GlorpExpression >> inverseJoin [
	"We assume that only the parts that are actually joins ought to invert"

	| new |
	new := self asGlorpExpressionOn: BaseExpression new.
	new do: [ :each | each replaceJoinsWithInverse ].
	^ new
]

{ #category : #testing }
GlorpExpression >> isConstantExpression [

	^ false
]

{ #category : #testing }
GlorpExpression >> isDistinct [

	^ false
]

{ #category : #testing }
GlorpExpression >> isEmptyExpression [

	^ false
]

{ #category : #testing }
GlorpExpression >> isGlorpExpression [

	^ true
]

{ #category : #testing }
GlorpExpression >> isJoin [

	^ false
]

{ #category : #testing }
GlorpExpression >> isMappable [
	"Return true if we're something that can be returned in a select statement."

	^ true
]

{ #category : #'As yet unclassified' }
GlorpExpression >> isSameAliasedFieldAs: aFieldOrFunction [

	^ self == aFieldOrFunction
]

{ #category : #converting }
GlorpExpression >> onlyJoinParts [
	"Strip out any generic parts, leaving only the things that are actually joins"

	| new |
	new := self asGlorpExpressionOn: BaseExpression new.
	new do: [ :each | each removeNonJoinParts ].
	new := new condenseBooleanEquality.
	new isJoin ifFalse: [
		new do: [ :each | each condenseBooleanEqualityExpressions ] ].
	^ new
]

{ #category : #api }
GlorpExpression >> parameter: aConstantExpression [
	"Create a parameter expression with the given name. But note that the name doesn't have to be a string. Database fields, symbols, and integers are all plausible"

	| value |
	value := aConstantExpression class == ParameterExpression
		         ifTrue: [ aConstantExpression field ]
		         ifFalse: [ aConstantExpression value ].
	^ ParameterExpression forField: value basedOn: self
]

{ #category : #preparing }
GlorpExpression >> prepareIn: aQuery [
	"A little weird, because what we end up asking for additional expressions from, might not be us"

	aQuery adjustWhereClause.
	(aQuery whereClause additionalExpressionsIn: aQuery) do: [ :each |
		(aQuery shouldExpressionBeJoin: each)
			ifTrue: [ aQuery addJoin: each ]
			ifFalse: [ aQuery privateAnd: each ] ]
]

{ #category : #'primary keys' }
GlorpExpression >> primaryKeyFromDictionary: aDictionary [
	"Given a set of parameters, return a primary key suitable for retrieving our target. We can't do this for general expressions, so indicate failure by returning nil"

	^ nil
]

{ #category : #printing }
GlorpExpression >> printOn: aStream [

	self printTreeOn: aStream
]

{ #category : #printing }
GlorpExpression >> printOnlySelfOn: aStream [

	self subclassResponsibility
]

{ #category : #printing }
GlorpExpression >> printTreeOn: aStream [

	self subclassResponsibility
]

{ #category : #accessing }
GlorpExpression >> printsTable [

	^ false
]

{ #category : #navigating }
GlorpExpression >> queryLevelBaseExpression [

	^ self ultimateBaseExpression
]

{ #category : #converting }
GlorpExpression >> rebuildOn: aBaseExpression [

	^ self rebuildOn: aBaseExpression startingFrom: nil
]

{ #category : #preparing }
GlorpExpression >> rebuildOn: aBaseExpression startingFrom: anExpression [
	"Rebuild the expression on the new base. If we encounter anExpression, treat that as the base, and build only from that point up. e.g. if we have a.b.c.d and we rebuildOn: z startingFrom: b, then the result will be z.c.d"

	^ self
		  rebuildOn: aBaseExpression
		  startingFrom: anExpression
		  withOuterScopeBase: nil
]

{ #category : #preparing }
GlorpExpression >> rebuildOn: aBaseExpression startingFrom: anExpression withOuterScopeBase: ultimateBaseExpression [
	"Rebuild the expression on the new base. If we encounter anExpression, treat that as the base, and build only from that point up. e.g. if we have a.b.c.d and we rebuildOn: z startingFrom: b, then the result will be z.c.d. Pieces that aren't based on anExpression should be built onto ultimateBaseExpression instead of aBaseExpression. They represents parts of outer scope trees that are referenced within us.
  Note that anExpression can be nil, but if it is, then ultimateBaseExpression is effectively ignored."

	self subclassResponsibility
]

{ #category : #preparing }
GlorpExpression >> removeNonJoinParts [
	"Remove anything that's not an actual join. Only useful if we have something that has mixed joins and general expressions, where we assume we don't want to use the general ones, because they're not field level."

	^ self
]

{ #category : #preparing }
GlorpExpression >> replaceJoinsWithInverse [
	"If we don't know specifically what to do with a kind of expression, assume it doesn't apply and we should be replacing it with nothing."

	^ self
]

{ #category : #testing }
GlorpExpression >> representsDerivedObject [

	^ false
]

{ #category : #'private/accessing' }
GlorpExpression >> requiresDistinct [

	^ false
]

{ #category : #testing }
GlorpExpression >> returnsDictionary [
	"Return true if we representa  ampping to a dictionary"

	^ false
]

{ #category : #preparing }
GlorpExpression >> rewriteBooleanEquality: relation [
	"Does not apply to general expressions"
]

{ #category : #preparing }
GlorpExpression >> rewriteEquality [

	^ self
]

{ #category : #preparing }
GlorpExpression >> rewriteEqualityExpressions [

	^ self
]

{ #category : #preparing }
GlorpExpression >> rewriteFunctionArguments [
	"If a function needs to adjust its arguments, do that here. The motivating example is one where a string argument is rewritten into a form that's of a different length, e.g. the Postgresql driver does that to strings in Blobs"

	^ self
]

{ #category : #preparing }
GlorpExpression >> rewriteFunctionArgumentsWith: ourArgument [
	"If a function needs to adjust its arguments, do that here. The motivating example is one where a string argument is rewritten into a form that's of a different length, e.g. the Postgresql driver does that to strings in Blobs"

	^ self
]

{ #category : #iterating }
GlorpExpression >> select: aBlock [

	| newCollection |
	newCollection := OrderedCollection new.
	self do: [:each | (aBlock value: each) ifTrue: [newCollection add: each]].
	^newCollection
]

{ #category : #debugging }
GlorpExpression >> sharedPiecesWith: anExpression [
	"Return a set of the pieces we share in common with anExpression. Mostly useful for debugging unwanted sharing, or the lack of wanted sharing. Note that this won't dive down into subselects."

	| myPieces shared |
	myPieces := Dialect identitySetClass new.
	shared := Dialect identitySetClass new.
	self do: [ :each | myPieces add: each ].
	anExpression do: [ :each |
		(myPieces includes: each) ifTrue: [ shared add: each ] ].
	^ shared
]

{ #category : #testing }
GlorpExpression >> shortCircuitOnNullComparison: anObject [
	"Return true if we represent an expression that compares null to a non-nullable value, so we don't ever need to really evaluate it"

	^ false
]

{ #category : #converting }
GlorpExpression >> sourceForTarget: aField [

	^ nil
]

{ #category : #'As yet unclassified' }
GlorpExpression >> sqlString [

	| command |
	command := QuerySelectCommand new
		           useBinding: false;
		           session: self ultimateBaseExpression descriptor session.
	self printSQLOn: command withParameters: #(  ).
	^ command contents
]

{ #category : #preparing }
GlorpExpression >> tableForANSIJoin [
	"Which table will we join to."

	^ nil
]

{ #category : #preparing }
GlorpExpression >> tables [

	^#()
]

{ #category : #preparing }
GlorpExpression >> tablesContainingMe [
	"Return a list of tables that contain this object, whether or not we control them. This is mostly the same as tables, but will differ for embedded mappings."

	^self tables
]

{ #category : #preparing }
GlorpExpression >> tablesToPrint [

	^ #(  )
]

{ #category : #accessing }
GlorpExpression >> type [

	^ self field type
]

{ #category : #navigating }
GlorpExpression >> ultimateBaseExpression [

	self subclassResponsibility
]

{ #category : #preparing }
GlorpExpression >> validate [
]

{ #category : #accessing }
GlorpExpression >> valueIn: aDictionary [
	"Return the value associated with this expression given the parameters in aDictionary. Only meaningful for ParameterExpressions"

	^ self
]

{ #category : #testing }
GlorpExpression >> willPrintAsWhereClause [

	^ true
]

"
This represents a relationship between two sub-expressions, that is something like = or AND. So in object attribute = field, we're the equals node. We have exactly two children, and mostly just print ourselves in between them. However there is some other interesting logic in there about splitting up comparisons between objects into comparisons between keys, and even just printing can get fairly complicated.

Instance Variables:
	leftChild	<GlorpExpression>	The left child.
	rightChild	<GlorpExpression>	The right child.
	outerJoin	<Boolean>	Is this an outer join (only makes sense if we are an equality comparison.
	relation	<String>	The string or symbol that we print for our relationship.


"
Class {
	#name : #RelationExpression,
	#superclass : #GlorpExpression,
	#instVars : [
		'relation',
		'leftChild',
		'rightChild',
		'outerJoin'
	],
	#category : #'Glorp-Expressions'
}

{ #category : #'instance creation' }
RelationExpression class >> named: aSymbol basedOn: anExpression withArguments: anArray [

	^(self new)
		named: aSymbol
		basedOn: anExpression
		withArguments: anArray.
]

{ #category : #preparing }
RelationExpression >> addBoundExpressionsIn: aCommand to: boundExpressions [
	"If our right-child can be used for binding, add it to the list. We need to do this at this level because the expressions themselves don't know what type they'll be matched against"

	| translated |
	rightChild canBind ifFalse: [^self].
	(boundExpressions includes: self) ifTrue: [^self].
	translated := self convertValueOf: rightChild in: aCommand parameters.
	(self useBindingFor: translated to: leftChild type in: aCommand) ifTrue: [boundExpressions add: self].
]

{ #category : #preparing }
RelationExpression >> additionalExpressions [

	^#().
]

{ #category : #'As yet unclassified' }
RelationExpression >> allSourceFields [
	"If we are sending this, then we're treating the expression as a join, for a complex (and probably read-only) relationship. So in that case we want to treat the source fields as the parameters that this expression takes, and specifically the parameters that are based on fields."
	^self inject: OrderedCollection new into: [:sum :each |
		each addToTargetFields: sum.
		sum].
]

{ #category : #'As yet unclassified' }
RelationExpression >> allTargetFields [
	"If we are sending this, then we're treating the expression as a join, for a complex (and probably read-only) relationship. So in that case we want to treat the target fields as being the source fields of the bottom-most mapping. That is, the fields we'll use to connect to the thing we want are the things that our expression's base (which represents the thing we want) would use to connect to the first level mapping arising from it. If we have a relation, that's a bit of a mess, but guess that we want the left child's information."
	^self leftChild allTargetFields.
]

{ #category : #preparing }
RelationExpression >> asExpressionJoiningSource: source toTarget: target [
	"Create a general expression which represents this relationship where the values of the targets (which are normally parameters) are supplied out of the context provided by 'target' and the source fields are referencing things out of the context of source. Produces something suitable for ANDing into an expression when doing a join
   Example: If we had CUSTOMER.ADDRESS_ID = ADDRESS.ID as a parameter, and we want to AND this into an expression [:customer | customer address street = 'Main'] then we have customer as a base, and we get 
	(customer.ADDRESS.STREET = 'Main') AND (customer.CUSTOMER.ADDRESS_ID = customer.ADDRESS.ID)
	The primary key expression for the relationship has been translated into field references into the customer and address tables in a particular context."

	| left right |
	left := leftChild asExpressionJoiningSource: source toTarget: target.
	right := rightChild asExpressionJoiningSource: source toTarget: target.
	^self class new 
		relation: relation;
		leftChild: left;
		rightChild: right.
]

{ #category : #converting }
RelationExpression >> asField [
	^self
]

{ #category : #converting }
RelationExpression >> asGeneralGlorpExpression [
	"Convert the result to a general (tree-format) expression, if it's the more limited join expression."
	| result |
	result := self copy.
	result leftChild: leftChild asGeneralGlorpExpression.
	result rightChild: rightChild asGeneralGlorpExpression.
	^result.
]

{ #category : #converting }
RelationExpression >> asGeneralGlorpExpressionWithFields [
	"Convert the result to a general (tree-format) expression, if it's the more limited join expression."
	| result |
	result := self copy.
	result leftChild: leftChild asGeneralGlorpExpressionWithFields.
	result rightChild: rightChild asGeneralGlorpExpressionWithFields.
	^result.
]

{ #category : #converting }
RelationExpression >> asIndependentJoins [
	| |
	"If this is an ANDed clause, referring to two different tables split it into independent joins"
	relation == #AND ifFalse: [^Array with: self].
	leftChild tablesForANSIJoin asSortedCollection = rightChild tablesForANSIJoin asSortedCollection
		ifTrue: [^Array with: self].
	^(Array with: leftChild with: rightChild) inject: OrderedCollection new into: [:sum :each |
		sum addAll: each asIndependentJoins. sum].
]

{ #category : #converting }
RelationExpression >> asJoin [
	| leftField rightField |
	leftField := self leftChild field.
	rightField := self rightChild field.
	(leftField notNil and: [rightField notNil]) ifTrue: [^Join from: leftField to: rightField].
	^leftChild asJoin, rightChild asJoin.
]

{ #category : #'As yet unclassified' }
RelationExpression >> assembleCompositePrimaryKeyFrom: anArray and: anotherArray [
	"The arrays will be the same size, and if both have non-nil values in a given slot, those values will be the same.  This is caused by the calling method; the array is the size the table's compiosite primary key must be and the values are the values are derived from the field positions."

	1 to: anotherArray size do:
		[:index || other | other := anotherArray at: index.
		other == DatabaseRow emptySlot ifFalse: [anArray at: index put: other]].
	^anArray
]

{ #category : #accessing }
RelationExpression >> beOuterJoin [
	outerJoin := true.
	leftChild beOuterJoin.
	rightChild beOuterJoin.
]

{ #category : #preparing }
RelationExpression >> bindingIn: aCommand [

	^self convertValueOf: rightChild in: aCommand parameters.
]

{ #category : #preparing }
RelationExpression >> bindingType [
	"If we're to be used for binding, return the field type to be bound to"

	^self leftChild bindingType.
]

{ #category : #accessing }
RelationExpression >> canHaveBase [
	"Return true if this type of expression can have a base expression on which other things can be built. Doesn't say whether we actually have a valid one or not."
	^true.
]

{ #category : #'As yet unclassified' }
RelationExpression >> canUseBinding [
	"Return true if we can use binding for our right child's value"
	^self expectsCollectionArgument not.
]

{ #category : #preparing }
RelationExpression >> condenseBooleanEquality [
	(relation = #AND | (relation = #OR)) ifFalse: [^self].
	(leftChild isGlorpExpression and: [leftChild isConstantExpression])
		ifTrue: [
			(relation = #AND and: [leftChild value = true]) ifTrue: [^rightChild].
			(relation = #AND and: [leftChild value = false]) ifTrue: [^leftChild].
			(relation = #OR and: [leftChild value = true]) ifTrue: [^leftChild].
			(relation = #OR and: [leftChild value = false]) ifTrue: [^rightChild]].
	(rightChild isGlorpExpression and: [rightChild isConstantExpression])
		ifTrue: [
			(relation = #AND and: [rightChild value = true]) ifTrue: [^leftChild].
			(relation = #AND and: [rightChild value = false]) ifTrue: [^rightChild].
			(relation = #OR and: [rightChild value = true]) ifTrue: [^rightChild].
			(relation = #OR and: [rightChild value = false]) ifTrue: [^leftChild]].

	^self.
]

{ #category : #preparing }
RelationExpression >> condenseBooleanEqualityExpressions [
	leftChild := leftChild condenseBooleanEquality.
	rightChild := rightChild condenseBooleanEquality.
]

{ #category : #preparing }
RelationExpression >> condensePrimaryKeyComparison [
	"This tries to condense expressions of the form
         something relatedObject id = x
      with 
          something foreignKeyToRelatedObjectId = x, saving a join (and making the thing work at all, in the case where x = nil"

	| fieldBeingCompared baseObjectExpression join sourceField |
	(relation = #= or: [relation = #<>]) ifFalse: [^self].
	self leftChild mappedFields size = 1 ifFalse: [^self].
	fieldBeingCompared := self leftChild field.
	fieldBeingCompared class == DatabaseField ifFalse: [^self].
	fieldBeingCompared isPrimaryKey ifFalse: [^self].
	baseObjectExpression := self leftChild base.
	baseObjectExpression representsDerivedObject ifFalse: [^self].
	"If we have an expression for a join, don't even try."
	baseObjectExpression join isJoin ifFalse: [^self].
	join := baseObjectExpression join asGlorpExpressionOn: baseObjectExpression base.
	sourceField := join sourceForTarget: fieldBeingCompared.
	sourceField isNil ifTrue: [^self].

	"OK, we've got a match, replace ourselves with the shortcut"
	^(sourceField isGlorpExpression and: [sourceField isConstantExpression])
		ifTrue: [self rightChild get: relation withArguments: (Array with: sourceField)]
		ifFalse: [(self leftChild base base getField: sourceField) get: relation withArguments: (Array with: self rightChild)].
]

{ #category : #preparing }
RelationExpression >> condensePrimaryKeyComparisons [
	"Because we're replacing the expression, we need to do it at the parent and replace the previous child"
	leftChild := leftChild condensePrimaryKeyComparison.
	rightChild := rightChild condensePrimaryKeyComparison.
]

{ #category : #iterating }
RelationExpression >> convertValueOf: anObject in: aDictionary [
	| translated convertedValue |

	translated := anObject isGlorpExpression 
		ifTrue: [anObject valueIn: aDictionary]
		ifFalse: [anObject].
	translated isGlorpExpression ifTrue: [^translated].
	convertedValue := self expectsCollectionArgument 
		ifTrue: [translated collect: [:each | self leftChild convertedDbValueOf: each]]
		ifFalse: [self leftChild convertedDbValueOf: translated].
	^convertedValue.
]

{ #category : #'As yet unclassified' }
RelationExpression >> convertedDbValueOf: anObject [
	"Assume that our types match, so we can ask either child to do the conversion. That isn't guaranteed, but should at least work for the common cases."
	^leftChild convertedDbValueOf: anObject.
]

{ #category : #copying }
RelationExpression >> createFor: arguments withBase: anExpression symbol: aSymbol [
	"Create a copy of our expression with the given parameters. Used in function creation, for 'functions' like isNil that really just turn into relations."

	^self class
		named: relation
		basedOn: anExpression
		withArguments: (Array with: rightChild).
]

{ #category : #iterating }
RelationExpression >> do: aBlock skipping: aSet [
	| clauses |
	(aSet includes: self) ifTrue: [^self].
	aSet add: self.
	leftChild hasImpliedClauses
		ifTrue:
			[clauses := leftChild allRelationsFor: self.
			clauses do: [:each | each do: aBlock skipping: aSet]]
		ifFalse:
			[leftChild do: aBlock skipping: aSet.
			rightChild do: aBlock skipping: aSet.
			aBlock value: self.].
]

{ #category : #'As yet unclassified' }
RelationExpression >> expectsCollectionArgument [
	^self relationsWithCollectionArguments includes: relation.
]

{ #category : #converting }
RelationExpression >> generalExpressionPart [
	| left right |
	left := leftChild generalExpressionPart.
	right := rightChild generalExpressionPart.
	(left isNil and: [right isNil]) ifTrue: [^nil].
	left isNil ifTrue: [^right].
	right isNil ifTrue: [^left].
	^self.
]

{ #category : #api }
RelationExpression >> get: aSymbol withArguments: anArray [
	"We treat NOT as a function, so we have to check for functions here"
	| functionExpression |
	functionExpression := self getFunction: aSymbol withArguments: anArray.
	functionExpression isNil ifFalse: [^functionExpression].
	^anArray size = 1
		ifTrue: [RelationExpression named: aSymbol basedOn: self withArguments: anArray]
		ifFalse: ["This is either an error, or something defined as a selector on relation expressions"
			self perform: aSymbol withArguments: anArray.].
]

{ #category : #preparing }
RelationExpression >> hasBindableExpressionsIn: aCommand [
	"Return true if our right-child can be used for binding. We need to do this at this level because the expressions themselves don't know what type they'll be matched against"

	| translated |
	rightChild canBind ifFalse: [^false].
	translated := self convertValueOf: rightChild in: aCommand parameters.
	^self useBindingFor: translated to: leftChild field type in: aCommand.
]

{ #category : #accessing }
RelationExpression >> isOuterJoin [
	outerJoin isNil ifTrue: [outerJoin := false].
	^outerJoin.
]

{ #category : #accessing }
RelationExpression >> leftChild [
	^leftChild
]

{ #category : #accessing }
RelationExpression >> leftChild: anExpression [ 
	leftChild := anExpression
]

{ #category : #iterating }
RelationExpression >> mappableSourceFieldsDo: aBlock [
	"Used when we are emulating a Join"
	self allSourceFields do: [:source |
		source isMappable ifTrue: [aBlock value: source]].
]

{ #category : #mapping }
RelationExpression >> mappedFields [
	^Array with: self
]

{ #category : #mapping }
RelationExpression >> mappedFieldsCount [
	^1
]

{ #category : #'private/initializing' }
RelationExpression >> named: aSymbol basedOn: anExpression withArguments: anArray [

	| base right rightBase |
	outerJoin := false.
	relation := self operationFor: aSymbol.
	leftChild := anExpression.

	"The only time we don't expect anExpression to have a base is if it's a constant, in which case the other side should be a variable expression and thus have a base."
	base := anExpression canHaveBase ifTrue: [anExpression ultimateBaseExpression] ifFalse: [anArray first ultimateBaseExpression].
	right := anArray first.
	right isGlorpExpression ifFalse: [rightChild := right asGlorpExpressionOn: base. ^self].
	rightBase := right ultimateBaseExpression.
	rightChild := rightBase ~= base
		ifTrue: [
			right asGlorpExpressionOn: ((rightBase notNil and: [rightBase hasDescriptor]) ifTrue: ["Correlated subselect" rightBase] ifFalse: [base])]
		ifFalse: [right].
]

{ #category : #'private/initializing' }
RelationExpression >> operationFor: aSymbol [
	"Simple translation of operators"

	aSymbol == #AND: ifTrue: [^#AND].
	aSymbol == #& ifTrue: [^#AND].
	aSymbol == #OR: ifTrue: [^#OR].
	aSymbol == #| ifTrue: [^#OR].
	aSymbol == #~= ifTrue: [^#<>].
	 aSymbol == #like: ifTrue: [^#LIKE].
	 aSymbol == #ilike: ifTrue: [^#ILIKE].		"Case-insensitive variant of LIKE. Only supported on PostgreSQL at the moment"
	 aSymbol == #in: ifTrue: [^#IN].
	 aSymbol == #notIn: ifTrue: [^#'NOT IN'].

	^aSymbol.
]

{ #category : #accessing }
RelationExpression >> outerJoin [
	outerJoin isNil ifTrue: [outerJoin := false].
	^outerJoin.
]

{ #category : #accessing }
RelationExpression >> outerJoin: aBoolean [
	outerJoin := aBoolean.
]

{ #category : #'As yet unclassified' }
RelationExpression >> primaryKeyFromDictionary: aDictionary [
	"Given a set of parameters, return a primary key suitable for retrieving our target. Do this only if the expression is for a primary key, and has no other conditions than the primary key one.  If the table's primary key is composite, return the array that will be needed with the found values in the right position and nils elsewhere.  (If unreferenced primaryKey fields are nillable, this could return a matching key.  A query with other values elsewhere will throw away the primary key, returning nil.  One without will "

	| left right field primaryKeyFields |
	relation = #AND ifTrue:
		[left := leftChild primaryKeyFromDictionary: aDictionary.
		left isNil ifTrue: [^nil].
		right := rightChild primaryKeyFromDictionary: aDictionary.
		right isNil ifTrue: [^nil].
		^self assembleCompositePrimaryKeyFrom: left and: right].
	relation = #= ifFalse: [^nil].
	field := leftChild fieldFromMeOrSubclasses.
	field isNil ifTrue: [^nil].
	field isGlorpExpression ifTrue: [^nil].
	field isPrimaryKey ifFalse: [^nil].
	primaryKeyFields := field table primaryKeyFields.
	^primaryKeyFields size > 1
		ifFalse: [rightChild valueIn: aDictionary]
		ifTrue:
			[(Array new: primaryKeyFields size withAll: DatabaseRow emptySlot)	"ensure no accidental nil-match"
				"field table may be alias with PK fields of original, so (field table primaryKeyFields indexOf: field) = 0"
				at: ((1 to: primaryKeyFields size) detect: [:i | (primaryKeyFields at: i) position = field position]) put: (rightChild valueIn: aDictionary);
				yourself]
]

{ #category : #'printing SQL' }
RelationExpression >> printBasicSQLOn: aCommand withParameters: aDictionary [
	aCommand nextPut: $(.
	leftChild printSQLOn: aCommand withParameters: aDictionary.
	self printComparisonTo: rightChild withParameters: aDictionary on: aCommand.
	self printOracleOuterJoinOn: aCommand.
	aCommand nextPut: $)
]

{ #category : #'printing SQL' }
RelationExpression >> printBasicUnqualifiedSQLOn: aCommand withParameters: aDictionary [
	aCommand nextPut: $(.
	leftChild printUnqualifiedSQLOn: aCommand withParameters: aDictionary.
	self printUnqualifiedComparisonTo: rightChild withParameters: aDictionary on: aCommand.
	self printOracleOuterJoinOn: aCommand.
	aCommand nextPut: $)
]

{ #category : #'printing SQL' }
RelationExpression >> printComparisonTo: value withParameters: aDictionary on: aStream [
	"Horribly convoluted logic to handle the cases where the value might be a constant, an expression that results in a value (constant or parameter) or a regular expression, with the caveat that any value that turns out to be null has to be printed with IS NULL rather than = NULL."

	| translated |
	translated := self convertValueOf: value in: aDictionary.
	translated isGlorpExpression
		ifTrue:
			[
			translated canPrint ifTrue: [
				self printRelationOn: aStream.
				translated
					printSQLOn: aStream
					withParameters: aDictionary]]
		ifFalse:
			[self
				printSimpleValueComparisonTo: translated
				on: aStream].
]

{ #category : #'As yet unclassified' }
RelationExpression >> printForANSIJoinTo: table on: aCommand [
	"Print ourselves as table JOIN otherTable USING (criteria). Return the table we joined"

	self outerJoin
		ifTrue: [aCommand nextPutAll: ' LEFT OUTER JOIN ']
		ifFalse: [aCommand nextPutAll: ' INNER JOIN '].
	aCommand nextPutAll: table sqlTableName.
	aCommand nextPutAll: ' ON '.
	self printSQLOn: aCommand withParameters: aCommand parameters.
	^table.
]

{ #category : #'printing SQL' }
RelationExpression >> printMicrosoftOuterJoinOn: aCommand [
	self isOuterJoin ifFalse: [^self].
	aCommand platform useMicrosoftOuterJoins ifTrue: [
		aCommand nextPutAll: '*'].
]

{ #category : #printing }
RelationExpression >> printOnlySelfOn: aStream [

	aStream nextPutAll: relation.
]

{ #category : #'printing SQL' }
RelationExpression >> printOracleOuterJoinOn: aCommand [
	self isOuterJoin ifFalse: [^self].
	(self leftChild class == self class and: [self leftChild isOuterJoin]) ifTrue: [^self].
	(self rightChild class == self class and: [self rightChild isOuterJoin]) ifTrue: [^self].
	aCommand platform useOracleOuterJoins ifTrue: [
		aCommand nextPutAll: ' (+) '].
]

{ #category : #'printing SQL' }
RelationExpression >> printRelationOn: aStream [
	aStream space.
	self printMicrosoftOuterJoinOn: aStream.
	aStream 
		nextPutAll: self relation;
		space.
]

{ #category : #'printing SQL' }
RelationExpression >> printSQLOn: aStream withParameters: aDictionary [
	self leftChild hasImpliedClauses
		ifTrue:
			[| impliedClauses |
			impliedClauses := self leftChild allRelationsFor: self.
			impliedClauses outerJoin: self outerJoin.
			impliedClauses
				printSQLOn: aStream
				withParameters: aDictionary]
		ifFalse:
			[self
				printBasicSQLOn: aStream
				withParameters: aDictionary].
]

{ #category : #'printing SQL' }
RelationExpression >> printSelectSQLOn: aStream withParameters: aDictionary [
	self printSQLOn: aStream withParameters: aDictionary.
]

{ #category : #'printing SQL' }
RelationExpression >> printSimpleValueComparisonTo: value on: aStream [
	value isNil
		ifTrue: [self printWithNullOn: aStream]
		ifFalse:
			[self printRelationOn: aStream.
			self printValue: value on: aStream].
]

{ #category : #printing }
RelationExpression >> printTreeOn: aStream [ 
	aStream
		print: leftChild;
		space;
		nextPutAll: relation;
		space;
		print: rightChild
]

{ #category : #'printing SQL' }
RelationExpression >> printUnqualifiedComparisonTo: value withParameters: aDictionary on: aStream [
	"Horribly convoluted logic to handle the cases where the value might be a constant, an expression that results in a value (constant or parameter) or a regular expression, with the caveat that any value that turns out to be null has to be printed with IS NULL rather than = NULL."

	| translated |
	translated := self convertValueOf: value in: aDictionary.
	translated isGlorpExpression
		ifTrue:
			[
			translated canPrint ifTrue: [
				self printRelationOn: aStream.
				translated
					printUnqualifiedSQLOn: aStream
					withParameters: aDictionary]]
		ifFalse:
			[self
				printSimpleValueComparisonTo: translated
				on: aStream].
]

{ #category : #'printing SQL' }
RelationExpression >> printUnqualifiedSQLOn: aStream withParameters: aDictionary [
	self leftChild hasImpliedClauses
		ifTrue:
			[| impliedClauses |
			impliedClauses := self leftChild allRelationsFor: self.
			impliedClauses outerJoin: self outerJoin.
			impliedClauses
				printUnqualifiedSQLOn: aStream
				withParameters: aDictionary]
		ifFalse:
			[self
				printBasicUnqualifiedSQLOn: aStream
				withParameters: aDictionary].
]

{ #category : #'printing SQL' }
RelationExpression >> printValue: value on: aCommand [
	| type |
	type := [self leftChild type] on: Dialect error do: [:ex | self error: 'Invalid comparison operation: ', self printString].
	(self useBindingFor: value to: type in: aCommand) ifTrue: [^aCommand nextPutAll: '?'].
	self expectsCollectionArgument
		ifTrue:
			[type
				printCollection: value
				on: aCommand]
		ifFalse:
			[type
				print: value
				on: aCommand].
]

{ #category : #'printing SQL' }
RelationExpression >> printWithNullOn: aStream [
	aStream nextPutAll: ' IS '.
	self relation = #<> ifTrue: [
		aStream nextPutAll: 'NOT '].
	aStream nextPutAll: 'NULL'.
]

{ #category : #navigating }
RelationExpression >> queryLevelBaseExpression [

	^leftChild canHaveBase ifTrue: [leftChild queryLevelBaseExpression] ifFalse: [rightChild queryLevelBaseExpression].
]

{ #category : #preparing }
RelationExpression >> rebuildOn: aBaseExpression startingFrom: anExpression withOuterScopeBase: ultimateBaseExpression [
	| expression |
	self == anExpression ifTrue: [^aBaseExpression].
	expression := (leftChild rebuildOn: aBaseExpression startingFrom: anExpression withOuterScopeBase: ultimateBaseExpression)
		get: relation
		withArguments:
			(Array
				with:
					(self rightChildToRebuild rebuildOn: aBaseExpression startingFrom: anExpression withOuterScopeBase: ultimateBaseExpression)).
	self isOuterJoin ifTrue: [expression beOuterJoin].
	^expression.
]

{ #category : #accessing }
RelationExpression >> relation [

	^relation.
]

{ #category : #accessing }
RelationExpression >> relation: aSymbol [

	relation := aSymbol.
]

{ #category : #'As yet unclassified' }
RelationExpression >> relationsWithCollectionArguments [
	^#(#IN #'NOT IN')
]

{ #category : #preparing }
RelationExpression >> removeNonJoinParts [
	"Remove anything that's not an actual join. Only useful if we have something that has mixed joins and general expressions, where we assume we don't want to use the general ones, because they're not field level. Also only meaningful to remove this for ANDs and ORs, not sub-components."
	(relation = #AND or: [relation = #OR]) ifFalse: [^self].
	leftChild := leftChild isJoin ifTrue: [leftChild] ifFalse: [true asGlorpExpression].
	rightChild := rightChild isJoin ifTrue: [rightChild] ifFalse: [true asGlorpExpression].
]

{ #category : #preparing }
RelationExpression >> replaceJoinsWithInverse [
	"Replace any actual Join objects we have with their inverse. Only useful if we have something that has mixed joins and general expressions, where we assume we don't want to mess with the general ones, because they're not field-level"
	leftChild isJoin ifTrue: [leftChild := leftChild inverseJoin].
	rightChild isJoin ifTrue: [rightChild := rightChild inverseJoin].
]

{ #category : #preparing }
RelationExpression >> rewriteEquality [
	| keyEquality descriptor describedClass |
	leftChild := leftChild rewriteBooleanEquality: relation.
	leftChild hasDescriptor ifFalse: [^self].
	"A slightly convoluted way of checking if this is a pseudo-descriptor for a primitive type used in something like a DirectToManyMapping, in which case we can't rewrite. But if it's a pseudo-descriptor for a dictionary mapping where we actually use the mapping as the key rather than a class, then we're ok. It'd be nice if the code for this were more expressive."
	descriptor := leftChild descriptor.
	describedClass := descriptor describedClass.
	(describedClass ~~ Association and: [(descriptor session descriptorFor: describedClass) isNil]) ifTrue: [^self].

	(relation = #= | (relation = #<>) | (relation = #IN)) ifFalse: [^self].
	(relation = #IN and: [leftChild descriptor primaryTable primaryKeyFields size > 1]) ifTrue: [
		(GlorpInvalidExpressionError signal: 'Cannot convert an object comparison to an IN comparison when the table uses a composite primary key')].
	keyEquality := leftChild descriptor
		primaryKeyExpressionFor: rightChild
		basedOn: leftChild
		relation: relation.
	^keyEquality.
]

{ #category : #preparing }
RelationExpression >> rewriteEqualityExpressions [
	leftChild := leftChild rewriteEquality.
	rightChild := rightChild rewriteEquality.
]

{ #category : #preparing }
RelationExpression >> rewriteFunctionArguments [
	"If a function needs to adjust its arguments, do that here. The motivating example is one where a string argument is rewritten into a form that's of a different length, e.g. the Postgresql driver does that to strings in Blobs."
	leftChild rewriteFunctionArgumentsWith: rightChild.
]

{ #category : #accessing }
RelationExpression >> rightChild [
	^rightChild
]

{ #category : #accessing }
RelationExpression >> rightChild: anExpression [
	rightChild := anExpression
]

{ #category : #preparing }
RelationExpression >> rightChildToRebuild [
	^rightChild.
]

{ #category : #testing }
RelationExpression >> shortCircuitOnNullComparison: parameters [
	"Return true if we represent an expression that compares null to a non-nullable value, so we don't ever need to really evaluate it.This could be more sophisticated and test if any part of an ANDed and not NOTed clause does such a comparison. But this will do for the most important cases"

	| value |
	outerJoin ifTrue: [^false].
	value := rightChild valueIn: parameters.
	^(relation == #=
		and: [value isNil and: [leftChild field isNullable not]])
]

{ #category : #converting }
RelationExpression >> sourceForTarget: aField [

	| left |
	relation = #= ifFalse: [
		left := leftChild sourceForTarget: aField.
		left isNil ifFalse: [^left].
		^rightChild sourceForTarget: aField].
	rightChild field == aField ifTrue: [^leftChild field].
	leftChild field == aField ifTrue: [^rightChild field].
	^nil.
]

{ #category : #'As yet unclassified' }
RelationExpression >> tableToJoinFrom: aTableCollection [
	"Return a table we could legitimately use at this point to write as an ANSI join - meaning that all but one must be  already used and thus available, and one that isn't. aTableCollection lists the used ones"
	| possibleTables |
	possibleTables := self tablesForANSIJoin asArray
		select: [:each | (aTableCollection includes: each) not].
	^possibleTables size = 1 ifTrue: [possibleTables first] ifFalse: [nil].
]

{ #category : #'As yet unclassified' }
RelationExpression >> tablesForANSIJoin [
	"Which tables will we join. Assumes this is a single-level join"
	^self inject: Set new into: [:sum :each |
		each tableForANSIJoin isNil ifFalse: [sum add: each tableForANSIJoin].
		sum].
]

{ #category : #'As yet unclassified' }
RelationExpression >> targetKeys [
	"Assume that part of us is a join, and the rest doesn't count"
	^self inject: OrderedCollection new into: [:sum :each |
		each isJoin ifTrue: [sum addAll: each targetKeys].
		sum].
]

{ #category : #accessing }
RelationExpression >> type [
	"Assume that we can derive our type from our children's type. Not guaranteed to be true, but seems like it should work for the common cases."
	^self leftChild type.
]

{ #category : #navigating }
RelationExpression >> ultimateBaseExpression [

	^leftChild canHaveBase ifTrue: [leftChild ultimateBaseExpression] ifFalse: [rightChild ultimateBaseExpression].
]

{ #category : #'As yet unclassified' }
RelationExpression >> useBindingFor: aValue to: aType in: aCommand [
	"Return true if we can use binding for our right child's value, in the context of this command"
	aCommand useBinding ifFalse: [^false].
	self expectsCollectionArgument ifTrue: [^false].
	^aCommand canBind: aValue to: aType.
]

{ #category : #mapping }
RelationExpression >> valueInBuilder: anElementBuilder [
	^self leftChild valueInBuilder: anElementBuilder as: self
]

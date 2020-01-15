"
This is a query that is directly executable. A single query might be more than we can do in a single database read, so we might have to break it down into simple queries. But at the moment we just break anything down into an equivalent single query.

Instance Variables:
	builders	<OrderedCollection of: ElementBuilder)>	The builders that will assemble the object from the row that this query returns.
	fields	<OrderedCollection of: DatabaseField>	The fields being selected.
	joins	<OrderedCollection of: Join> While preparing the query, we will need to build up a list of joins implied by the relationships in the where clause, ordering, and so forth. This acts as storage for those.
	tablePrefix	<String>	If we are part of a subselect, we want to prefix all of our table aliases with some known, common prefix, so that we won't have our own t1 which would get confused with the parent query's t1. The normal convention is something like 's1' for subselect 1, so we get s1t1, and so forth.
	command <DatabaseCommand> We can tell the query to use a specific command instead of generating one appropriately. Note that if this is set, it overrides most of the other sql generation.


"
Class {
	#name : #SimpleQuery,
	#superclass : #AbstractReadQuery,
	#instVars : [
		'builders',
		'fields',
		'joins',
		'tablePrefix',
		'customCommand',
		'tablesToPrint'
	],
	#category : #'Glorp-Queries'
}

{ #category : #preparing }
SimpleQuery >> addAllOrderingsForBuilder: aBuilder [
	
	| expression fieldExpressions |
	expression := aBuilder expression.
	fieldExpressions := expression descriptor primaryTable primaryKeyFields collect: [:each | expression getField: each].
	fieldExpressions do: [:each | self addSingleOrderingForBuilder: each]
]

{ #category : #accessing }
SimpleQuery >> addBoundExpressionsIn: aCommand to: aCollection [
	self joins , self fields, (Array with: self whereClause)
		do:
			[:eachBigExpression | 
			eachBigExpression isGlorpExpression
				ifTrue: [eachBigExpression do:
					[:eachIndividualExpressionNode | 
					eachIndividualExpressionNode
						addBoundExpressionsIn: aCommand
						to: aCollection]]]
]

{ #category : #fields }
SimpleQuery >> addFields: aliasedFields returningTranslationForFields: originalFields distinct: isDistinct [
	"The query has computed a set of fields the way the mappings see them, which are then transformed to account for field aliasing in embedded mappings. Add those to our collection, and set up the translation which knows which fields are at which index in the resulting row. If necessary, note that those fields are selected as distinct"

	| translation |
	translation := IdentityDictionary new.
	aliasedFields
		with: originalFields
		do:
			[:aliased :original | 
			| position fieldToAdd|
			position := self findPositionofAliasedField: aliased.
			position = 0
				ifTrue:  
					[fieldToAdd := isDistinct ifTrue: [aliased asDistinctFieldOn: self baseExpression] ifFalse: [aliased].
					fields add: fieldToAdd .
					position := fields size].
			translation at: original put: position].
	^translation
]

{ #category : #preparing }
SimpleQuery >> addJoin: anExpression [
	joins addAll: anExpression asIndependentJoins
]

{ #category : #preparing }
SimpleQuery >> addOrderingForToManyJoins [
	"If we have a join to a to-many relation, then we need for all the joined bits to be grouped together in order in the result set."

	| toManyBuilders baseBuilders |
	toManyBuilders := builders select: [:each | each canCauseDuplicateRows].
	baseBuilders := toManyBuilders collect:
		[:each |
		builders
			detect: [:eachBuilder | eachBuilder expression == each expression base]
			ifNone: [nil]].
	baseBuilders do: [:each | each isNil ifFalse: [self addAllOrderingsForBuilder: each]].
	"If a fetched expression matches that of a toMany builder, it may be ordered."
	tracing alsoFetchExpressions do:
		[:alsoFetchExp || orderFields |
		((toManyBuilders anySatisfy: [:each | alsoFetchExp = each expression]) and:
				[(orderFields := alsoFetchExp mapping orderBy) notNil]) ifTrue:
			[orderFields do:
				[:orderField || orderExp |
				orderExp := self expressionBlockFor: orderField.
				self addSingleOrderingForBuilder: (orderExp asGlorpExpressionOn: alsoFetchExp)]]].
]

{ #category : #preparing }
SimpleQuery >> addSingleOrderingForBuilder: aFieldExpression [
	"Add the ordering to the query, as long as we don't already have an equivalent ordering there."	

	ordering isNil ifTrue: [^self orderBy: aFieldExpression].
	ordering 
		detect: [:eachExistingOrdering | 
			eachExistingOrdering = aFieldExpression 
				or: [eachExistingOrdering field = aFieldExpression field and: [eachExistingOrdering base = aFieldExpression base]]]
		ifNone: [self orderBy: aFieldExpression]
]

{ #category : #preparing }
SimpleQuery >> adjustWhereClause [
	"Make any adjustments to the where clause. This includes adjusting direct object equality expressions to be primary key comparisons, removing primary key comparisons where we can compare a foreign key, and condensing boolean constants out of expressions."

	whereClause := whereClause rewriteEquality. "Special because otherwise we'd be throwing away the top-level one"
	whereClause := whereClause rewriteBooleanEquality: nil.
	whereClause do: [:each | each rewriteEqualityExpressions].
	whereClause do: [:each | each condensePrimaryKeyComparisons].
	whereClause := whereClause condensePrimaryKeyComparison.
	whereClause := whereClause condenseBooleanEquality.
	whereClause do: [:each | each condenseBooleanEqualityExpressions].
	(whereClause isConstantExpression and: [whereClause value = true])
		ifTrue: [
			whereClause := EmptyExpression on: whereClause value.
			whereClause base: base.].
	whereClause do: [:each | each rewriteFunctionArguments]
]

{ #category : #converting }
SimpleQuery >> asFullQuery [
	| newQuery |
	newQuery := ReadQuery new
		initResultClass: resultClass whereClause: whereClause singleObject: readsOneObject.
	self copyAttributesTo: newQuery.
	newQuery setOrdering: ordering.
	newQuery setGrouping: grouping.
	^newQuery.
]

{ #category : #converting }
SimpleQuery >> asGlorpExpression [
	^self asGlorpExpressionOn: BaseExpression new
]

{ #category : #converting }
SimpleQuery >> asGlorpExpressionOn: anExpression [
	"If we're being converted into an expression, that means we're a subselect inside an expression block. We don't actually have any relationship to anExpression, so create our own base and make a pseudo-mapping with no join to describe the relationship. Don't even give it a string-name, just use ourselves as the key"
	
	| expression localBase phantomMapping phantomExpression |
	phantomMapping := OneToOneMapping new
		referenceClass: self resultClass;
		attributeName: #temporaryAttributeFromSubselect;
		join: Join new;
		descriptor: (anExpression system descriptorFor: self resultClass).
	phantomExpression := anExpression getMapping: phantomMapping named: self.
	expression := GeneralSubSelectExpression 
		basedOn: phantomExpression.
	expression query: self.
	localBase := SubSelectBaseExpression on: phantomExpression.
	self baseExpression: localBase.
	self tablePrefix: ('s', anExpression ultimateBaseExpression availableSubSelectNumber printString, 't').
	^expression
]

{ #category : #converting }
SimpleQuery >> asGlorpExpressionOn: anExpression basedOn: aMessageArchiver withUltimateBase: aBaseExpression [
	^self asGlorpExpressionOn: anExpression
]

{ #category : #preparing }
SimpleQuery >> assignTableAliases [
	| tableNumber allExpressions |
	whereClause isJoin ifTrue: [^self].
	tableNumber := 1.
	allExpressions := ExpressionGroup with: whereClause.
	allExpressions addAll: ordering.
	allExpressions addAll: grouping.
	allExpressions addAll: joins.
	builders do: [:each | allExpressions add: each expression].
	allExpressions
		do:
			[:each | tableNumber := each assignTableAliasesStartingAt: tableNumber prefix: self tablePrefix].
	"We've aliased tables, joins may now become independent"
	joins := joins inject: OrderedCollection new into: [:sum :each | (sum addAll: each asIndependentJoins). sum].
]

{ #category : #converting }
SimpleQuery >> basicRebuildOn: aBaseExpression startingFrom: anExpression withOuterScopeBase: ultimateBaseExpression [
	"Rebuild the query, which is part of a subselect expression, into the new context. The only thing that really matters here is that we get correlated subselect pieces inside the query right. The rest is independent of our main expression"
	prepared := false.
	builders := nil.
	base := SubSelectBaseExpression on: (base trueBase rebuildOn: aBaseExpression startingFrom: anExpression withOuterScopeBase: ultimateBaseExpression).
	whereClause := whereClause asGlorpExpressionOn: base withUltimateBase: ultimateBaseExpression.
	joins := joins collect: [:each | each asGlorpExpressionOn: base withUltimateBase: ultimateBaseExpression].
	ordering isNil ifFalse: [ordering := ordering collect: [:each | each asGlorpExpressionOn: base withUltimateBase: ultimateBaseExpression]].
	grouping isNil ifFalse: [grouping := grouping collect: [:each | each asGlorpExpressionOn: base withUltimateBase: ultimateBaseExpression]].
"	fields := fields collect: [:each | each isGlorpExpression 
		ifTrue: [each asGlorpExpressionOn: base withUltimateBase: ultimateBaseExpression]
		ifFalse: [each]]."
	fields := OrderedCollection new.
]

{ #category : #accessing }
SimpleQuery >> builders [

	^builders
]

{ #category : #accessing }
SimpleQuery >> command: aDatabaseCommand [
	"Explicitly set the database command we will use. This is normally used in order to provide a SQLStringSelectCommand, and specify the sql for the query."
	customCommand := aDatabaseCommand
]

{ #category : #executing }
SimpleQuery >> computeFields [
	builders 
		do: [:each | self computeFieldsFor: each]
]

{ #category : #executing }
SimpleQuery >> computeFieldsFor: anElementBuilder [ 
	| translatedFields |
	translatedFields := self 
		addFields: anElementBuilder fieldsForSelectStatement
		returningTranslationForFields: anElementBuilder fieldsFromMyPerspective
		distinct: anElementBuilder requiresDistinct.
	anElementBuilder fieldTranslations: translatedFields
]

{ #category : #'sql generation' }
SimpleQuery >> computeTablesToPrint [
	| allTables stoppingPoint |
	allTables := Set new.
	fields do: [:each | allTables addAll: each tablesToPrint].
	stoppingPoint := base.
	allTables
		addAll:
			(stoppingPoint isNil
				ifTrue: [whereClause allTablesToPrint]
				ifFalse: [whereClause allTablesToPrintStoppingAt: stoppingPoint]).
	joins
		do:
			[:eachJoin | 
			allTables
				addAll:
					(stoppingPoint isNil
						ifTrue: [eachJoin allTablesToPrint]
						ifFalse: [eachJoin allTablesToPrintStoppingAt: stoppingPoint])].
	ordering isNil
		ifFalse: [ordering do: [:each | 
			each field isNil ifFalse: [allTables add: each field table]]].
	grouping isNil
		ifFalse: [grouping do: [:each |
			each field isNil ifFalse: [allTables add: each field table]]].
	self tracing allTracings
		do: [:each | allTables addAll: each allTablesToPrint].
	^allTables asSortedCollection
]

{ #category : #preparing }
SimpleQuery >> copyOfBuilders [ 
	"Copy the builders, but make sure that subBuilders also get matched up"
	| newBuilders |
	newBuilders := builders collect: [:each | each copy].
	newBuilders do: [:each | each reconcileWithBuilders: builders andCopy: newBuilders].
	^newBuilders
]

{ #category : #'As yet unclassified' }
SimpleQuery >> deleteSqlWith: aDictionary [
	| result |
	self prepare.
	customCommand isNil ifFalse: [
		result := customCommand copy.
		result query: self; parameters: aDictionary; useBinding: session useBinding; session: session.
		^result].
	^QueryDeleteCommand
		forQuery: self
		parameters: aDictionary
		useBinding: session useBinding
		session: session.
]

{ #category : #accessing }
SimpleQuery >> elementBuilderFor: anExpression [ 
	^builders detect: [:each | each expression == anExpression] ifNone: [nil]
]

{ #category : #accessing }
SimpleQuery >> fields [
	fields isNil ifTrue: [self prepare].
	^fields
]

{ #category : #fields }
SimpleQuery >> findPositionofAliasedField: aField [
	1 to: fields size do: [:i |
		| existingField |
		existingField := fields at: i.
		existingField asField isNil
			ifTrue: [
				existingField isSameAliasedFieldAs: aField]
			ifFalse: [		
				(existingField asField isSameAliasedFieldAs: aField)
			ifTrue: [^i]]].
	^0.
]

{ #category : #preparing }
SimpleQuery >> fixJoins [
	| pseudoJoins realJoins |
	pseudoJoins := joins select: [:each | each tablesForANSIJoin size < 2].
	pseudoJoins do: [:each | whereClause := each AND: whereClause].
	realJoins :=  joins select: [:each| each tablesForANSIJoin size >= 2].
	joins := realJoins.
]

{ #category : #testing }
SimpleQuery >> hasEmptyWhereClause [
	"If we have regular where clause entries, or if we have joins that aren't going to be printed in the tables portion, then we're not empty"
	whereClause willPrintAsWhereClause ifTrue: [^false].
	self useANSIJoins ifTrue: [^true].
	^joins isEmpty.
]

{ #category : #testing }
SimpleQuery >> hasTracing [
	"Return true if we've given this query a tracing already"
	^builders notNil
]

{ #category : #'initialize-release' }
SimpleQuery >> initResultClass: aClass whereClause: anExpression singleObject: aBoolean [ 
	super 
		initResultClass: aClass
		whereClause: anExpression
		singleObject: aBoolean.
	prepared := false.
	fields := OrderedCollection new.
	joins := OrderedCollection new
]

{ #category : #preparing }
SimpleQuery >> isPrepared [
	^prepared
]

{ #category : #accessing }
SimpleQuery >> joins [
	^joins
]

{ #category : #testing }
SimpleQuery >> mightHaveDuplicateRows [

	^builders anySatisfy: [:each | each canCauseDuplicateRows]
]

{ #category : #copying }
SimpleQuery >> postCopy [
	super postCopy.
	fields := OrderedCollection new.
	joins := OrderedCollection new.
	builders := nil.
	tablesToPrint := nil.
]

{ #category : #preparing }
SimpleQuery >> prepare [
	prepared ifTrue: [^self].
	self setupTracing.
	whereClause prepareIn: self.
	self fixJoins.
	self assignTableAliases.
	self computeFields.
	prepared := true.
]

{ #category : #'sql generation' }
SimpleQuery >> printANSITablesOn: aCommand [
	"Print ourselves using the JOIN... USING syntax. Note that we have to put the joins in the right order because we're not allowed to refer to tables not mentioned yet. Great syntax. Reminds me of Pascal. And so easy to deal with."

	| printer |
	printer := JoinPrinter for: self.
	printer printJoinsOn: aCommand
]

{ #category : #'sql generation' }
SimpleQuery >> printJoinsOn: aCommand [
	| noLeadIn|
	self platform supportsANSIJoins ifTrue: [^self].
	joins isEmpty ifTrue: [^self].
	noLeadIn := whereClause isEmptyExpression.
	noLeadIn ifFalse: [aCommand nextPutAll: ' AND ('].
	GlorpHelper 
			do: [:each | each printSQLOn: aCommand withParameters: aCommand parameters]
			for: joins
			separatedBy: [aCommand nextPutAll: ' AND '].
	noLeadIn ifFalse: [aCommand nextPut: $)]
]

{ #category : #'sql generation' }
SimpleQuery >> printNormalTablesOn: aCommand [
	self printNormalTablesOn: aCommand excluding: #()
]

{ #category : #'sql generation' }
SimpleQuery >> printNormalTablesOn: aCommand excluding: aCollection [
	aCollection do: [:each | self tablesToPrint remove: each].
	GlorpHelper
		print: [:table | table sqlTableName]
		on: aCommand
		for: self tablesToPrint
		separatedBy: ', '.
	^self tablesToPrint
]

{ #category : #'sql generation' }
SimpleQuery >> printOffsetOn: aCommand [
	self hasOffset ifFalse: [^self].
	self platform printOffset: self offset on: aCommand
]

{ #category : #printing }
SimpleQuery >> printOn: aStream [
	super printOn: aStream.
	aStream nextPutAll: ' for '.
	aStream nextPutAll: (resultClass isNil ifTrue: ['nil'] ifFalse: [resultClass name])
]

{ #category : #'sql generation' }
SimpleQuery >> printPostLimitOn: aCommand [
	self hasLimit ifFalse: [^self].
	self platform printPostLimit: self limit on: aCommand
]

{ #category : #'sql generation' }
SimpleQuery >> printPreLimitOn: aCommand [
	self hasLimit ifFalse: [^self].
	self platform printPreLimit: self limit on: aCommand
]

{ #category : #'sql generation' }
SimpleQuery >> printSelectFields: aCollection on: stream [ 
	| fieldsToPrint |
	(aCollection anySatisfy: [:each | each isDistinct]) 
		ifTrue: [
			fieldsToPrint := aCollection collect: [:each | each asField].
			stream nextPutAll: 'DISTINCT ']
		ifFalse: [fieldsToPrint := aCollection].

	"For SQL Server, the TOP has to come after the distinct, but before the fields"
	self printPreLimitOn: stream.
			
	GlorpHelper 
		do: [:field | field printSelectSQLOn: stream withParameters: nil. ]
		for: fieldsToPrint
		separatedBy: [stream nextPutAll: ', ']
]

{ #category : #'sql generation' }
SimpleQuery >> printSelectFieldsOn: stream [ 
     self printSelectFields: fields on: stream
]

{ #category : #'sql generation' }
SimpleQuery >> printTablesOn: aCommand [
	aCommand
		cr;
		nextPutAll: ' FROM '.
	self useANSIJoins
		ifTrue: [self printANSITablesOn: aCommand]
		ifFalse: [self printNormalTablesOn: aCommand]
]

{ #category : #'sql generation' }
SimpleQuery >> printUnqualifiedNormalTablesOn: aCommand [
	self printUnqualifiedNormalTablesOn: aCommand excluding: #().
]

{ #category : #'sql generation' }
SimpleQuery >> printUnqualifiedNormalTablesOn: aCommand excluding: aCollection [
	aCollection do: [:each | self tablesToPrint remove: each].
	GlorpHelper
		print: [:table | table unqualifiedSqlTableName]
		on: aCommand
		for: self tablesToPrint
		separatedBy: ', '.
	^self tablesToPrint.
]

{ #category : #'sql generation' }
SimpleQuery >> printUnqualifiedTablesOn: aCommand [
	aCommand
		cr;
		nextPutAll: ' FROM '.
	self printUnqualifiedNormalTablesOn: aCommand.
]

{ #category : #'sql generation' }
SimpleQuery >> printUnqualifiedWhereClauseOn: aCommand [
	self hasEmptyWhereClause
		ifFalse:
			[aCommand
				cr;
				nextPutAll: ' WHERE '.
			whereClause printUnqualifiedSQLOn: aCommand withParameters: aCommand parameters].
]

{ #category : #'sql generation' }
SimpleQuery >> printWhereClauseOn: aCommand [
	self hasEmptyWhereClause
		ifFalse:
			[aCommand
				cr;
				nextPutAll: ' WHERE '.
			whereClause printSQLOn: aCommand withParameters: aCommand parameters]
]

{ #category : #private }
SimpleQuery >> privateAddBuilder: anElementBuilder [

	builders := builders copyWith: anElementBuilder
]

{ #category : #private }
SimpleQuery >> privateReplaceBuilderWith: anElementBuilder [

	| oldBuilder |
	oldBuilder := self elementBuilderFor: anElementBuilder expression.
	oldBuilder isNil ifTrue: [self error: 'No builder found to replace.'].
	builders at: (builders indexOf: oldBuilder) put: anElementBuilder
]

{ #category : #private }
SimpleQuery >> privateSetFields: aCollection [
	fields := aCollection
]

{ #category : #accessing }
SimpleQuery >> queries [
	"A hack so you can write things that manipulate both this and compound queries the same way"
	^Array with: self
]

{ #category : #converting }
SimpleQuery >> rebuildOn: aBaseExpression startingFrom: anExpression withOuterScopeBase: ultimateBaseExpression [
	"Rebuild the query, which is part of a subselect expression, into the new context. Don't do it if it's not necessary. But if it is necessary, also the copy the query. Otherwise two mappings using the same subselect query will mess each other up."
	self == anExpression ifTrue: [^aBaseExpression].
	self baseExpression ultimateBaseExpression == ultimateBaseExpression ifTrue: [^self].
	^self shallowCopy basicRebuildOn: aBaseExpression startingFrom: anExpression withOuterScopeBase: ultimateBaseExpression
]

{ #category : #testing }
SimpleQuery >> requiresFullQuery [
	| descriptor independent |
	descriptor := self descriptor.
	"This isn't even a valid query."
	descriptor isNil ifTrue: [^false].
	independent := descriptor classesRequiringIndependentQueries.
	^(independent size ~= 1) or: [(independent at: 1) ~= descriptor describedClass]
]

{ #category : #executing }
SimpleQuery >> rowsFromDatabaseWithParameters: anArray [

	| alreadyTriedAction command |
	(self shortCircuitEmptyReturn: anArray) ifTrue: [^session accessor cursorFor: (ReadStream on: #()) command: (self sqlWith: anArray)].
	alreadyTriedAction := false.
	command := self sqlWith: anArray.
	^[session accessor
		executeCommand: command
		returnCursor: true] 
	on: GlorpDatabaseReadError 
	do: [:ex | 
		alreadyTriedAction ifTrue: [ex pass] ifFalse: [alreadyTriedAction := true].
		session errorAction isNil 
			ifTrue: [ex pass] 
			ifFalse: [
				session errorAction value: ex value: session value: self.	
				ex retry]]
]

{ #category : #executing }
SimpleQuery >> setUpExpressions [
	super setUpExpressions.
	self validateWhereClause.
]

{ #category : #preparing }
SimpleQuery >> setupTracing [
	| |
	builders isNil ifFalse: [^self].	"Already been done"
	super setupTracing.
	builders := tracing allTracings asArray
		inject: #()
		into:
			[:sum :each | sum , (ElementBuilder for: each in: self) withAllSubBuilders].
	self addOrderingForToManyJoins
]

{ #category : #'sql generation' }
SimpleQuery >> signature [
	session useBinding ifFalse: [^''].
	^self sqlWith: Dictionary new.
]

{ #category : #accessing }
SimpleQuery >> sql: aString [
	"Specify the sql string to use for this query, instead of having it be generated. Note that doing this will override the normal sql generation mechanisms."
	self command: (SQLStringSelectCommand new setSQLString: aString)
]

{ #category : #'sql generation' }
SimpleQuery >> sqlString [
	"Mostly for debugging"
	^(self sqlWith: #()) sqlString
]

{ #category : #'sql generation' }
SimpleQuery >> sqlWith: aDictionary [
	| result |
	self prepare.
	customCommand isNil ifFalse: [
		result := customCommand copy.
		result query: self; parameters: aDictionary; useBinding: session useBinding; session: session.
		^result].
	^QuerySelectCommand
		forQuery: self
		parameters: aDictionary
		useBinding: session useBinding
		session: session
]

{ #category : #accessing }
SimpleQuery >> tablePrefix [
	^tablePrefix
]

{ #category : #accessing }
SimpleQuery >> tablePrefix: aString [
	tablePrefix := aString
]

{ #category : #'sql generation' }
SimpleQuery >> tablesToPrint [
	tablesToPrint isNil ifTrue: [tablesToPrint := self computeTablesToPrint].
	^tablesToPrint.
]

{ #category : #'sql generation' }
SimpleQuery >> tablesToPrint: aCollection [
	tablesToPrint := aCollection
]

{ #category : #preparing }
SimpleQuery >> traceExpressionInContextFor: anExpression [
	^anExpression rebuildOn: base
]

{ #category : #testing }
SimpleQuery >> useANSIJoins [
	^self session platform supportsANSIJoins
]

{ #category : #accessing }
SimpleQuery >> where: anExpression [
	whereClause := anExpression.
	self setUpBase
]

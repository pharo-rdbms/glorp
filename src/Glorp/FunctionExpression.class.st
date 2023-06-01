"
This represents a database function or other modifier. For example, conversion to upper or lower case, or the ascending/descending modifier in order by clauses. At the moment it is hard-coded to to handle only the descending modifier and does not handle e.g. function arguments, functions that differ between databases, functional syntax ( as opposed to postfix). One would probably define subclasses to handle these cases, but this is the simplest thing that could possibly work for the current functionality.

Instance Variables
	function	<String>	The string we print to the database
	base <GlorpExpression> The thing we're a function of.
	alias <String> If we're to be selected as a field, what should we be selected as. Think SELECT t1.A + t1.B AS FRED.
	symbol <Symbol> The original symbol used to create us. Helpful if recreating onto a different platform where the DB string can be different.
	type <GlorpDatabaseType> Optional. If we have a type defined, then we can record it here. Otherwise, we will return the type of the field we are operating on.
	

"
Class {
	#name : #FunctionExpression,
	#superclass : #GlorpExpression,
	#instVars : [
		'function',
		'base',
		'alias',
		'symbol',
		'type'
	],
	#classInstVars : [
		'functions'
	],
	#category : #'Glorp-Expressions'
}

{ #category : #accessing }
FunctionExpression class >> basicFunctions [
	functions isNil ifTrue: [functions := self createBasicFunctionsFor: nil].
	^functions.
]

{ #category : #setup }
FunctionExpression class >> createBasicFunctionsFor: anObject [
	| exists notExists defaultFunctions |
	defaultFunctions := IdentityDictionary new.
	defaultFunctions
		at: #descending put: (PostfixFunction named: 'DESC');
		at: #distinct put: (PrefixFunction named: 'DISTINCT');
		at: #max put: (PrefixFunction named: 'MAX');
		at: #min put: (PrefixFunction named: 'MIN');
		at: #sum put: (PrefixFunction named: 'SUM');
		at: #avg put: (PrefixFunction named: 'AVG');
		at: #average put: (PrefixFunction named: 'AVG');
		at: #toChar: put: (PrefixFunction named: 'TO_CHAR');
		at: #not put: (PrefixFunction named: 'NOT');
		at: #, put: (InfixFunction named: '||');
		at: #countStar put: (StandaloneFunction named: 'COUNT(*)');
		at: #count put: (PrefixFunction named: 'COUNT');
		at: #similarTo: put: (InfixFunction named: 'LIKE');
		at: #between:and: put: (InfixFunction named: #('BETWEEN' 'AND'));
		at: #isNil
			put:
				((RelationExpression new)
						relation: #=;
						rightChild: nil asGlorpExpression);
		at: #notNil
			put:
				((RelationExpression new)
						relation: #<>;
						rightChild: nil asGlorpExpression);
		at: #isNIL
			put:
				((RelationExpression new)
						relation: #=;
						rightChild: nil asGlorpExpression);
		at: #notNIL
			put:
				((RelationExpression new)
						relation: #<>;
						rightChild: nil asGlorpExpression).
	exists := InfixFunction named: 'EXISTS'.
	anObject isNil ifFalse: [exists type: anObject boolean].
	defaultFunctions at: #exists: put: exists.
	notExists := InfixFunction named: 'NOT EXISTS'.
	anObject isNil ifFalse: [notExists type: anObject boolean].
	defaultFunctions at: #notExists: put: notExists.

	defaultFunctions
		at: #asUppercase put: (PrefixFunction named: 'UPPER');
		at: #asLowercase put: (PrefixFunction named: 'LOWER');
		at: #replace:with: put: (PrefixFunction named: 'REPLACE');
		at: #cast: put: ((Cast named: 'CAST') separator: ' AS ');
		at: #copyFrom:to: put: (SubstringFunction named: 'SUBSTR').

	^defaultFunctions.
]

{ #category : #'instance creation' }
FunctionExpression class >> for: aSymbol withArguments: anArray basedOn: anExpression [
	| base system |
	base := anExpression ultimateBaseExpression.
	system := base isNil ifTrue: [nil] ifFalse: [base system].	
	^self for: aSymbol withArguments: anArray basedOn: anExpression system: system
]

{ #category : #'instance creation' }
FunctionExpression class >> for: aSymbol withArguments: anArray basedOn: anExpression system: system [
	| functionTemplate newFunction |
	functionTemplate := (system isNil
		ifTrue: [self basicFunctions]
		ifFalse: [system platform functions]) at: aSymbol ifAbsent: [^nil].
	newFunction := functionTemplate
		createFor: anArray
		withBase: anExpression
		symbol: aSymbol.
	^newFunction
]

{ #category : #initializing }
FunctionExpression class >> initialize [

	self resetFunctions.
]

{ #category : #private }
FunctionExpression class >> named: aString [
	"Used for creating template instances only"

	^self new function: aString
]

{ #category : #private }
FunctionExpression class >> resetFunctions [
	"self resetFunctions"
	functions := nil
]

{ #category : #accessing }
FunctionExpression >> alias [

	^ alias
]

{ #category : #accessing }
FunctionExpression >> alias: aString [

	alias := aString
]

{ #category : #accessing }
FunctionExpression >> arguments [

	^ #(  )
]

{ #category : #accessing }
FunctionExpression >> arguments: anArray [

	^ self
]

{ #category : #converting }
FunctionExpression >> asDistinctFieldOn: anExpression [

	self isDistinct ifTrue: [ ^ self asGlorpExpressionOn: anExpression ].
	^ super asDistinctFieldOn: anExpression
]

{ #category : #preparing }
FunctionExpression >> asExpressionJoiningSource: source toTarget: target [
	"Create a general expression which represents this relationship where the values of the targets (which are normally parameters) are supplied out of the context provided by 'target' and the source fields are referencing things out of the context of source. Produces something suitable for ANDing into an expression when doing a join
   Example: If we had CUSTOMER.ADDRESS_ID = ADDRESS.ID as a parameter, and we want to AND this into an expression [:customer | customer address street = 'Main'] then we have customer as a base, and we get
	(customer.ADDRESS.STREET = 'Main') AND (customer.CUSTOMER.ADDRESS_ID = customer.ADDRESS.ID)
	The primary key expression for the relationship has been translated into field references into the customer and address tables in a particular context."

	| newBase |
	newBase := base asExpressionJoiningSource: source toTarget: target.
	^ self copy
		  function: function;
		  base: newBase
]

{ #category : #converting }
FunctionExpression >> asNonDistinctField [

	^ self isDistinct
		  ifTrue: [ base ]
		  ifFalse: [ self ]
]

{ #category : #api }
FunctionExpression >> base [

	^ base
]

{ #category : #accessing }
FunctionExpression >> base: anExpression [

	base := anExpression
]

{ #category : #testing }
FunctionExpression >> canBeUsedForRetrieve [
	"Return true if this is a valid argument for a retrieve: clause"

	^ true
]

{ #category : #testing }
FunctionExpression >> canHaveBase [

	^ true
]

{ #category : #iterating }
FunctionExpression >> convertValueOf: anObject in: aDictionary [

	| translated |
	translated := anObject isGlorpExpression
		ifTrue: [anObject valueIn: aDictionary]
		ifFalse: [anObject].
	translated isGlorpExpression ifTrue: [^translated].
	^self base convertedDbValueOf: translated
]

{ #category : #accessing }
FunctionExpression >> convertedDbValueOf: anObject [
	"Not clear what should happen here, but let's just pass it through for the moment"

	^ (self converterForStType: anObject class)
		  convert: anObject
		  toDatabaseRepresentationAs: self type
]

{ #category : #converting }
FunctionExpression >> converterForStType: aClass [

	^ self type notNil
		  ifTrue: [ self type converterForStType: aClass ]
		  ifFalse: [ self field converterForStType: aClass ]
]

{ #category : #copying }
FunctionExpression >> createFor: arguments [

	| new |
	new := self copy.
	new arguments: arguments.
	new type: type.
	^ new
]

{ #category : #copying }
FunctionExpression >> createFor: anArray withBase: anExpression symbol: aSymbol [

	| new |
	new := self copy.
	new base: anExpression.
	new symbol: aSymbol.
	new type: type.
	new arguments: anArray.
	^ new
]

{ #category : #accessing }
FunctionExpression >> defaultType [
	"We don't know our type. Return a basic numeric type as being as good a guess as any."

	^ base system platform numeric
]

{ #category : #iterating }
FunctionExpression >> do: aBlock skipping: aSet [
	"Iterate over the expression tree. Keep track of who has already been visited, so we don't get trapped in cycles or visit nodes twice."

	(aSet includes: self) ifTrue: [ ^ self ].
	aSet add: self.
	base do: aBlock skipping: aSet.
	aBlock value: self
]

{ #category : #accessing }
FunctionExpression >> field [

	^ base field
]

{ #category : #accessing }
FunctionExpression >> fieldExpression [

	^ base fieldExpression
]

{ #category : #accessing }
FunctionExpression >> function: aString [

	function := aString
]

{ #category : #accessing }
FunctionExpression >> function: aString arguments: anArray [

	self function: aString
]

{ #category : #api }
FunctionExpression >> get: aSymbol withArguments: anArray [
	| functionExpression |
	functionExpression := self getFunction: aSymbol withArguments: anArray.
	functionExpression isNil ifFalse: [^functionExpression].
	^RelationExpression
		named: aSymbol
		basedOn: self
		withArguments: anArray
]

{ #category : #converting }
FunctionExpression >> hasField [
	"If we correspond to a single field, return it. This is a bit of a hack having this only here, because for some functions it doesn't work."

	^ base hasField
]

{ #category : #accessing }
FunctionExpression >> impliedSmalltalkType [

	type isNil ifFalse: [ ^ type impliedSmalltalkType ].
	^ self field impliedSmalltalkType
]

{ #category : #testing }
FunctionExpression >> isDistinct [

	^ function = 'DISTINCT'
]

{ #category : #testing }
FunctionExpression >> isGenerated [

	^ false
]

{ #category : #testing }
FunctionExpression >> isSameAliasedFieldAs: aFieldOrFunction [

	^ self == aFieldOrFunction
]

{ #category : #accessing }
FunctionExpression >> mappedFields [

	^ Array with: self
]

{ #category : #accessing }
FunctionExpression >> mappedFieldsCount [

	^ 1
]

{ #category : #accessing }
FunctionExpression >> name [

	^ function
]

{ #category : #printing }
FunctionExpression >> printOnlySelfOn: aStream [

	aStream nextPutAll: function
]

{ #category : #printing }
FunctionExpression >> printSQLOn: aStream withParameters: aDictionary [

	self subclassResponsibility
]

{ #category : #printing }
FunctionExpression >> printSelectSQLOn: aStream withParameters: aDictionary [

	self printSQLOn: aStream withParameters: aDictionary.
	alias notNil ifTrue: [
		aStream
			nextPutAll: ' AS ';
			nextPutAll: alias ]
]

{ #category : #printing }
FunctionExpression >> printTreeOn: aStream [

	aStream nextPutAll: function
]

{ #category : #testing }
FunctionExpression >> printsIntoJoins [
	"Certain functions should be printed into joins as well as into select lists (e.g. UPPER). However, there are others that don't (at least I don't think so) make any sense in joins, e.g. DISTINCT. Differentiate the two. Right now the only one I can think of that doesn't make sense is distinct. It's not clear to me that I'm not just hacking my way through this"

	^ self isDistinct not
]

{ #category : #navigating }
FunctionExpression >> queryLevelBaseExpression [

	^ base queryLevelBaseExpression
]

{ #category : #preparing }
FunctionExpression >> rebuildOn: aBaseExpression startingFrom: anExpression withOuterScopeBase: ultimateBaseExpression [

	| rebuilt |
	self == anExpression ifTrue: [^aBaseExpression].
	rebuilt := (base rebuildOn: aBaseExpression startingFrom: anExpression withOuterScopeBase: ultimateBaseExpression) getFunction: self symbol withArguments: (self arguments collect: [:each | each rebuildOn: aBaseExpression startingFrom: anExpression withOuterScopeBase: ultimateBaseExpression]) in: aBaseExpression system.
	rebuilt alias: self alias.
	^rebuilt
]

{ #category : #preparing }
FunctionExpression >> rewriteBooleanEquality: relation [

	base := base rewriteBooleanEquality: relation
]

{ #category : #accessing }
FunctionExpression >> symbol [

	^ symbol
]

{ #category : #accessing }
FunctionExpression >> symbol: aSymbol [

	symbol := aSymbol
]

{ #category : #accessing }
FunctionExpression >> table [

	(self hasField and: [ self field notNil ]) ifTrue: [
		^ self field table ].
	"If we don't have a field, then maybe we have a relationship mapping or a base, so get the descriptor's primary table. Relevant if we have a function like EXISTS"
	^ self base table
]

{ #category : #accessing }
FunctionExpression >> tablesToPrint [

	^ #(  )
]

{ #category : #compatibility }
FunctionExpression >> translateField: aField [

	^ base translateField: aField
]

{ #category : #accessing }
FunctionExpression >> type [

	| field |
	type isNil ifFalse: [ ^ type ].
	field := self field.
	^ field isNil
		  ifTrue: [ self defaultType ]
		  ifFalse: [ field type ]
]

{ #category : #accessing }
FunctionExpression >> type: aGlorpDatabaseType [

	type := aGlorpDatabaseType
]

{ #category : #navigating }
FunctionExpression >> ultimateBaseExpression [

	^ base ultimateBaseExpression
]

{ #category : #mapping }
FunctionExpression >> valueInBuilder: anElementBuilder [

	^ self base valueInBuilder: anElementBuilder as: self
]

{ #category : #mapping }
FunctionExpression >> valueInBuilder: anElementBuilder as: anExpression [

	^ self base valueInBuilder: anElementBuilder as: anExpression
]

{ #category : #copying }
FunctionExpression >> withTable: aTable [
	"For a function expression, we shouldn't need to do anything here. It will have already been rebuilt on a base that has aliases"

	^ self

	"	| copy newBase |
	newBase := BaseExpression new.
	newBase descriptor: base descriptor.
	copy := self rebuildOn: newBase.
	copy fieldExpression setTable: aTable.
	^copy."
]

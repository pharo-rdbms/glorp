"
This is the abstract superclass of builders. These assemble information, either primitive data or objects, from a database result set.

Subclasses must implement the following messages:
	building objects
		buildObjectFrom:
		findInstanceForRow:useProxy:
	selecting fields
		fieldsFromMyPerspective

Instance Variables:
	expression	<MappingExpression>	The expression we're mapping. e.g. if the query is reading people, this might be the expression corresponding to ""each address"", meaning that we build the address object related to the main Person instance by the given relationship. 
	fieldTranslations	<Array of: Integer>	 The translation of the field positions from where they are in the descriptor to where they are in the row we're reading. This is done so we can read the rows efficiently, by index, rather than doing lots of dictionary lookups by name. If we're doing a simple read, the translations will probably be a no-op, but if we read multiple objects, some of the fields will be in different positions than they are in our table definition.
	instance	<Object>	The thing we're constructing.
	isExpired	<Boolean>	If our instance is in cache, we use that instead. However, if the instance has expired, then we do something different (most likely force a refresh) than if it's still alive.
	key	<Object>	The key for this row. This is lazily computed, and ""self"" is used a special marker to indicate that it hasn't been computed yet.
	query	<AbstractReadQuery>	the query that we're building results for.
	requiresPopulating	<Boolean>	Do we need to populate the object. Will be false if the object was found in cache and hasn't expired.
	row	<Array>	The database results. May actually be a result set row of some sort rather than an array, depending on the dialect, but should always respond to indexing protocol.


"
Class {
	#name : #ElementBuilder,
	#superclass : #Object,
	#instVars : [
		'instance',
		'requiresPopulating',
		'key',
		'expression',
		'cursor',
		'fieldTranslations',
		'isExpired',
		'row',
		'query'
	],
	#category : #'Glorp-Queries'
}

{ #category : #'*Glorp' }
ElementBuilder class >> basicClassFor: anExpression in: aQuery [

	^(anExpression hasDescriptor and: [anExpression mapsSimpleObject not])
		ifTrue: [ObjectBuilder] 
		ifFalse: [DataElementBuilder].
]

{ #category : #'instance creation' }
ElementBuilder class >> basicFor: anExpression in: aQuery [

	^(self basicClassFor: anExpression in: aQuery) new
		expression: anExpression;
		query: aQuery;
		setup
]

{ #category : #'*Glorp' }
ElementBuilder class >> classFor: anExpression in: aQuery [
	
	((aQuery returnsDictionary and: [anExpression == aQuery baseExpression])
		or: [anExpression returnsDictionary])
			ifTrue: [^DictionaryBuilder].
	^self basicClassFor: anExpression in: aQuery.
]

{ #category : #'instance creation' }
ElementBuilder class >> for: anExpression in: aQuery [

	^(self classFor: anExpression in: aQuery) new
		expression: anExpression;
		query: aQuery;
		setup
]

{ #category : #testing }
ElementBuilder class >> isAbstract [

	^ self == ElementBuilder
]

{ #category : #'instance creation' }
ElementBuilder class >> new [

	^super new initialize
]

{ #category : #'building objects' }
ElementBuilder >> buildObjectFrom: anArray [ 
	self subclassResponsibility
]

{ #category : #testing }
ElementBuilder >> buildsObjects [
	^false
]

{ #category : #accessing }
ElementBuilder >> canCauseDuplicateRows [
	^false
]

{ #category : #copying }
ElementBuilder >> copy [
	^self shallowCopy postCopy
]

{ #category : #accessing }
ElementBuilder >> cursor [
	^cursor
]

{ #category : #accessing }
ElementBuilder >> cursor: aGlorpCursoredStream [
	cursor := aGlorpCursoredStream
]

{ #category : #'building objects' }
ElementBuilder >> didValidationFail: validateResult [
	^validateResult == false
]

{ #category : #accessing }
ElementBuilder >> expression [
	^expression
]

{ #category : #accessing }
ElementBuilder >> expression: anExpression [
	expression := anExpression
]

{ #category : #accessing }
ElementBuilder >> fieldTranslations [
	^fieldTranslations
]

{ #category : #accessing }
ElementBuilder >> fieldTranslations: aDictionary [ 
	fieldTranslations := aDictionary
]

{ #category : #'selecting fields' }
ElementBuilder >> fieldsForSelectStatement [

	^self subclassResponsibility
]

{ #category : #'selecting fields' }
ElementBuilder >> fieldsFromMyPerspective [
	self subclassResponsibility.
]

{ #category : #'building objects' }
ElementBuilder >> findInstanceForRow: aRow proxyType: proxyType [
	self subclassResponsibility
]

{ #category : #executing }
ElementBuilder >> hasFieldTranslations [
	^self fieldTranslations notNil
]

{ #category : #initialization }
ElementBuilder >> initialize [
]

{ #category : #accessing }
ElementBuilder >> instance [
	^instance
]

{ #category : #accessing }
ElementBuilder >> instanceValue [
	^instance
]

{ #category : #'building objects' }
ElementBuilder >> knitResultIn: aSimpleQuery [
	"Connect up our built object with any other builders that use the same thing"

	^self
]

{ #category : #copying }
ElementBuilder >> postCopy [
	instance := nil.
	row := nil.
	requiresPopulating := false.
	isExpired := false
]

{ #category : #accessing }
ElementBuilder >> query [
	^query
]

{ #category : #accessing }
ElementBuilder >> query: aQuery [ 
	query := aQuery
]

{ #category : #copying }
ElementBuilder >> reconcileWithBuilders: oldCollection andCopy: newCollection [
]

{ #category : #'building objects' }
ElementBuilder >> registerObjectInUnitOfWork [
	"If there is a current unit of work, then we must register in it, after population because that way the state is already in place. The nil checks are mostly for safety during unit tests, as those conditions should never occur in real use"
	query isNil ifTrue: [^self].
	query session isNil ifTrue: [^self].
	query session register: instance.
]

{ #category : #accessing }
ElementBuilder >> requiresDistinct [

	^expression requiresDistinct
]

{ #category : #accessing }
ElementBuilder >> requiresPopulating [
	^true
]

{ #category : #accessing }
ElementBuilder >> returnValueIn: aCursoredStream [
	^self instance
]

{ #category : #accessing }
ElementBuilder >> row [
	^row
]

{ #category : #accessing }
ElementBuilder >> row: anArray [
	"Since nil is a possible key value, use self as a special marker to indicate we haven't found the key yet"
	row == anArray ifFalse: [
		key := self].
	row := anArray
]

{ #category : #'building objects' }
ElementBuilder >> sendPostFetchValidateIn: aSession OnFailureDo: aBlock [
	| validateResult |
	validateResult := aSession sendPostFetchValidateEventTo: self instance.
	(self didValidationFail: validateResult) ifTrue: aBlock
]

{ #category : #accessing }
ElementBuilder >> session [
	^expression descriptor session
]

{ #category : #initialization }
ElementBuilder >> setup [
	"Do any initialization required once we've got our parameters"
	^self
]

{ #category : #accessing }
ElementBuilder >> subBuilders [
	^#()
]

{ #category : #accessing }
ElementBuilder >> system [
	^self session system.
]

{ #category : #'translating fields' }
ElementBuilder >> translateFieldPosition: aDatabaseField [ 
	fieldTranslations isNil ifTrue: [^aDatabaseField position].
	^fieldTranslations at: aDatabaseField
]

{ #category : #'translating fields' }
ElementBuilder >> valueOf: anExpression [
	^expression valueInBuilder: self
]

{ #category : #'translating fields' }
ElementBuilder >> valueOfField: aField [
	"aField is either a database field, or a constant expression containing a non-varying value that isn't derived from the row"
	(aField class == ConstantExpression) ifTrue: [^aField value].
	^self row at: (self translateFieldPosition: aField)
]

{ #category : #'translating fields' }
ElementBuilder >> valueOfField: aField in: aRow [
	"Since the elementBuilder now holds the row, #valueOfField: is preferred protocol, but some things (e.g. ad hoc mapping blocks) might still be using this, so left for compatibility"
	(aField class == ConstantExpression) ifTrue: [^aField value].
	^aRow at: (self translateFieldPosition: aField)
]

{ #category : #accessing }
ElementBuilder >> withAllSubBuilders [
	^Array with: self
]

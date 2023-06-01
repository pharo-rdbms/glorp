"
This is a subclass of builders that builds dictionaries. Basically it needs to build both the key and the value and then assemble them into a dictionary.

Instance Variables:
	keyBuilder	<ElementBuilderr>	The builder for the key
	valueBuilder	<ElementBuilder>	The builder for the value.


"
Class {
	#name : #DictionaryBuilder,
	#superclass : #ElementBuilder,
	#instVars : [
		'keyBuilder',
		'valueBuilder'
	],
	#category : #'Glorp-Queries'
}

{ #category : #'building objects' }
DictionaryBuilder >> buildObjectFrom: anArray [
	"We just build an association out of the sub-builders "

	self row: anArray
]

{ #category : #accessing }
DictionaryBuilder >> canCauseDuplicateRows [
	^expression class == MappingExpression and: [expression mapping isToManyRelationship]
]

{ #category : #'selecting fields' }
DictionaryBuilder >> fieldsForSelectStatement [
	^#()
]

{ #category : #'selecting fields' }
DictionaryBuilder >> fieldsFromMyPerspective [
	^#()
]

{ #category : #'building objects' }
DictionaryBuilder >> findInstanceForRow: aRow proxyType: proxyType [

	instance := Association new
]

{ #category : #accessing }
DictionaryBuilder >> instanceValue [
	^self instance value
]

{ #category : #'building objects' }
DictionaryBuilder >> knitResultIn: aCursoredStream [
	"Connect up our built object with any other objects that reference it. Used if we retrieve more than one thing in the same query"
	| relatedBuilder |
	instance key: keyBuilder instance.
	instance value: valueBuilder instance.

	"Code from ObjectBuilder>>knitResultIn:"
	expression canKnit ifFalse: [^self].
	relatedBuilder := aCursoredStream objectBuilderFor: expression base.
	(relatedBuilder isNil or: [relatedBuilder instance isNil]) 
		ifFalse: 
			[expression mapping knitFromBuilder: relatedBuilder toBuilder: self]
]

{ #category : #copying }
DictionaryBuilder >> postCopy [
]

{ #category : #copying }
DictionaryBuilder >> reconcileWithBuilders: oldCollection andCopy: newCollection [
	"Fix up references to our internal sub-builders"
	| keyIndex valueIndex |
	keyIndex := oldCollection indexOf: keyBuilder.
	keyBuilder := newCollection at: keyIndex.
	valueIndex := oldCollection indexOf: valueBuilder.
	valueBuilder := newCollection at: valueIndex
]

{ #category : #initialization }
DictionaryBuilder >> setup [
	"Do any initialization once we've got our parameters"
	| base collectionType |
	base := query baseExpression.
	collectionType := expression == base ifTrue: [query collectionType] ifFalse: [expression mapping query collectionType].
	keyBuilder := ElementBuilder for: (collectionType keyExpression asGlorpExpressionOn: expression) in: query.
	valueBuilder := ElementBuilder basicFor: (collectionType valueExpression asGlorpExpressionOn: expression) in: query
]

{ #category : #accessing }
DictionaryBuilder >> subBuilders [
	^Array with: keyBuilder with: valueBuilder
]

{ #category : #accessing }
DictionaryBuilder >> withAllSubBuilders [
	^Array with: self with: keyBuilder with: valueBuilder
]

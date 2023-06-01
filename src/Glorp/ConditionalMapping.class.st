"
This is a mapping that does different things depending on some testable condition. Depending on whether we're reading or writing, we are likely to test different things. This is useful if a field can be interpreted in more than one way. The API is rather messy.

Instance Variables:
	cases	<SequenceableCollection of: (Association)>	Used on read - a list of associations representing the cases we test. The key is either a one-argument block to be evaluated or a one-argument selector to be performed by the descriptorSystem, returning a boolean, and the value is the mapping to use if it returns true. 
	conditionalField	<DatabaseField>	The field whose value will be used as the argument to the blocks/selectors in cases.
	otherwiseCase	<Mapping>	If none of the other cases evaluate to true on read, use this mapping.

	conditionalMethod	<Block | Symbol>	Used on write - a zero-argument selector or one-argument block. The selector will be sent to the object being written, the block will be evaluated with that object as the argument. This is expected to return the object that will be written via the appropriate mapping.
	conditionalFieldMapping	<Mapping>	Used on write - the mapping used to write out the value in the conditional field.


"
Class {
	#name : #ConditionalMapping,
	#superclass : #Mapping,
	#instVars : [
		'conditionalField',
		'conditionalMethod',
		'cases',
		'otherwiseCase',
		'conditionalFieldMapping'
	],
	#category : #'Glorp-Mappings'
}

{ #category : #mapping }
ConditionalMapping >> applicableMappingForConditionalValue: rowValue [
	cases
		do:
			[:each | 
			((Dialect isBlock: each key)
				ifTrue: [each key value: rowValue]
				ifFalse: [self descriptor system perform: each key with: rowValue])
				ifTrue: [^each value]].
	^otherwiseCase
]

{ #category : #mapping }
ConditionalMapping >> applicableMappingForObject: anObject [
	| conditionalValue |
	conditionalValue := self conditionalValueFor: anObject.
	^self applicableMappingForConditionalValue: conditionalValue
]

{ #category : #mapping }
ConditionalMapping >> applicableMappingForRow: anArray in: anElementBuilder [
	"If a conditional field has been specified, then pass in the extracted value. Otherwise pass in the whole row"
	| rowValue |
	rowValue := conditionalField isNil
		ifFalse: [anElementBuilder valueOfField: conditionalField in: anArray]
		ifTrue: [anArray].
	^self applicableMappingForConditionalValue: rowValue
]

{ #category : #accessing }
ConditionalMapping >> attributeName [
	^self representativeMapping attributeName
]

{ #category : #accessing }
ConditionalMapping >> cases [
	^cases
]

{ #category : #accessing }
ConditionalMapping >> casesDo: aBlock [
	"Iterate over all of our cases"
	cases do: [:each | aBlock value: each value].
	aBlock value: otherwiseCase
]

{ #category : #accessing }
ConditionalMapping >> conditionalField: aField [

	(conditionalField notNil and: [conditionalField ~~ aField]) ifTrue: [self error: 'You can only test one field in a conditional mapping'].
	conditionalField := aField
]

{ #category : #accessing }
ConditionalMapping >> conditionalFieldMapping [
	^conditionalFieldMapping
]

{ #category : #accessing }
ConditionalMapping >> conditionalFieldMapping: aMapping [
	"This is a write-only mapping for the conditional field value, which writes out the result of performing the conditional method"
	conditionalFieldMapping := aMapping.
	descriptor isNil ifFalse: [aMapping descriptor: descriptor].
	(descriptor mappings includes: aMapping) ifTrue: [self error: 'Mapping is part of a conditional and part of the main descriptor. Be sure to send newMapping: to the conditional, not to the descriptor']
]

{ #category : #accessing }
ConditionalMapping >> conditionalMethod: aSymbol [
	(conditionalMethod notNil and: [conditionalMethod ~~ aSymbol]) ifTrue: [self error: 'You can only test one attribute in a conditional mapping'].
	conditionalMethod := aSymbol
]

{ #category : #mapping }
ConditionalMapping >> conditionalValueFor: anObject [
	^(Dialect isBlock: conditionalMethod)
		ifTrue: [conditionalMethod value: anObject]
		ifFalse: [anObject perform: conditionalMethod]
]

{ #category : #testing }
ConditionalMapping >> controlsTables [
	^self cases first value controlsTables
]

{ #category : #accessing }
ConditionalMapping >> descriptor: aDescriptor [

	super descriptor: aDescriptor.
	cases do: [:each | each value descriptor: aDescriptor].
	otherwiseCase isNil ifFalse: [otherwiseCase descriptor: aDescriptor].
	conditionalFieldMapping isNil ifFalse: [conditionalFieldMapping descriptor: aDescriptor]
]

{ #category : #accessing }
ConditionalMapping >> field [
	^self mappedFields asArray first
]

{ #category : #conditions }
ConditionalMapping >> forField: aField attribute: attributeBlock if: testBlock useMapping: aMapping [
	self conditionalField: aField.
	self conditionalMethod: attributeBlock.
	self if: testBlock then: aMapping
]

{ #category : #testing }
ConditionalMapping >> hasField [
	^self mappedFields size = 1
]

{ #category : #conditions }
ConditionalMapping >> if: conditionSelector then: aMapping [

	cases add: (Association key: conditionSelector value: aMapping).
	descriptor isNil ifFalse: [aMapping descriptor: descriptor].
	(descriptor mappings includes: aMapping) ifTrue: [self error: 'Mapping is part of a conditional and part of the main descriptor. Be sure to send newMapping: to the conditional, not to the descriptor']
]

{ #category : #initialization }
ConditionalMapping >> initialize [
	
	super initialize.
	cases := OrderedCollection new.
]

{ #category : #testing }
ConditionalMapping >> isRelationship [

	^false
]

{ #category : #preparing }
ConditionalMapping >> joinExpressionFor: anExpression [

	^self representativeMapping joinExpressionFor: anExpression
]

{ #category : #mapping }
ConditionalMapping >> mapFromObject: anObject intoRowsIn: aRowMap [ 
	self canWrite ifFalse: [^self].
	(self applicableMappingForObject: anObject) 
		mapFromObject: anObject
		intoRowsIn: aRowMap.
	conditionalFieldMapping isNil ifTrue: [^self].
	conditionalFieldMapping 
		mapFromObject: (self conditionalValueFor: anObject)
		intoRowsIn: aRowMap
]

{ #category : #mapping }
ConditionalMapping >> mapObject: anObject inElementBuilder: anElementBuilder [
	(self applicableMappingForRow: anElementBuilder row in: anElementBuilder)
		mapObject: anObject
		inElementBuilder: anElementBuilder
]

{ #category : #accessing }
ConditionalMapping >> mappedFields [

	| all |
	all := Set new.
	conditionalFieldMapping isNil 
		ifTrue: [conditionalField ifNotNil: [all add: conditionalField]]
		ifFalse: [all addAll: conditionalFieldMapping mappedFields].
	cases do: [:each |
		all addAll: each value mappedFields].
	^all
]

{ #category : #mapping }
ConditionalMapping >> newMapping: aMappingClass [
	"Implement this so that we can create our sub-mappings without having them added to the parent descriptor as independent mappings"
	| mapping |
	mapping := aMappingClass new.
	mapping descriptor: self descriptor.
	descriptor resetMappedFields.
	^mapping
]

{ #category : #accessing }
ConditionalMapping >> otherwise [
	^otherwiseCase
]

{ #category : #conditions }
ConditionalMapping >> otherwise: aMapping [

	otherwiseCase := aMapping.
	descriptor isNil ifFalse: [otherwiseCase descriptor: descriptor].
	(descriptor mappings includes: aMapping) ifTrue: [self error: 'Mapping is part of a conditional and part of the main descriptor. Be sure to send newMapping: to the conditional, not to the descriptor']
]

{ #category : #accessing }
ConditionalMapping >> referenceClass [
	^self representativeMapping referenceClass
]

{ #category : #mapping }
ConditionalMapping >> referencedIndependentObjectsFrom: anObject [

	| allReferencedObjects |
	allReferencedObjects := OrderedCollection new.
	cases do: [:each | 
		allReferencedObjects addAll: (each value referencedIndependentObjectsFrom: anObject)].
	^allReferencedObjects
]

{ #category : #accessing }
ConditionalMapping >> representativeMapping [
	"At some points we may need to have this mapping behave some way without knowing yet which of its cases is satisfied. We assume that there is some basic level of similarity so that we can use one mapping as a representative to discover, e.g. what the reference class is. This works all right for cases where we have a mapping or a constant. It wouldn't work very well if we have a one to one mapping to one class in case (a) but a many-many to an entirely different class in the other"
	^cases first value
]

{ #category : #conditions }
ConditionalMapping >> trace: aTracing context: anExpression [
	"To make a join, we need to look at all of our possible cases"

	conditionalFieldMapping isNil ifFalse: [
		conditionalFieldMapping trace: aTracing context: anExpression].
	cases do: [:each |
		each value trace: aTracing context: anExpression]
]

{ #category : #validation }
ConditionalMapping >> validateAttribute [
	cases do: [:each | each value validateAttribute].
	otherwiseCase validateAttribute.
	conditionalFieldMapping isNil ifFalse: [conditionalFieldMapping validateAttribute].
]

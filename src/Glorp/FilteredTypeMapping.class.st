"
FilteredTypeMapping assumes that all objects are stored in a single table, and there's a field in that table that identifies which subclass it is.

Instance Variables:
	field	<DatabaseField>	The field which identifies the subclass.
	key	<Object>	The value we expect to find in that field for this particular subclass
	keyDictionary	<Dictionary>	A dictionary for us and all of our subclasses from key values to subclass.


"
Class {
	#name : #FilteredTypeMapping,
	#superclass : #TypeMapping,
	#instVars : [
		'field',
		'key',
		'keyDictionary'
	],
	#category : #'Glorp-Mappings'
}

{ #category : #'instance creation' }
FilteredTypeMapping class >> to: field keyedBy: key [
	^(self new)
		field: field keyedBy: key
]

{ #category : #mapping }
FilteredTypeMapping >> addTypeMappingCriteriaTo: collection in: base [
	| singleRightValue r l |
	key isNil
		ifTrue: [ singleRightValue := self keys size = 1.
			r := ConstantExpression
				for:
					(singleRightValue
						ifTrue: [ self keys asArray first ]
						ifFalse: [ self keys ]) ]
		ifFalse: [ singleRightValue := true.
			r := ConstantExpression for: key ].
	l := FieldExpression forField: self field basedOn: base.
	collection
		add:
			(singleRightValue
				ifTrue: [ l equals: r ]
				ifFalse: [ l in: r ])
]

{ #category : #'initialize-release' }
FilteredTypeMapping >> buildKeyDictionary [
	| subclassDescriptor |
	keyDictionary := Dictionary new.
	key isNil ifFalse: [keyDictionary at: key put: descriptor describedClass].
	descriptor describedClass allSubclasses do: 
			[:each | 
			subclassDescriptor := descriptor system descriptorFor: each.
			(subclassDescriptor isNil 
				or: [subclassDescriptor typeMapping keyedBy isNil]) 
					ifFalse: 
						[keyDictionary at: subclassDescriptor typeMapping keyedBy
							put: subclassDescriptor describedClass]]
]

{ #category : #types }
FilteredTypeMapping >> describedConcreteClassFor: aRow withBuilder: builder [

	^self keyDictionary at: (aRow at: (builder translateFieldPosition: field))
]

{ #category : #accessing }
FilteredTypeMapping >> field [
	"If we don't have this, look it up from one of our sub-mappings"
	| concrete |
	field isNil ifTrue: [
		concrete := self descriptor typeResolver concreteMembers detect: [:each | each typeMapping field notNil].
		field := concrete typeMapping field].
	^field.
]

{ #category : #'initialize-release' }
FilteredTypeMapping >> field: aField keyedBy: aKey [
	field := aField.
	key := aKey
]

{ #category : #accessing }
FilteredTypeMapping >> keyDictionary [
	keyDictionary isNil ifTrue: [ self buildKeyDictionary ].
	^keyDictionary
]

{ #category : #accessing }
FilteredTypeMapping >> keyedBy [
	^key
]

{ #category : #accessing }
FilteredTypeMapping >> keyedBy: aKey [
	key := aKey
]

{ #category : #types }
FilteredTypeMapping >> keys [
	^self keyDictionary keys
]

{ #category : #mapping }
FilteredTypeMapping >> mapFromObject: anObject intoRowsIn: aRowMap [

	| row |
	self canWrite ifFalse: [^self].
	row := aRowMap findOrAddRowForTable: self field table withKey: anObject.
	row at: field put: key
]

{ #category : #accessing }
FilteredTypeMapping >> mappedFields [
	"Return a collection of fields that this mapping will write into any of the containing object's rows"

	^Array with: self field
]

{ #category : #mapping }
FilteredTypeMapping >> trace: aTracing context: anExpression [
	^self
]

{ #category : #mapping }
FilteredTypeMapping >> valueOfField: aField fromObject: anObject [
	^self keyDictionary keyAtValue: anObject class
]

"
This is a to-many mapping where the class in the collection is a simple type, not a compound object. This requires fiddling with the descriptors, to allow each such mapping to define a different descriptor for the target class. This should be regarded as something of a prototype. It seems to work, at least for basic operations, but it may well have problems.

Instance Variables:
	resultField	<DatabaseField>	The field in the target table in which we have our results.


"
Class {
	#name : 'DirectToManyMapping',
	#superclass : 'ToManyMapping',
	#instVars : [
		'resultField'
	],
	#category : 'Glorp-Mappings',
	#package : 'Glorp',
	#tag : 'Mappings'
}

{ #category : 'accessing' }
DirectToManyMapping >> attributeName: anAttributeName [
	^self attributeName: anAttributeName referenceClass: nil
]

{ #category : 'accessing' }
DirectToManyMapping >> attributeName: anAttributeName referenceClass: aClass [
	"In addition to setting the attribute, use that information to further configure our faked-up descriptor. We can pass in a reference class here, although this is only really useful if we don't already have an explicit classModel."
	| model |
	super attributeName: anAttributeName.
	aClass isNil ifFalse: [attribute type: aClass].
	model := GlorpClassModel for: super referenceClass.
	"We add a mapping for our value. We don't normally use this, because we expect people to refer directly to the attribute, but it means, for example, that the field shows up in our mapped fields without us having to fake it up. And you could write a query referring to anAttribute myValue if you wanted"
	model newAttributeNamed: #myValue type: self attribute type.
	self referenceDescriptor classModel: model
]

{ #category : 'accessing' }
DirectToManyMapping >> buildQuery [
	query := super buildQuery.
	query retrieve: [:x | x getField: resultField].
	^query
]

{ #category : 'mapping' }
DirectToManyMapping >> buildRowMapKeyForSource: source target: target index: index [
	"What should this do??? We want to distinguish the entries in e.g. # (1 2 3 3 4 3 5). Or do we? They aren't distinguishable in the DB. Does that mean we always want to write the order field? Or what? What if this is a set in memory. Then we really can't have two entries"
	^MultipleRowMapKey
		with: target yourSelf
		with: source yourSelf
		with: index
]

{ #category : 'converting' }
DirectToManyMapping >> convertedDbValueOf: anObject [
	"It may be that we need to introduce a converter here, the same as with a regular direct mapping"
	^anObject
]

{ #category : 'accessing' }
DirectToManyMapping >> descriptor: aDescriptor [
	super descriptor: aDescriptor.
	aDescriptor system privateAndBasicAddDescriptorFor: self as: self pseudoDescriptor
]

{ #category : 'accessing' }
DirectToManyMapping >> field [
	^resultField
]

{ #category : 'testing' }
DirectToManyMapping >> glorpCanHaveDescriptorDirectly [
	"We allow instances of ourselves to have a descriptor, which normally only classes can do. This is so that we can have multiple different descriptors in use for e.g. String, depending on the particular usage."
	^true
]

{ #category : 'accessing' }
DirectToManyMapping >> join: aJoin [
	"In addition to setting up the join, use that information to configure our faked up descriptor"
	| tables |
	super join: aJoin.
	tables := self targetTables asArray.
	tables size > 1
		ifTrue: [self error: 'Cannot have multiple tables for a direct toMany'].
	self referenceDescriptor table: tables first.
	"We add a mapping for our value. We don't normally use this, because we expect people to refer directly to the attribute, but it means, for example, that the field shows up in our mapped fields without us having to fake it up. And you could write a query referring to anAttribute myValue if you wanted"
	(self referenceDescriptor newMapping: DirectMapping) 
		from: #myValue to: resultField
]

{ #category : 'testing' }
DirectToManyMapping >> mapsSimpleObject [
	^true
]

{ #category : 'testing' }
DirectToManyMapping >> needsSpecialRowMapKey [
	"Return true if we have to use a special key object for the row map, rather than just our target. We always do, because our target may not have identity."

	^true
]

{ #category : 'mapping' }
DirectToManyMapping >> pseudoDescriptor [
	"Return a pretend descriptor for our reference class. Since that class is a primitive, it won't have a real descriptor, and it may vary by usage anyway"
	| pseudoDescriptor |
	pseudoDescriptor := Descriptor new.
	pseudoDescriptor system: descriptor system.
	^pseudoDescriptor
]

{ #category : 'accessing' }
DirectToManyMapping >> referenceClass [
	"Return ourselves as the reference class, as a sort of a proxy for what we really want, which is a primitive, and varies according to the relationship anyway. Note that we have stuffed in a descriptor in the system, with ourselves (this instance) as the class."
	^self
]

{ #category : 'accessing' }
DirectToManyMapping >> resultField [
	^resultField
]

{ #category : 'accessing' }
DirectToManyMapping >> resultField: aField [
	resultField := aField
]

{ #category : 'validation' }
DirectToManyMapping >> validate [
	super validate.
	"We have to write the order field. Otherwise, we get confused e.g. on deletion, because we don't have a way of telling the rows in the rowmap apart when the indexes have changed"
	(self readOnly not and: [shouldWriteTheOrderField not]) ifTrue: [self error: 'To-many mappings to simple types must write an order field so that we have some way to tell the rows apart'].

	"If we're for a pseudo-variable, we're neither reading nor writing, so we don''t need the order."
	self isForPseudoVariable ifTrue: [^self].
	orderBy isNil ifTrue: [self error: 'To-many mappings to simple types must specify and write an order field so that we have some way to tell the rows apart'].
]

{ #category : 'accessing' }
DirectToManyMapping >> writeExtraInformationInto: aRowMap atKey: rowMapKey forSourceObject: sourceObject targetObject: targetObject atIndex: index [
	super
		writeExtraInformationInto: aRowMap
		atKey: rowMapKey
		forSourceObject: sourceObject
		targetObject: targetObject
		atIndex: index.
	aRowMap
		at: self resultField
		key: rowMapKey
		put: targetObject
]

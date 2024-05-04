"
HorizontalTypeMapping assumes that all objects are stored in different tables. Only leaf classes in the inheritance hierarchy can be mapped. The descriptors for the classes themselves have the necessary information, our only job is to be involved in building up the query. Queries can be done either by splitting up into a series of separate queries, or as one horribly complex query with union all clauses.

Instance Variables:
	isAbstract	<Boolean>	Is this an abstract superclass.
	mappedClass	<Class>	The class that we are mapping.


"
Class {
	#name : 'HorizontalTypeMapping',
	#superclass : 'TypeMapping',
	#instVars : [
		'mappedClass',
		'isAbstract'
	],
	#category : 'Glorp-Mappings',
	#package : 'Glorp',
	#tag : 'Mappings'
}

{ #category : 'instance creation' }
HorizontalTypeMapping class >> forClass: aClass [
	^self new
		mappedClass: aClass;
		yourself
]

{ #category : 'mapping' }
HorizontalTypeMapping >> allDescribedConcreteClasses [
	| col |
	col := OrderedCollection new
		add: self describedClass;
		addAll: self describedClass allSubclasses;
		yourself.
	self needsWork: 'This belongs in someone else''s responsibility'.
	^col select: [:each |
		(self system descriptorFor: each) typeMapping isAbstract not ]
]

{ #category : 'accessing' }
HorizontalTypeMapping >> beAbstract [
	isAbstract := true
]

{ #category : 'accessing' }
HorizontalTypeMapping >> isAbstract [
	^isAbstract isNil ifTrue: [ isAbstract := false ] ifFalse: [ isAbstract ]
]

{ #category : 'mapping' }
HorizontalTypeMapping >> mapFromObject: anObject intoRowsIn: aRowMap [

	"do nothing"
]

{ #category : 'initialization' }
HorizontalTypeMapping >> mappedClass: aClass [
	mappedClass := aClass
]

{ #category : 'mapping' }
HorizontalTypeMapping >> mappedFields [
	^#()
]

{ #category : 'mapping' }
HorizontalTypeMapping >> trace: aTracing context: anExpression [

	^self
]

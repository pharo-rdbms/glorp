"
This implements inheritance where each concrete class is represented in its own table. Each table will duplicate the fields that are in common between the concrete classes.
"
Class {
	#name : #HorizontalTypeResolver,
	#superclass : #BasicTypeResolver,
	#instVars : [
		'shouldUseSingleQuery'
	],
	#category : 'Glorp-Mappings'
}

{ #category : #'instance creation' }
HorizontalTypeResolver class >> forRootClass: aClass [
	^(self new)
		rootClass: aClass;
		yourself
]

{ #category : #accessing }
HorizontalTypeResolver >> allTablesFor: aDescriptor [
	"Return all tables used by this descriptor or its subclasses."
	^(self descriptorsRequiringIndependentQueriesFor: aDescriptor describedClass) inject: OrderedCollection new into: [:sum :eachDescriptor |
		sum addAll: ((eachDescriptor == aDescriptor) ifTrue: [eachDescriptor tables] ifFalse: [eachDescriptor allTables]).
		sum]
]

{ #category : #accessing }
HorizontalTypeResolver >> classesRequiringIndependentQueriesFor: aClass [
	^(self descriptorsRequiringIndependentQueriesFor: aClass) collect: [:each |
		each describedClass]
]

{ #category : #accessing }
HorizontalTypeResolver >> describedConcreteClassFor: row withBuilder: builder descriptor: aDescriptor [
	^aDescriptor describedClass
]

{ #category : #accessing }
HorizontalTypeResolver >> descriptorsRequiringIndependentQueriesFor: aClass [
	^self concreteMembers select: [ :each | each describedClass includesBehavior: aClass ]
]

{ #category : #testing }
HorizontalTypeResolver >> isTypeMappingRoot: aDescriptor [
	^aDescriptor == rootDescriptor
]

{ #category : #'query setup' }
HorizontalTypeResolver >> mappingForSubclass: aDescriptor connectTo: existingSubclassMapping [
	"Create a pseudo-mapping for the subclass."
	| attributeName mapping newJoin |
	attributeName := self pseudoAttributeNameForClass: aDescriptor describedClass.
	mapping := self rootDescriptor mappingForAttributeNamed: attributeName.
	mapping isNil ifTrue: [
		rootDescriptor classModel newAttributeNamed: attributeName type: aDescriptor describedClass.
		mapping := (rootDescriptor newMapping: OneToOneMapping)
			attributeName: attributeName.
		mapping beForPseudoVariable.
		existingSubclassMapping isNil ifFalse: [
			newJoin := Join new.
			mapping join: newJoin]].
	^mapping
]

{ #category : #'query setup' }
HorizontalTypeResolver >> pseudoAttributeNameForClass: aClass [
	^('subclassPseudoVariable', aClass name) asSymbol
]

{ #category : #'query setup' }
HorizontalTypeResolver >> setUpExpressionsForQuery: aQuery [
	| mapping firstMapping allDescriptors |
	(self concreteMembers includes: aQuery resultClass) ifTrue: [^self].
	self shouldUseSingleQuery ifFalse: [^self].
	firstMapping := nil.
	allDescriptors := self
		descriptorsRequiringIndependentQueriesFor: aQuery resultClass.
	allDescriptors size = 1 ifTrue: [^self].
	allDescriptors
		do:
			[:eachSubclassDescriptor | 
			mapping := self
				mappingForSubclass: eachSubclassDescriptor
				connectTo: firstMapping.
			firstMapping isNil ifTrue: [firstMapping := mapping].
			aQuery
				alsoFetch:
					[:object | (object getMapping: mapping named: mapping attribute name) bePhantom asOuterJoin]]
]

{ #category : #accessing }
HorizontalTypeResolver >> shouldUseSingleQuery [
	"Return true if we should attempt to combine queries for multiple subclasses in disjoint tables into one."

	shouldUseSingleQuery isNil ifTrue: [shouldUseSingleQuery := false].
	^shouldUseSingleQuery.
]

{ #category : #testing }
HorizontalTypeResolver >> supportsOrderingFor: aDescriptor [
	concreteMembers detect: [:each | each == aDescriptor] ifNone: [^false].
	^true
]

{ #category : #testing }
HorizontalTypeResolver >> supportsUsingSingleQuery [
	"Return true if we should attempt to combine queries for multiple subclasses in disjoint tables into one."

	^system platform supportsSingleQueryHorizontalInheritance
]

{ #category : #accessing }
HorizontalTypeResolver >> useSingleQuery: aBoolean [
	shouldUseSingleQuery := aBoolean
]

{ #category : #accessing }
HorizontalTypeResolver >> useSingleQueryIfPossible: aBoolean [
	"Use single query if the platform allows it. Otherwise, don't."

	shouldUseSingleQuery := aBoolean and: [self supportsUsingSingleQuery]
]

"
This tests the conditional mapping basic API without going to the database.

"
Class {
	#name : #GlorpConditionalMappingTest,
	#superclass : #GlorpSessionBasedTest,
	#instVars : [
		'mapping',
		'descriptor',
		'mapping1',
		'mapping2',
		'mapping3',
		'newMapping'
	],
	#category : #'Glorp-Integration-Tests-Database'
}

{ #category : #support }
GlorpConditionalMappingTest >> setUp [
	super setUp.
	descriptor := system descriptorFor: GlorpPassenger.
	mapping := descriptor newMapping: ConditionalMapping.
	mapping conditionalField: (descriptor primaryTable fieldNamed: 'ID').
	mapping if: #testIDLessThan5: then: (mapping1 := DirectMapping from: #blah to: (descriptor primaryTable fieldNamed: 'ID')).
	mapping if: #testIDMoreThan5: then: (mapping2 := DirectMapping from: #bletch to: (descriptor primaryTable fieldNamed: 'NAME')).
	mapping otherwise: (mapping3 := DirectMapping from: #bazoomer to: (descriptor primaryTable fieldNamed: 'ID')).
	mapping conditionalMethod: #id.
]

{ #category : #support }
GlorpConditionalMappingTest >> setUpNew [
	"Set up using the newer protocol"
	newMapping := descriptor newMapping: ConditionalMapping.
	newMapping
		forField: (descriptor primaryTable fieldNamed: 'ID')
		attribute: #id
		if: [:value | value = 1]
		useMapping: (mapping1 := DirectMapping from: #blah to: (descriptor primaryTable fieldNamed: 'ID')).
	newMapping if: #testIDMoreThan5: then: (mapping2 := DirectMapping from: #bletch to: (descriptor primaryTable fieldNamed: 'NAME')).
	newMapping otherwise: (mapping3 := DirectMapping from: #bazoomer to: (descriptor primaryTable fieldNamed: 'ID')).
]

{ #category : #tests }
GlorpConditionalMappingTest >> testApplicableMappingForReadNewProtocol [

	| builder |
	self setUpNew.
	builder := ElementBuilder for: ([:x | x] asGlorpExpressionForDescriptor: descriptor) in: SimpleQuery new.
	self assert: (newMapping applicableMappingForRow: #(1 foo nil nil) in: builder) == mapping1.
	self assert: (newMapping applicableMappingForRow: #(6 foo nil nil) in: builder) == mapping2.
	self assert: (newMapping applicableMappingForRow: #(5 foo nil nil) in: builder) == mapping3.
]

{ #category : #tests }
GlorpConditionalMappingTest >> testApplicableMappingForReadOldProtocol [

	| builder |
	builder := ElementBuilder for: ([:x | x] asGlorpExpressionForDescriptor: descriptor) in: SimpleQuery new.
	self assert: (mapping applicableMappingForRow: #(1 foo nil nil) in: builder) == mapping1.
	self assert: (mapping applicableMappingForRow: #(6 foo nil nil) in: builder) == mapping2.
	self assert: (mapping applicableMappingForRow: #(5 foo nil nil) in: builder) == mapping3.
]

{ #category : #tests }
GlorpConditionalMappingTest >> testApplicableMappingForWriteNewProtocol [

	| passenger |
	self setUpNew.
	passenger := GlorpPassenger new.
	passenger id: 1.
	self assert: (newMapping applicableMappingForObject: passenger) == mapping1.
	passenger id: 6.
	self assert: (newMapping applicableMappingForObject: passenger) == mapping2.
	passenger id: 5.
	self assert: (newMapping applicableMappingForObject: passenger) == mapping3.
]

{ #category : #tests }
GlorpConditionalMappingTest >> testApplicableMappingForWriteOldProtocol [

	| passenger |
	passenger := GlorpPassenger new.
	passenger id: 1.
	self assert: (mapping applicableMappingForObject: passenger) == mapping1.
	passenger id: 6.
	self assert: (mapping applicableMappingForObject: passenger) == mapping2.
	passenger id: 5.
	self assert: (mapping applicableMappingForObject: passenger) == mapping3.
]

{ #category : #tests }
GlorpConditionalMappingTest >> testDescriptor [

	self assert: mapping1 descriptor == descriptor.
	self assert: mapping2 descriptor == descriptor.
	self assert: mapping3 descriptor == descriptor.
]

{ #category : #tests }
GlorpConditionalMappingTest >> testMappedFieldsOldProtocol [

	self assert: mapping mappedFields asSortedCollection = descriptor primaryTable fields asSortedCollection.

	mapping := descriptor newMapping: ConditionalMapping.
	self assert: mapping mappedFields isEmpty.

	mapping conditionalField: (descriptor primaryTable fieldNamed: 'ID').
	self assert: mapping mappedFields size = 1.	

	mapping if: #testIDLessThan5: then: (mapping1 := DirectMapping from: #blah to: (descriptor primaryTable fieldNamed: 'NAME')).
	self assert: mapping mappedFields asSortedCollection = descriptor primaryTable fields asSortedCollection.
]

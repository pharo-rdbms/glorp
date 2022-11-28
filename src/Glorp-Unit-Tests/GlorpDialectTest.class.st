"
Tests the portability methods in the Dialect class.
"
Class {
	#name : #GlorpDialectTest,
	#superclass : #GlorpTestCase,
	#category : #'Glorp-Unit-Tests-Tests'
}

{ #category : #tests }
GlorpDialectTest >> testBlockArgumentCount [
	self assert: (Dialect argumentCountFor: [3]) = 0.
	self assert: (Dialect argumentCountFor: [:a | 3]) = 1.
	self assert: (Dialect argumentCountFor: [:a :b | a <= b]) = 2.
]

{ #category : #tests }
GlorpDialectTest >> testClassImportLookup [
	self
		assert: (Dialect
					lookupClassNamed: 'AccessCast'
					inContextOf: GlorpDescriptorSystemWithNamespaces
					ifAbsent: [nil]) == AccessCast
		description: 'We cannot find a class visible in the environment of this class, not imported'.
	self
		assert: (Dialect
					lookupClassNamed: 'GlorpTestClassInNamespace'
					inContextOf: GlorpDescriptorSystemWithNamespaces
					ifAbsent: [nil]) == GlorpTestClassInNamespace
		description: 'We cannot find a class imported by the class but not visible in its environment'.
]

{ #category : #tests }
GlorpDialectTest >> testTimeSetMillisecond [
	| time oldMs oldSec oldMin newMs |
	Dialect supportsMillisecondsInTimes ifFalse: [^self].
	time := Time now.
	oldMs := time milliseconds.
	oldSec := time seconds truncated.
	oldMin := time minutes.
	newMs := oldMs > 989 ifTrue: [3] ifFalse: [oldMs + 10].
	time millisecond: newMs.
	self assert: time milliseconds = newMs.
	self assert: time seconds truncated = oldSec.
	self assert: time minutes = oldMin.
]

{ #category : #tests }
GlorpDialectTest >> testTokensBasedOn [
	self assert: (Dialect tokensBasedOn: '.' in: 'abc.def.ghi') asArray = #('abc' 'def' 'ghi').
]

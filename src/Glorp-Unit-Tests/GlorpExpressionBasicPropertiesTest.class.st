Class {
	#name : #GlorpExpressionBasicPropertiesTest,
	#superclass : #GlorpTestCase,
	#instVars : [
		'base'
	],
	#category : #'Glorp-Unit-Tests-Tests'
}

{ #category : #support }
GlorpExpressionBasicPropertiesTest >> setUp [

	base := BaseExpression new descriptor: (
		(GlorpDemoDescriptorSystem forPlatform: GlorpDatabaseLoginResource defaultLogin database)
			descriptorFor: GlorpPerson)
]

{ #category : #tests }
GlorpExpressionBasicPropertiesTest >> testHasDescriptorForBase [

	| exp |
	self assert: base hasDescriptor.
	exp := [:a | a ] asGlorpExpressionOn: base.
	self assert: exp hasDescriptor.
]

{ #category : #tests }
GlorpExpressionBasicPropertiesTest >> testHasDescriptorForDirect [

	| exp |
	exp := [:a | a id ] asGlorpExpressionOn: base.
	self deny: exp hasDescriptor.
]

{ #category : #tests }
GlorpExpressionBasicPropertiesTest >> testHasDescriptorForOneToMany [

	| exp |
	exp := [:a | a emailAddresses ] asGlorpExpressionOn: base.
	self assert: exp hasDescriptor.
]

{ #category : #tests }
GlorpExpressionBasicPropertiesTest >> testHasDescriptorForOneToOne [

	| exp |
	exp := [:a | a address ] asGlorpExpressionOn: base.
	self assert: exp hasDescriptor.
]

{ #category : #tests }
GlorpExpressionBasicPropertiesTest >> testHasDescriptorForPrimaryKeyExpression [

	| exp |
	exp := Join new.
	self deny: exp hasDescriptor.
]

{ #category : #tests }
GlorpExpressionBasicPropertiesTest >> testHasDescriptorForRelation [

	| exp |
	exp := [:a | a = 3] asGlorpExpressionOn: base.
	self deny: exp hasDescriptor.
]

{ #category : #tests }
GlorpExpressionBasicPropertiesTest >> testHasDescriptorForTwoLevelDirect [

	| exp |
	exp := [:a | a address street] asGlorpExpressionOn: base.
	self deny: exp hasDescriptor.
	self assert: exp base hasDescriptor.
]

{ #category : #tests }
GlorpExpressionBasicPropertiesTest >> testHasDescriptorForUninitializedBase [

	self deny: BaseExpression new hasDescriptor.
]

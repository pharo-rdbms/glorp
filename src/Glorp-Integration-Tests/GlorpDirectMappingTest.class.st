Class {
	#name : #GlorpDirectMappingTest,
	#superclass : #GlorpSessionBasedTest,
	#instVars : [
		'mapping'
	],
	#category : #'Glorp-Integration-Tests-Database'
}

{ #category : #running }
GlorpDirectMappingTest >> setUp [

	| descriptor |
	super setUp.
	mapping := DirectMapping from: #id to: ((system tableNamed: 'GR_CUSTOMER') fieldNamed: 'ID').
	descriptor := Descriptor new.
	descriptor classModel: (GlorpClassModel for: GlorpCustomer).
	descriptor addMapping: mapping
]

{ #category : #tests }
GlorpDirectMappingTest >> testExpressionFor [
	| cust exp |
	cust := GlorpCustomer new.
	cust id: 12.
	exp := mapping
		expressionFor: cust
		basedOn: BaseExpression new
		relation: #=.
	self assert: exp rightChild class == ConstantExpression.
	self assert: exp rightChild value = 12.
	self assert: exp relation = #=.
	self assert: exp leftChild class == MappingExpression.
]

{ #category : #tests }
GlorpDirectMappingTest >> testProxying [
	| customers |
	session beginTransaction.
	[((system descriptorFor: GlorpPerson) mappingForAttributeNamed: #name) shouldProxy: true.
	session modify: GlorpPerson example1 in: [].
	session reset.
	customers := session read: GlorpPerson.
	self assert: customers first name isGlorpProxy.
	self deny: customers first name isInstantiated.
	self assert: customers first name = 'Zaphod Beeblebrox']
		ensure: [session rollbackTransaction].
	self deny: ((system descriptorFor: GlorpPerson) mappedFields includes: ((system tableNamed: 'PERSON') fieldNamed: 'NAME')).
]

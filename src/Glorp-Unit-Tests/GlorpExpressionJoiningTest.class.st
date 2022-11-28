Class {
	#name : #GlorpExpressionJoiningTest,
	#superclass : #GlorpDatabaseBasedTest,
	#instVars : [
		'source',
		'target',
		'base'
	],
	#category : #'Glorp-Unit-Tests-Tests'
}

{ #category : #tests }
GlorpExpressionJoiningTest >> join: exp [ 
	^exp asExpressionJoiningSource: source toTarget: target
]

{ #category : #tests }
GlorpExpressionJoiningTest >> resultOfJoiningFieldFor: aTable toExpressionBuiltOn: anotherTable [
	| exp table |
	base descriptor: (system descriptorFor: GlorpCustomer).
	exp := FieldExpression forField: (aTable fieldNamed: 'ID')
				basedOn: BaseExpression new.
	table := base getTable: anotherTable.

	^exp asExpressionJoiningSource: base toTarget: table.
]

{ #category : #support }
GlorpExpressionJoiningTest >> setUp [
	super setUp.
	source := BaseExpression new.
	target := source get: #relation.
	base := BaseExpression new.
]

{ #category : #support }
GlorpExpressionJoiningTest >> tearDown [

	source := nil.
	target := nil.
	base := nil.
	system := nil.
]

{ #category : #tests }
GlorpExpressionJoiningTest >> testBase [
	| result |
	result := self join: base. 
	self assert: result == source.
]

{ #category : #tests }
GlorpExpressionJoiningTest >> testConstant [
	| exp |
	exp := ConstantExpression for: 42.
	self assert: (self join: exp) == exp
]

{ #category : #tests }
GlorpExpressionJoiningTest >> testField [
	| exp  result |
	exp := FieldExpression forField: (DatabaseField named: 'test' type: system platform int4)
				basedOn: base.
	result := self join: exp.
	self assert: result base == source.
	self assert: result field == exp field
]

{ #category : #tests }
GlorpExpressionJoiningTest >> testFieldBuiltOnDifferentTable [
	| result custTable |
	custTable := system tableNamed: 'GR_CUSTOMER'.
	result := self 
		resultOfJoiningFieldFor: custTable
		toExpressionBuiltOn: custTable.
	self assert: result base == (base getTable: custTable).
	self assert: result field == ((system tableNamed: 'GR_CUSTOMER') fieldNamed: 'ID').
]

{ #category : #tests }
GlorpExpressionJoiningTest >> testFieldBuiltOnSameTable [
	| exp result base2 table custTable |
	custTable := system tableNamed: 'GR_CUSTOMER'.
	base2 := BaseExpression new.
	base2 descriptor: (system descriptorFor: GlorpCustomer).
	table := base2 getTable: custTable.
	exp := FieldExpression forField: (custTable fieldNamed: 'ID')
				basedOn: base.
	result := exp asExpressionJoiningSource: base2 toTarget: table.
	self assert: result base == table.
	self assert: result field == exp field.
]

{ #category : #tests }
GlorpExpressionJoiningTest >> testMapping [
	| result exp |
	exp := base get: #foo.
	result := self join: exp. 
	self assert: result base == source.
	self assert: result name = #foo.
]

{ #category : #tests }
GlorpExpressionJoiningTest >> testParameter [
	| result exp table field |
	table := DatabaseTable named: 'T'.	
	field := DatabaseField named: 'F' type: system platform int4.
	table addField: field.
	exp := base getParameter: field.
	result := self join: exp.
	self assert: result base == source.
	self assert: result class == FieldExpression.
	self assert: result field == field.
]

{ #category : #tests }
GlorpExpressionJoiningTest >> testRelation [
	| result exp |
	exp := [:a | a foo = 3] asGlorpExpressionOn: base.
	result := self join: exp. 

	self assert: result class == RelationExpression.
	self assert: result rightChild == exp rightChild.
	self assert: result leftChild base == source.
]

{ #category : #tests }
GlorpExpressionJoiningTest >> testRelation2 [
	| result exp field | 
	field := DatabaseField named: 'fred' type: system platform int4.
	exp := [:a | a foo = field] asGlorpExpressionOn: base.
	result := self join: exp. 
	self assert: result class == RelationExpression.
	self assert: result rightChild class == FieldExpression.
	self assert: result rightChild field == field.
	self assert: result leftChild base == source.
]

{ #category : #tests }
GlorpExpressionJoiningTest >> testSelfJoinWithPrimaryKeyExpression [
	"This tests a join of a class to itself, in this case customers who have other customers associated with them. Useful for hierarchies"
	| pkExpression field result |
	field := (system tableNamed: 'GR_CUSTOMER') fieldNamed: 'ID'.
	pkExpression := Join 
		from: field
		to: field.
	result := self join: pkExpression.
	self assert: result leftChild basicField == field.
	self assert: result rightChild basicField == field.
	self assert: result rightChild base name = #relation.
]

{ #category : #tests }
GlorpExpressionJoiningTest >> testTable [
	| result exp table |
	table := DatabaseTable named: 'T'.
	exp := base getTable: table.
	result := self join: exp. 
	self assert: result base == target.
	self assert: result table == table.
]

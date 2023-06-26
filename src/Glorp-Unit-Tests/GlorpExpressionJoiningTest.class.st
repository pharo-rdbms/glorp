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

{ #category : #utilities }
GlorpExpressionJoiningTest >> join: exp [ 
	^exp asExpressionJoiningSource: source toTarget: target
]

{ #category : #utilities }
GlorpExpressionJoiningTest >> resultOfJoiningFieldFor: aTable toExpressionBuiltOn: anotherTable [
	| exp table |
	base descriptor: (system descriptorFor: GlorpCustomer).
	exp := FieldExpression forField: (aTable fieldNamed: 'ID')
				basedOn: BaseExpression new.
	table := base getTable: anotherTable.

	^exp asExpressionJoiningSource: base toTarget: table.
]

{ #category : #running }
GlorpExpressionJoiningTest >> setUp [

	super setUp.
	source := BaseExpression new.
	target := source get: #relation.
	base := BaseExpression new
]

{ #category : #running }
GlorpExpressionJoiningTest >> tearDown [

	source := nil.
	target := nil.
	base := nil.
	system := nil.
	super tearDown
]

{ #category : #tests }
GlorpExpressionJoiningTest >> testBase [

	| result |
	result := self join: base.
	self assert: result identicalTo: source
]

{ #category : #tests }
GlorpExpressionJoiningTest >> testConstant [

	| exp |
	exp := ConstantExpression for: 42.
	self assert: (self join: exp) identicalTo: exp
]

{ #category : #tests }
GlorpExpressionJoiningTest >> testField [

	| exp result |
	exp := FieldExpression
		       forField:
		       (DatabaseField named: 'test' type: system platform int4)
		       basedOn: base.
	result := self join: exp.
	self assert: result base identicalTo: source.
	self assert: result field identicalTo: exp field
]

{ #category : #tests }
GlorpExpressionJoiningTest >> testFieldBuiltOnDifferentTable [

	| result custTable |
	custTable := system tableNamed: 'GR_CUSTOMER'.
	result := self
		          resultOfJoiningFieldFor: custTable
		          toExpressionBuiltOn: custTable.
	self assert: result base identicalTo: (base getTable: custTable).
	self
		assert: result field
		identicalTo: ((system tableNamed: 'GR_CUSTOMER') fieldNamed: 'ID')
]

{ #category : #tests }
GlorpExpressionJoiningTest >> testFieldBuiltOnSameTable [

	| exp result base2 table custTable |
	custTable := system tableNamed: 'GR_CUSTOMER'.
	base2 := BaseExpression new.
	base2 descriptor: (system descriptorFor: GlorpCustomer).
	table := base2 getTable: custTable.
	exp := FieldExpression
		       forField: (custTable fieldNamed: 'ID')
		       basedOn: base.
	result := exp asExpressionJoiningSource: base2 toTarget: table.
	self assert: result base identicalTo: table.
	self assert: result field identicalTo: exp field
]

{ #category : #tests }
GlorpExpressionJoiningTest >> testMapping [

	| result exp |
	exp := base get: #foo.
	result := self join: exp.
	self assert: result base identicalTo: source.
	self assert: result name equals: #foo
]

{ #category : #tests }
GlorpExpressionJoiningTest >> testParameter [

	| result exp table field |
	table := DatabaseTable named: 'T'.
	field := DatabaseField named: 'F' type: system platform int4.
	table addField: field.
	exp := base getParameter: field.
	result := self join: exp.
	self assert: result base identicalTo: source.
	self assert: result class identicalTo: FieldExpression.
	self assert: result field identicalTo: field
]

{ #category : #tests }
GlorpExpressionJoiningTest >> testRelation [

	| result exp |
	exp := [ :a | a foo = 3 ] asGlorpExpressionOn: base.
	result := self join: exp.
	self assert: result class identicalTo: RelationExpression.
	self assert: result rightChild identicalTo: exp rightChild.
	self assert: result leftChild base identicalTo: source
]

{ #category : #tests }
GlorpExpressionJoiningTest >> testRelation2 [

	| result exp field |
	field := DatabaseField named: 'fred' type: system platform int4.
	exp := [ :a | a foo = field ] asGlorpExpressionOn: base.
	result := self join: exp.
	self assert: result class identicalTo: RelationExpression.
	self assert: result rightChild class identicalTo: FieldExpression.
	self assert: result rightChild field identicalTo: field.
	self assert: result leftChild base identicalTo: source
]

{ #category : #tests }
GlorpExpressionJoiningTest >> testSelfJoinWithPrimaryKeyExpression [
	"This tests a join of a class to itself, in this case customers who have other customers associated with them. Useful for hierarchies"

	| pkExpression field result |
	field := (system tableNamed: 'GR_CUSTOMER') fieldNamed: 'ID'.
	pkExpression := Join from: field to: field.
	result := self join: pkExpression.
	self assert: result leftChild basicField identicalTo: field.
	self assert: result rightChild basicField identicalTo: field.
	self assert: result rightChild base name equals: #relation
]

{ #category : #tests }
GlorpExpressionJoiningTest >> testTable [

	| result exp table |
	table := DatabaseTable named: 'T'.
	exp := base getTable: table.
	result := self join: exp.
	self assert: result base identicalTo: target.
	self assert: result table identicalTo: table
]

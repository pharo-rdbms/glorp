Class {
	#name : #GlorpExpressionIterationTest,
	#superclass : #GlorpTestCase,
	#category : 'Glorp-Tests-Tests'
}

{ #category : #tests }
GlorpExpressionIterationTest >> helpTestSingleNodeDo: exp [ 
	self assert: (exp collect: [:each | each]) = (OrderedCollection with: exp)
]

{ #category : #tests }
GlorpExpressionIterationTest >> testDoBase [
	self helpTestSingleNodeDo:BaseExpression new
]

{ #category : #tests }
GlorpExpressionIterationTest >> testDoCollection [

	| exp l r |
	exp := CollectionExpression new.
	l := BaseExpression new.
	r := BaseExpression new.
	exp leftChild: l; rightChild: r.
	self assert: ((exp collect: [:each | each]) = (OrderedCollection with: r with: exp)).
]

{ #category : #tests }
GlorpExpressionIterationTest >> testDoConstant [
	self helpTestSingleNodeDo: ConstantExpression new
]

{ #category : #tests }
GlorpExpressionIterationTest >> testDoField [

	| exp |
	exp := FieldExpression new.
	exp field: nil base: BaseExpression new.
	self assert: ((exp collect: [:each | each]) = (OrderedCollection with: exp base with: exp)).
]

{ #category : #tests }
GlorpExpressionIterationTest >> testDoMapping [

	| exp |
	exp := MappingExpression new.
	exp named: 'foo' basedOn: BaseExpression new.
	self assert: ((exp collect: [:each | each]) = (OrderedCollection with: exp base with: exp)).
]

{ #category : #tests }
GlorpExpressionIterationTest >> testDoParameter [

	| exp |
	exp := ParameterExpression new.
	exp field: nil base: BaseExpression new.
	self assert: ((exp collect: [:each | each]) = (OrderedCollection with: exp base with: exp)).
]

{ #category : #tests }
GlorpExpressionIterationTest >> testDoRelation [

	| exp l r |
	exp := RelationExpression new.
	l := BaseExpression new.
	r := BaseExpression new.
	exp leftChild: l; rightChild: r.
	self assert: ((exp collect: [:each | each]) = (OrderedCollection with: l with: r with: exp)).
]

{ #category : #tests }
GlorpExpressionIterationTest >> testDoTable [

	| exp |
	exp := TableExpression new.
	exp table: nil base: BaseExpression new.
	self assert: ((exp collect: [:each | each]) = (OrderedCollection with: exp base with: exp)).
]

{ #category : #tests }
GlorpExpressionIterationTest >> testDoWithCommonBase [

	| exp l r base |
	exp := RelationExpression new.
	base := BaseExpression new.
	l := MappingExpression new.
	l named: nil basedOn: base.
	r := MappingExpression new.
	r named: nil basedOn: base.
	exp leftChild: l; rightChild: r.	
	self assert: ((exp collect: [:each | each]) = (OrderedCollection with: base with: l with: r with: exp)).
]

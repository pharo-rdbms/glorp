Class {
	#name : #GlorpExpressionTableAliasingTest,
	#superclass : #GlorpDatabaseBasedTest,
	#instVars : [
		'exp'
	],
	#category : 'Glorp-Tests-Tests'
}

{ #category : #support }
GlorpExpressionTableAliasingTest >> helpTestBasicAliasing: aTable [
	self deny: exp hasTableAliases.
	exp assignTableAliasesStartingAt: 1 prefix: 's1t'.
	self assert: exp hasTableAliases.
	self assert: exp tableAliases size = 1.
	self assert: (exp tableAliases at: aTable) name = 's1t1'.
]

{ #category : #tests }
GlorpExpressionTableAliasingTest >> testBase [
	exp := BaseExpression new.
	exp descriptor: (system descriptorFor: GlorpCustomer).
	self helpTestBasicAliasing: (system tableNamed: 'GR_CUSTOMER').
]

{ #category : #tests }
GlorpExpressionTableAliasingTest >> testMapping [
	| base |
	base := BaseExpression new.
	base descriptor: (system descriptorFor: GlorpCustomer).
	exp := base get: 'transactions'.
	self helpTestBasicAliasing: (system tableNamed: 'BANK_TRANS').
]

{ #category : #tests }
GlorpExpressionTableAliasingTest >> testTable [
	| base transTable |
	base := BaseExpression new.
	base descriptor: (system descriptorFor: GlorpCustomer).
	transTable := system tableNamed: 'BANK_TRANS'.
	exp := base getTable: transTable.
	self helpTestBasicAliasing: transTable
]

{ #category : #tests }
GlorpExpressionTableAliasingTest >> testTableSameAsBase [
	| base custTable |
	base := BaseExpression new.
	base descriptor: (system descriptorFor: GlorpCustomer).
	custTable := system tableNamed: 'GR_CUSTOMER'.
	exp := base getTable: custTable.
	self deny: exp hasTableAliases.
	exp assignTableAliasesStartingAt: 1 prefix: ''.
	base assignTableAliasesStartingAt: 42 prefix: nil.
	self deny: exp hasTableAliases.
	self assert: (exp aliasedTableFor: custTable) name = 't42'.
]

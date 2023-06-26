Class {
	#name : #GlorpQueryTableAliasingTest,
	#superclass : #GlorpDatabaseBasedTest,
	#instVars : [
		'query',
		'expression',
		'elementBuilder',
		'session'
	],
	#category : #'Glorp-Unit-Tests-Tests'
}

{ #category : #printing }
GlorpQueryTableAliasingTest >> helpTestPrintingWhereClause: anExpression [
	| command |
	query 
		initResultClass: GlorpCustomer
		whereClause: expression
		singleObject: true.
	query setupTracing.
	query computeFields.
	command := GlorpNullCommand useBinding: false session: session.
	anExpression	
		printSQLOn: command
		withParameters: Dictionary new.
	^command sqlString.
]

{ #category : #running }
GlorpQueryTableAliasingTest >> setUp [

	super setUp.
	query := SimpleQuery new.
	expression := BaseExpression new.
	expression descriptor: (system descriptorFor: GlorpCustomer).
	(expression descriptor mappingForAttributeNamed: #name) shouldProxy: false.
	elementBuilder := ObjectBuilder for: expression in: query.
	expression aliasTable: (system tableNamed: 'GR_CUSTOMER') to: 't1'.
	session := GlorpSession new.
	session system: system.
	query session: system session
]

{ #category : #tests }
GlorpQueryTableAliasingTest >> testAliasWithEmbeddedMapping [

	self unfinished.
]

{ #category : #tests }
GlorpQueryTableAliasingTest >> testBuildingObject [

	| customer |
	elementBuilder instance: GlorpCustomer new.
	elementBuilder requiresPopulating: true.
	elementBuilder buildObjectFrom: #(12 'Name').
	customer := elementBuilder instance.
	self assert: customer class == GlorpCustomer.
	self assert: customer id equals: 12.
	self assert: customer name equals: 'Name'
]

{ #category : #tests }
GlorpQueryTableAliasingTest >> testElementBuilderFields [
	elementBuilder fieldsForSelectStatement
		do: [:each | self assert: each table name equals: 't1']
]

{ #category : #tests }
GlorpQueryTableAliasingTest >> testExpressionTableAlias [
	| fields |
	fields := expression translateFields: expression descriptor mappedFields.
	fields do: [:each | self assert: each table name equals: 't1']
]

{ #category : #tests }
GlorpQueryTableAliasingTest >> testQueryPrintingFields [
	| stream |
	query 
		initResultClass: GlorpCustomer
		whereClause: expression
		singleObject: true.
	query limit: nil.
	query setupTracing.
	query computeFields.
	stream := String new writeStream.
	query printSelectFieldsOn: stream.
	self assert: stream contents equals: 't1.ID, t1.NAME'
]

{ #category : #tests }
GlorpQueryTableAliasingTest >> testQueryPrintingSimpleWhereClause [
	| string |
	string := self helpTestPrintingWhereClause: ((expression get: #name) get: #= withArguments: #('Fred')).
	self assert: '(t1.NAME = ''Fred'')' equalsIgnoringOuterBrackets: string.
]

{ #category : #tests }
GlorpQueryTableAliasingTest >> testQueryPrintingTables [
	| stream string |
	query
		initResultClass: GlorpCustomer
		whereClause: expression
		singleObject: true.
	query setupTracing.
	query computeFields.
	stream := String new writeStream.
	query printTablesOn: stream.
	string := stream contents.
	self assert: string withUnixLineEndings equals: '<n> FROM GR_CUSTOMER t1' expandMacros withUnixLineEndings
]

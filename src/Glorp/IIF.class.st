"
This represents a MS ACCESS function which prints prefix, printing IIF, followed by the argument in parentheses, and then the rest of the MS SQL Server CASE statement, with a single test condition (WHEN) and a default value (ELSE):

Example: IIF(Condition, ReturnIfTrue, ReturnIfValue)
	IIF ( base? = arg1, arg2, arg3 ) AS alias

For example:
	IIF (('SELECT count(*) FROM aTable')= '0', 0, 1 ) AS alias
"
Class {
	#name : #IIF,
	#superclass : #PrefixFunction,
	#instVars : [
		'argumentTypes'
	],
	#category : #'Glorp-Expressions'
}

{ #category : #accessing }
IIF >> argumentTypes: anArray [

	argumentTypes := anArray
]

{ #category : #initialization }
IIF >> initialize [

	super initialize.
	function := 'IIF'.
	separator := ' '.
	argumentTypes := OrderedCollection new: 3
]

{ #category : #printing }
IIF >> printBasicSQLOn: aStream withParameters: aDictionary forSelect: aBoolean [
	"Example: IIF(Condition, ReturnIfTrue, ReturnIfValue)
		IIF ( base? = arg1, arg2, arg3 ) AS alias"

	aStream
		nextPutAll: 'IIF( '.
	aBoolean
		ifTrue: [base printSelectSQLOn: aStream withParameters: aDictionary]
		ifFalse: [base printSQLOn: aStream withParameters: aDictionary].
	aStream nextPutAll: ' ='.
	arguments size ~= 3 ifTrue: [self error].
	1 to: 3 do: [:i| |argument argumentType|
			argument := arguments at: i.
			argumentType := argumentTypes at: i.
		"Our printing of constants with types is unfortunately tied up with relation expressions, so we shortcircuit some of the logic and just have the types print directly. This will not let us e.g. bind parameters to this function, but we don't expect to be doing that right now."
		argumentType print: argument on: aStream.
		i = 3 ifFalse: [aStream nextPutAll: ', ']].
	aStream nextPutAll: ' ) '.
	alias notNil
		ifTrue: [aStream
				nextPutAll: ' AS ';
				nextPutAll: alias]
]

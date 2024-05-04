"
This represents a function which prints prefix, printing CASE, followed by the argument in parentheses, and then the rest of the MS SQL Server CASE statement, with a single test condition (WHEN) and a default value (ELSE):

CASE (arg1)
	WHEN arg2 THEN arg3 
	ELSE arg4
END AS arg5

For example:

CASE ('SELECT count(*) FROM aTable')
	WHEN '0' THEN 0 
	ELSE 1 
END AS arg3

"
Class {
	#name : 'Case',
	#superclass : 'PrefixFunction',
	#instVars : [
		'argumentTypes'
	],
	#category : 'Glorp-Expressions',
	#package : 'Glorp',
	#tag : 'Expressions'
}

{ #category : 'accessing' }
Case >> argumentTypes: anArray [

	argumentTypes := anArray
]

{ #category : 'initialization' }
Case >> initialize [

	super initialize.
	function := 'CASE'.
	separator := ' '.
	argumentTypes := OrderedCollection new: 3
]

{ #category : 'printing' }
Case >> printBasicSQLOn: aStream withParameters: aDictionary forSelect: aBoolean [
	"Example: CASE (base?)
		WHEN arg1 THEN arg2 
		 ELSE arg3
	END AS alias"
	
	aStream
		nextPutAll: function;
		nextPut: $(.
	aBoolean
		ifTrue: [base printSelectSQLOn: aStream withParameters: aDictionary]
		ifFalse: [base printSQLOn: aStream withParameters: aDictionary].
	aStream nextPutAll: ')'.
	1 to: arguments size do: [:i |
		| keyword argument argumentType |
		keyword := #(' WHEN ' ' THEN ' ' ELSE ') at: i.
		argument := arguments at: i.
		argumentType := argumentTypes at: i.
		aStream nextPutAll: keyword.
		"Our printing of constants with types is unfortunately tied up with relation expressions, so we shortcircuit some of the logic and just have the types print directly. This will not let us e.g. bind parameters to this function, but we don't expect to be doing that right now."
		argumentType print: argument on: aStream].

	aStream nextPutAll: ' END '.
	alias notNil
		ifTrue: [aStream
				nextPutAll: ' AS ';
				nextPutAll: alias]
]

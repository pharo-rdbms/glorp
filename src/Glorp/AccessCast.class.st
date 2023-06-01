"
This class provides limited CAST functionality for MS Access, which doesn't use CAST but instead provides some conversion functions.
This class attempts to find the correct conversion function for the intended CAST operation. It ignores the source type, and uses the argument to determine which conversion function to use.

	Here are some of Access' convesion functions: CDBL(), CSTR(), CBOOL(), CLNG(). Also, INT(), which yields a truncated double.
	DATETIME is actually a Double, with Date().Time().
	Get date, the integer part, from a DATETIME with: Int(Now()) == DateValue(#3/31/1999#).
	Get DOUBLE from DATETIME with: CDbl(Now()).
	Get DATETIME back froum DOUBLE with: CVDate(Cdbl(Now())).
	Get DATETIME from DATE with: CVDate( CDate( #Jan 31, 1994#) ).

"
Class {
	#name : #AccessCast,
	#superclass : #Cast,
	#category : #'Glorp-Expressions'
}

{ #category : #functions }
AccessCast >> castFunctionName [

	| targetType conversionFunctions |
	conversionFunctions := (Dictionary new)
				at: #timestamp put: 'CVDATE';
				at: #date put: 'CDATE';
				at: #integer put: 'CLNG';
				at: #double put: 'CDBL';
				at: #string put: 'CSTR';
				at: #boolean put: 'CBOOL';
				yourself.
	targetType := arguments first.
	^ conversionFunctions at: targetType value selector
]

{ #category : #initialization }
AccessCast >> initialize [

	super initialize.
	function := 'CAST'.
	separator := ''
]

{ #category : #printing }
AccessCast >> printBasicSQLOn: aStream withParameters: aDictionary forSelect: aBoolean [

	aStream
		nextPutAll: self castFunctionName;
		nextPut: $(.
	aBoolean
		ifTrue: [base printSelectSQLOn: aStream withParameters: aDictionary]
		ifFalse: [base printSQLOn: aStream withParameters: aDictionary].
	aStream nextPut: $).
	alias notNil
		ifTrue:
			[aStream
				nextPutAll: ' AS ';
				nextPutAll: alias]
]

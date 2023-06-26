Class {
	#name : #GlorpSQLPrintingTest,
	#superclass : #GlorpTestCase,
	#category : #'Glorp-Unit-Tests-Tests'
}

{ #category : #utilities }
GlorpSQLPrintingTest >> assertGroupWritingOnPlatform: platform [
	| system row1 row2 command string session |
	session := GlorpDemoDescriptorSystem sessionForLogin: (Login new database: platform).
	system := session system.
	row1 := DatabaseRow newForTable: (system tableNamed: 'GR_ADDRESS').
	row1 atFieldNamed: 'ID' put: 1.
	row2 := DatabaseRow newForTable: (system tableNamed: 'GR_ADDRESS').
	row2 atFieldNamed: 'ID' put: 2.
	command := InsertCommand forRows: (Array with: row1 with: row2) useBinding: false session: session.
	string := command sqlString.
	self assert: (string includes: $;).
	self assert: string = 'INSERT INTO GR_ADDRESS (ID,STREET,HOUSE_NUM)  VALUES (1,NULL,NULL); INSERT INTO GR_ADDRESS (ID,STREET,HOUSE_NUM)  VALUES (2,NULL,NULL)'.
]

{ #category : #tests }
GlorpSQLPrintingTest >> testDatePrinting [

	| date stream |
	date := Dialect newDateWithYears: 1997 months: 11 days: 14.
	stream := WriteStream on: String new.
	date glorpPrintSQLOn: stream.
	self assert: stream contents equals: '''1997-11-14'''.

	date := Dialect newDateWithYears: 2002 months: 5 days: 2.
	stream := WriteStream on: String new.
	date glorpPrintSQLOn: stream.
	self assert: stream contents equals: '''2002-05-02'''
]

{ #category : #tests }
GlorpSQLPrintingTest >> testGroupWriting [
	"Oracle does not group-write:  when binding, it says it does solely to take the code path that leads to array buinding.  We therefore do not test Oracle here."

	| platform |
	platform := PostgreSQLPlatform new.
	platform useBinding: false.
	self assertGroupWritingOnPlatform: platform.

	platform := SQLServerPlatform new.
	platform useBinding: false.
	self assertGroupWritingOnPlatform: platform.
	platform := SQLServerPlatform new.
	platform useBinding: true.
	self assertGroupWritingOnPlatform: platform
]

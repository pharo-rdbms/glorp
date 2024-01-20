Class {
	#name : #GlorpDatabasePlatformTest,
	#superclass : #GlorpTestCase,
	#category : #'Glorp-Unit-Tests-Tests'
}

{ #category : #utilities }
GlorpDatabasePlatformTest >> addToString: aString [
	"Append a couple of special characters. The result will utf-8 encode to be 3 characters longer than its number of characters"
	^aString, (String with: (Character value: 16r2022) "bullet point" with: (Character value: 16r0131) "Turkish i with no dot")

"If PostgreSQL, or another DB returning true to measuresStringFieldWidthsInBytes, is provided in VA, this test must alter to
handle incompatible protocol between VW, which lacks Character>>asString and VA, in which String>>with:with: will not handle
double-byte entries.  The VA could be implemented as
	^aString, (Character value: 16r2022) asString, (Character value: 16r0131) asString
"
]

{ #category : #utilities }
GlorpDatabasePlatformTest >> helpTestPrintTimestamp: aTimestampString [

	| aStream ts timestamp |
	ts := DatabasePlatform new readTimestamp: aTimestampString for: nil.
	aStream := WriteStream on: String new.
	DatabasePlatform new printDate: ts isoFormatOn: aStream.
	aStream nextPut: Character space.
	DatabasePlatform new
		printTime: ts
		isoFormatOn: aStream
		milliseconds: Dialect supportsMillisecondsInTimes.
	timestamp := aStream contents.
	self assert: timestamp equals: aTimestampString
]

{ #category : #utilities }
GlorpDatabasePlatformTest >> string20 [

	| platform |
	platform := PostgresPlatform new.
	platform characterEncoding: #'utf-8'.
	^ platform varchar: 20
]

{ #category : #tests }
GlorpDatabasePlatformTest >> testNumericCoercion [

	| type platform num |
	type := GlorpNumericType new precision: 5; scale: 2.
	platform := DatabasePlatform new.
	num := Dialect coerceToDoublePrecisionFloat: (123456 / 100).
	self assert: (platform convertToNumber: num for: type) equals: num.
	num := Dialect coerceToDoublePrecisionFloat: (123450 / 100).
	self assert: (platform convertToNumber: num for: type) equals: num.
	num := Dialect coerceToDoublePrecisionFloat: (123450 / 1000).
	self assert: (platform convertToNumber: num for: type) equals: num.
	num := Dialect coerceToDoublePrecisionFloat: (123456 / 1000).
	self deny: (platform convertToNumber: num for: type) equals: num.
	
	type:= GlorpNumericType new precision: 7; scale: 4.
	
	"When coercing a smaller scale number to a larger scale, the number remains the same (7.2 => 7.20)"
	num := 759.343 asScaledDecimal:3.
	self assert: (platform convertToNumber: num for: type ) equals: num.
	
	"When coercing a higher scale number to a lower scale, the number is truncated and no longer equal (1.21 =>  1.2)"
	num := 32.28345s5.
	self deny: (platform convertToNumber: num for: type) equals: num.
]

{ #category : #tests }
GlorpDatabasePlatformTest >> testPrintTimestamp [

	| strings |
	strings := #( '2005-01-01 21:29:28.337'  '2005-01-01 01:02:00.037'  '2005-01-01 21:29:28.002'  '2005-01-01 21:29:28.001').
	strings do: [:each |
		self helpTestPrintTimestamp: each]
]

{ #category : #tests }
GlorpDatabasePlatformTest >> testReadTimestamp [

	| ts |
	ts := DatabasePlatform new readTimestamp: '2003-03-03 15:29:28.337-05' for: nil.
	self assert: ts asSeconds + ts offset asSeconds equals: 3224158168.
	self assert: ([ts asMilliseconds + ts offset asMilliSeconds = 3224158168337 ]
		on: MessageNotUnderstood
		do: [ :mnu | mnu return: mnu message selector = #asMilliseconds ]).

	ts := DatabasePlatform new readTimestamp: '2003-03-13 15:29:28.337-05' for: nil.
	self assert: ts asSeconds + ts offset asSeconds equals: 3225022168.
	self assert: ([ts asMilliseconds + ts offset asMilliSeconds = 3225022168337]
		on: MessageNotUnderstood
		do: [ :mnu | mnu return: mnu message selector = #asMilliseconds ])
]

{ #category : #tests }
GlorpDatabasePlatformTest >> testReadTimestampNoMS [

	| ts |
	ts := DatabasePlatform new readTimestamp: '2003-03-03 15:29:28-05' for: nil.
	self assert: ts year equals: 2003.
	self assert: ts monthIndex equals: 3.
	self assert: ts dayOfMonth equals: 3.
	self assert: ts hours equals: 15.
	self assert: ts minutes equals: 29.
	self assert: ts seconds truncated equals: 28.
	self assert: ([ ts milliseconds = 0 ]
		on: MessageNotUnderstood
		do: [ :mnu | mnu return: mnu message selector = #milliseconds ])
]

{ #category : #tests }
GlorpDatabasePlatformTest >> testReadTimestampNoMSNoTZ [

	| ts |
	ts := DatabasePlatform new readTimestamp: '2003-03-03 15:29:28' for: nil.
	self assert: ts year equals: 2003.
	self assert: ts monthIndex equals: 3.
	self assert: ts dayOfMonth equals: 3.
	self assert: ts hours equals: 15.
	self assert: ts minutes equals: 29.
	self assert: ts seconds truncated equals: 28.
	self assert: ([ ts milliseconds = 0 ]
		on: MessageNotUnderstood
		do: [ :mnu | mnu return: mnu message selector = #milliseconds ])
]

{ #category : #tests }
GlorpDatabasePlatformTest >> testReadTimestampNoTZ [

	| ts |
	ts := DatabasePlatform new readTimestamp: '1975-08-13 21:29:28.337' for: nil.
	self assert: ts year equals: 1975.
	self assert: ts monthIndex equals: 8.
	self assert: ts dayOfMonth equals: 13.
	self assert: ts hours equals: 21.
	self assert: ts minutes equals: 29.
	self assert: ts seconds truncated equals: 28.
	self assert: ([ ts milliseconds = 337]
		on: MessageNotUnderstood
		do: [ :mnu | mnu return: mnu message selector = #milliseconds ])
]

{ #category : #tests }
GlorpDatabasePlatformTest >> testReadTimestampOverflowDays [

	| ts |
	ts := DatabasePlatform new readTimestamp: '1975-08-13 21:29:28.337-05' for: nil.
	self assert: ts year equals: 1975.
	self assert: ts monthIndex equals: 8.
	self assert: ts dayOfMonth equals: 13.
	self assert: ts hours equals: 21.
	self assert: ts minutes equals: 29.
	self assert: ts seconds truncated equals: 28.
	self assert: ([ ts milliseconds = 337 ]
		on: MessageNotUnderstood
		do: [ :mnu | mnu return: mnu message selector = #milliseconds ])
]

{ #category : #tests }
GlorpDatabasePlatformTest >> testTrimString1 [
	"Normal ASCII"

	| type plat |
	type := self string20.
	plat := type platform.
	self assert: (plat trimString: 'abcdefghi' for: type) equals: 'abcdefghi'.
	self assert: (plat trimString: 'abcdefghijklmnopqrst' for: type) equals: 'abcdefghijklmnopqrst'.
	self assert: (plat trimString: 'abcdefghijklmnopqrstu' for: type) equals: 'abcdefghijklmnopqrst'.
	self assert: (plat trimString: 'abcdefghijklmnopqrstuvwxy' for: type) equals: 'abcdefghijklmnopqrst'
]

{ #category : #tests }
GlorpDatabasePlatformTest >> testTrimString2 [
	"Some special characters"

	| type plat string |

	type := self string20.
	plat := type platform.

	string := self addToString: 'abcdefghi'.
	self assert: (plat trimString: string for: type) equals: string.
	string := self addToString: 'abcdefghijklmno'.
	self assert: (plat trimString: string for: type) equals: string.
	string := self addToString: 'abcdefghijklmnop'.
	self assert: (plat trimString: string for: type) equals: (string copyFrom: 1 to: string size -1).
	string := self addToString: 'abcdefghijklmnopq'.
	self assert: (plat trimString: string for: type) equals: (string copyFrom: 1 to: string size -1).
	string := (String new: 100000) atAllPut: $a.
	self assert: (plat trimString: string for: type) equals: 'aaaaaaaaaaaaaaaaaaaa'
]

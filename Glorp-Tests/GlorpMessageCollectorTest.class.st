Class {
	#name : #GlorpMessageCollectorTest,
	#superclass : #GlorpTestCase,
	#instVars : [
		'collector'
	],
	#category : 'Glorp-Tests-Tests'
}

{ #category : #tests }
GlorpMessageCollectorTest >> messageCollectorDNUObjectStudio [
	| caught |
	caught := false.
	[collector basicDoesNotUnderstand: #foo args: #()] on: MessageNotUnderstood
		do: [:signal | caught := true. signal sunitExitWith: nil].
	self assert: caught
]

{ #category : #support }
GlorpMessageCollectorTest >> setUp [
	super setUp.
	collector := MessageArchiver new
]

{ #category : #tests }
GlorpMessageCollectorTest >> testExpressionCreation [
	| exp |
	exp := collector foo asGlorpExpression.
	self assert: exp name == #foo.
	self assert: exp base class == BaseExpression
]

{ #category : #tests }
GlorpMessageCollectorTest >> testMessageCollectorDNU [
	| message caught |
	message := Message selector: #foo arguments: #().
	caught := false.
	[collector basicDoesNotUnderstand: message] on: MessageNotUnderstood
		do: [:signal | caught := true. signal sunitExitWith: nil].
	self assert: caught
]

{ #category : #tests }
GlorpMessageCollectorTest >> testMessageIntercept [

	| foo |
	foo := collector foo.
	self assert: foo privateGlorpSelector == #foo.
	self assert: foo privateGlorpReceiver == collector.
]

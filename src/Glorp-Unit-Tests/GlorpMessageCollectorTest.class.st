Class {
	#name : #GlorpMessageCollectorTest,
	#superclass : #GlorpTestCase,
	#instVars : [
		'collector'
	],
	#category : #'Glorp-Unit-Tests-Tests'
}

{ #category : #tests }
GlorpMessageCollectorTest >> messageCollectorDNUObjectStudio [
	| caught |
	caught := false.
	[collector basicDoesNotUnderstand: #foo args: #()] on: MessageNotUnderstood
		do: [:signal | caught := true. signal sunitExitWith: nil].
	self assert: caught
]

{ #category : #running }
GlorpMessageCollectorTest >> setUp [

	super setUp.
	collector := MessageArchiver new
]

{ #category : #tests }
GlorpMessageCollectorTest >> testExpressionCreation [

	| exp |
	exp := collector foo asGlorpExpression.
	self assert: exp name identicalTo: #foo.
	self assert: exp base class identicalTo: BaseExpression
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
	self assert: foo privateGlorpSelector identicalTo: #foo.
	self assert: foo privateGlorpReceiver identicalTo: collector
]

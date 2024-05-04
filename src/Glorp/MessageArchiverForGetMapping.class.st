"
This is a special subclass of MessageArchiver which constructs its expression using getMapping:named: rather than just get:. It's possible it ought to be generalized to one that's parameterized by what message it sends, but right now I only need the one...

"
Class {
	#name : 'MessageArchiverForGetMapping',
	#superclass : 'MessageArchiver',
	#category : 'Glorp-Queries',
	#package : 'Glorp',
	#tag : 'Queries'
}

{ #category : 'expression creation' }
MessageArchiverForGetMapping >> sendMessageTo: anExpression withArguments: arguments [
	"Send our own particular message. Note that our arguments will have been wrapped as constant expressions, and we don't want that, so unwrap them"
	^anExpression getMapping: arguments first value named: (arguments at: 2) value
]

Extension { #name : #CachePolicy }

{ #category : #'*Glorp' }
CachePolicy classSide >> default [
	"Use of the WeakVWCache is tied in with Ephemera which we do not expect to get working in VW3."

	^self new
]

{ #category : #'*Glorp' }
CachePolicy classSide >> new [

	^super new initialize.
]

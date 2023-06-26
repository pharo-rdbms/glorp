Extension { #name : #CachePolicy }

{ #category : #'*Glorp' }
CachePolicy class >> default [
	"Use of the WeakVWCache is tied in with Ephemera which we do not expect to get working in VW3."

	^ self new
]

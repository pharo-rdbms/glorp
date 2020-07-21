Extension { #name : #Collection }

{ #category : #'*Glorp-Unit-Tests' }
Collection >> assertEqual: aCollection [
	"A convenience method for testing"
	self asSortedCollection with: aCollection asSortedCollection do: [:a :b |
		a assertEqual: b].
]

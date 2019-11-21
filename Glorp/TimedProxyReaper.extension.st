Extension { #name : #TimedProxyReaper }

{ #category : #'*Glorp' }
TimedProxyReaper classSide >> delay: seconds [
	^self new delay: seconds
]

{ #category : #'*Glorp' }
TimedProxyReaper classSide >> delay: seconds maximumWork: milliseconds [
	^self new delay: seconds; maximumWork: milliseconds
]

{ #category : #'*Glorp' }
TimedProxyReaper classSide >> new [
	^super new initialize
]

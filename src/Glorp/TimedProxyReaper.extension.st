Extension { #name : 'TimedProxyReaper' }

{ #category : '*Glorp' }
TimedProxyReaper class >> delay: seconds [

	^ self new delay: seconds
]

{ #category : '*Glorp' }
TimedProxyReaper class >> delay: seconds maximumWork: milliseconds [

	^ self new
		  delay: seconds;
		  maximumWork: milliseconds
]

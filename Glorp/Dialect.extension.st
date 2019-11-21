Extension { #name : #Dialect }

{ #category : #'*Glorp' }
Dialect classSide >> dialectName [

	dialectName isNil ifTrue: [self determineDialect.].
	^ dialectName
]

{ #category : #'*Glorp' }
Dialect classSide >> dialectVersion [
	"Glorp does not need to consult dialect versions at the moment.  This method is currently made available purely as a precaution, in case Glorp experimenters should wish to add a dialect-version-requiring feature."

	^self dialectName, SystemVersion current imageVersionString
]

{ #category : #'*Glorp' }
Dialect classSide >> error [

	^Error
]

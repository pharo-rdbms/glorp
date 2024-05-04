Extension { #name : 'SQLStringSelectCommand' }

{ #category : '*Glorp' }
SQLStringSelectCommand class >> sqlString: aString parameters: aDictionaryOrArray useBinding: aBoolean session: aSession [

	^ self new
		  setSQLString: aString;
		  parameters: aDictionaryOrArray;
		  useBinding: aBoolean;
		  session: aSession
]

Extension { #name : 'SelectCommand' }

{ #category : '*Glorp' }
SelectCommand class >> forQuery: aQuery parameters: aDictionary [

	^ self new
		  query: aQuery;
		  parameters: aDictionary;
		  yourself
]

{ #category : '*Glorp' }
SelectCommand class >> forQuery: aQuery parameters: aDictionary useBinding: aBoolean session: aSession [

	^ self new
		  query: aQuery;
		  parameters: aDictionary;
		  useBinding: aBoolean;
		  session: aSession;
		  yourself
]

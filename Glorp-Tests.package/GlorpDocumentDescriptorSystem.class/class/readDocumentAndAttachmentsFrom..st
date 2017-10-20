as yet unclassified
readDocumentAndAttachmentsFrom: glorpSession 
	| doc |
	doc := glorpSession readOneOf: GlorpDocument.
	Transcript
		cr;
		nextPutAll: '---> Read document ' , doc id printString;
		cr.
	doc attachments do: 
			[:att | 
			Transcript
				cr;
				nextPutAll: '------> Attachment ' , att index printString , ' ' 
							, att mimeType;
				cr].
	^doc
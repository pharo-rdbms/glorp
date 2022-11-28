"
This is a test descriptor system for documents with attachments that have their attachment bytes in a separate table, so reading them can be deferred. Neither attachments nor attachmentBytes have references to their containing document, but do have primary keys as foreign keys to it. When writing, this exhibited a problem that if you didn't read the bytes, then the attachment was written properly, because it could get its documentId primary key component from the proxy to the attachmentBytes. But if you had read the attachmentBytes, then it tried to get the value from the attachmentBytes object, which didn't know about that value. So it couldn't find the primary key of the attachment, and therefore assumed it was new.
"
Class {
	#name : #GlorpDocumentDescriptorSystem,
	#superclass : #GlorpTestDescriptorSystem,
	#category : #'Glorp-Unit-Tests-Models'
}

{ #category : #'as yet unclassified' }
GlorpDocumentDescriptorSystem class >> doTest [
	"   AADescriptor doTest    "

	| glorpSession doc |
	glorpSession := self connectToDatabase.

	"Try #1 -- this works as advertized"
	doc := self readDocumentAndAttachmentsFrom: glorpSession.
	"Something changed? Should not."
	glorpSession modify: doc in: [].
	doc := nil.
	glorpSession accessor logout.
	glorpSession := self connectToDatabase.

	"Try #2 -- this makes Glorp believe the attachment was changed"
	doc := self readDocumentAndAttachmentsFrom: glorpSession.
	doc attachments do: 
			[:ea | 
			"Force attachmentBytes to be instanciated"
			Transcript nextPutAll: '----> ', ea attachmentBytes content; cr].
	"Something changed? Should not, but does."
	"Glorp now tries to update the attachment AND save the attachmentBytes again. Boom"
	glorpSession modify: doc in: [].
	glorpSession accessor logout
]

{ #category : #'as yet unclassified' }
GlorpDocumentDescriptorSystem class >> readDocumentAndAttachmentsFrom: glorpSession [ 
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
]

{ #category : #glorp }
GlorpDocumentDescriptorSystem >> allTableNames [
	^#('document' 'attachment' 'attachmentbytes')
]

{ #category : #glorp }
GlorpDocumentDescriptorSystem >> constructAllClasses [
	^(super constructAllClasses)
		add: GlorpDocument;
		add: GlorpAttachment;
		add: GlorpAttachmentBytes;
		yourself
]

{ #category : #glorp }
GlorpDocumentDescriptorSystem >> tableForATTACHMENT: aTable [ 
	| d |
	d := (aTable createFieldNamed: 'document_id' type: platform int4) 
				bePrimaryKey.
	(aTable createFieldNamed: 'indexInDocument' type: platform int) bePrimaryKey.
	aTable createFieldNamed: 'mimetype' type: (platform varchar: 32).

	"FK Constraints"
	aTable addForeignKeyFrom: d
		to: ((self tableNamed: 'document') fieldNamed: 'id')
]

{ #category : #glorp }
GlorpDocumentDescriptorSystem >> tableForATTACHMENTBYTES: aTable [ 
	| d i |
	d := (aTable createFieldNamed: 'attachment_document_id'
				type: platform int4) bePrimaryKey.
	i := (aTable createFieldNamed: 'attachment_index' type: platform int) 
				bePrimaryKey.
	aTable createFieldNamed: 'content' type: platform text.

	"FK"
	aTable 
		addForeignKeyFrom: d
		to: ((self tableNamed: 'attachment') fieldNamed: 'document_id')
		from: i
		to: ((self tableNamed: 'attachment') fieldNamed: 'indexInDocument')
]

{ #category : #glorp }
GlorpDocumentDescriptorSystem >> tableForDOCUMENT: aTable [ 
	(aTable createFieldNamed: 'id' type: platform sequence) bePrimaryKey.
	aTable createFieldNamed: 'whatever' type: (platform integer).
]

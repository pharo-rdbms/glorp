as yet unclassified
doTest
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
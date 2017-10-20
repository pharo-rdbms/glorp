tests
testUnchangedInUnitOfWork
 
	| doc |
	self createData.
	session reset.
	doc := session readOneOf: GlorpDocument.
	"Something changed? Should not."
	session modify: doc in: [].
	doc := nil.
	session reset.

	doc := session readOneOf: GlorpDocument.
	self assert: doc attachments size = 1.
	doc attachments do: 
			[:each | 
			self assert: each attachmentBytes content yourSelf notNil].
	"The bug would cause this to write out the attachment over again, generating a primary key constraint error. Just in case that doesn't catch it, do a count"
	session accessor permitNothingDuring: [
		session modify: doc in: []].
	self assert: (session count: GlorpDocument) = 1.
	self assert: (session count: GlorpAttachment) = 1.
	self assert: (session count: GlorpAttachmentBytes) = 1.
	self assert: doc id notNil.
	((session accessor executeSQLString: 'SELECT * FROM attachment') first asArray do: [:each | self assert: each notNil]).
	((session accessor executeSQLString: 'SELECT * FROM attachmentbytes') first asArray do: [:each | self assert: each notNil])
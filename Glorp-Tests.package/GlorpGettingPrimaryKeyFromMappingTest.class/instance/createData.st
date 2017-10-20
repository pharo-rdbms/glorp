tests
createData
	"Create seed data"
	| doc attb att |
	doc := GlorpDocument new initialize.
	attb := GlorpAttachmentBytes new content: 'Hello, Alan'.
	att := (GlorpAttachment new)
				index: 1;
				mimeType: 'text/plain';
				attachmentBytes: attb.
	session modify: doc in: [doc attachments add: att].
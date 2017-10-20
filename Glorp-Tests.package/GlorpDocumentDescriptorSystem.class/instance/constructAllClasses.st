glorp
constructAllClasses
	^(super constructAllClasses)
		add: GlorpDocument;
		add: GlorpAttachment;
		add: GlorpAttachmentBytes;
		yourself
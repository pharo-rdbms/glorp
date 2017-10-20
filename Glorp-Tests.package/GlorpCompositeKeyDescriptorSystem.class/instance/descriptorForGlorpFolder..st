descriptors
descriptorForGlorpFolder: aDescriptor

	| table userMapping messageMapping |
	table := self tableNamed: 'GR_FOLDER'.
	aDescriptor table: table.

	aDescriptor addMapping: (DirectMapping from: #name to: (table fieldNamed: 'NAME')).

	userMapping := OneToOneMapping new
		attributeName: #user;
		referenceClass: GlorpUser.
"		join: (Join from: (table fieldNamed: 'USER_ID') to: (userTable fieldNamed: 'ID'))."
	aDescriptor addMapping: userMapping.
	messageMapping := OneToManyMapping new
		attributeName: #messages;
		referenceClass: GlorpMessage.
"		join: (Join 
			from: (table fieldNamed: 'USER_ID')
			to: (messageTable fieldNamed: 'USER_ID') 	
			from: (table fieldNamed: 'NAME')
			to: (messageTable fieldNamed: 'FOLDER_NAME'))."
	messageMapping beExclusive.
	aDescriptor addMapping: messageMapping.
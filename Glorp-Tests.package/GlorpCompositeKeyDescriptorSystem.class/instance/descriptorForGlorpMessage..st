descriptors
descriptorForGlorpMessage: aDescriptor

	| table userMapping folderMapping |
	table := self tableNamed: 'GR_MESSAGE'.
	aDescriptor table: table.
	self tableNamed: 'GR_USER'.
	self tableNamed: 'GR_FOLDER'.

	aDescriptor addMapping: (DirectMapping from: #subject to: (table fieldNamed: 'SUBJECT')).
	aDescriptor addMapping: (DirectMapping from: #contents to: (table fieldNamed: 'CONTENTS')).

	userMapping := OneToOneMapping new
		attributeName: #user;
		referenceClass: GlorpUser.
"		mappingCriteria: (Join from: (table fieldNamed: 'USER_ID') to: (userTable fieldNamed: 'ID'))."
	aDescriptor addMapping: userMapping.
	folderMapping := OneToOneMapping new
		attributeName: #folder;
		referenceClass: GlorpFolder.
	"Let it figure this out for itself"
"		mappingCriteria: (Join 
			from: (table fieldNamed: 'USER_ID')
			to: (userTable fieldNamed: 'ID') 	
			from: (table fieldNamed: 'NAME')
			to: (folderTable fieldNamed: 'FOLDER_NAME'))."
	aDescriptor addMapping: folderMapping.
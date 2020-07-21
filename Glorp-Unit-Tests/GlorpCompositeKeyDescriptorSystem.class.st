"
This is a system designed to test the use of composite keys. Its model is an email message system, where we have users, folders, keyed by name and owning user, and messages, keyed by a message id, folder name, and owning user.
"
Class {
	#name : #GlorpCompositeKeyDescriptorSystem,
	#superclass : #GlorpTestDescriptorSystem,
	#category : #'Glorp-Unit-Tests-Models'
}

{ #category : #accessing }
GlorpCompositeKeyDescriptorSystem >> allTableNames [
	^#('GR_USER' 'GR_FOLDER' 'GR_MESSAGE').
]

{ #category : #accessing }
GlorpCompositeKeyDescriptorSystem >> constructAllClasses [
	^(super constructAllClasses)
		add: GlorpUser;
		add: GlorpFolder;
		add: GlorpMessage;
		yourself
]

{ #category : #descriptors }
GlorpCompositeKeyDescriptorSystem >> descriptorForGlorpFolder: aDescriptor [

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
]

{ #category : #descriptors }
GlorpCompositeKeyDescriptorSystem >> descriptorForGlorpMessage: aDescriptor [

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
]

{ #category : #descriptors }
GlorpCompositeKeyDescriptorSystem >> descriptorForGlorpUser: aDescriptor [

	| table folderMapping |
	table := self tableNamed: 'GR_USER'.
	aDescriptor table: table.

	aDescriptor addMapping: (DirectMapping from: #id to: (table fieldNamed: 'ID')).
	aDescriptor addMapping: (DirectMapping from: #name to: (table fieldNamed: 'NAME')).

	folderMapping := OneToManyMapping new
		attributeName: #folders;
		referenceClass: GlorpFolder.
"		mappingCriteria: 
						(Join
								from: (table fieldNamed: 'ID')
								to: (folderTable fieldNamed: 'USER_ID'))."
	folderMapping beExclusive.
	aDescriptor addMapping: folderMapping.
]

{ #category : #examples }
GlorpCompositeKeyDescriptorSystem >> example1 [
	| user1 user2 folder1 folder1a folder2 message1 message2 message3 |
	user1 := GlorpUser new id: 1; name: 'User One'.
	user2 := GlorpUser new id: 2; name: 'User Two'.
	folder1 := GlorpFolder new name: 'One'; user: user1.
	user1 folders add: folder1.
	folder1a := GlorpFolder new name: 'One-A'; user: user1.
	user1 folders add: folder1a.
	folder2 := GlorpFolder new name: 'Two'; user: user2.
	user2 folders add: folder2.
	
	message1 := GlorpMessage new subject: 'goes in folder 1'; user: user1; folder: folder1.
	folder1 messages add: message1.
	message2 := GlorpMessage new subject: 'also goes in folder 1'; user: user1; folder: folder1.
	folder1 messages add: message2.
	message3 := GlorpMessage new subject: 'goes in folder 2'; user: user2; folder: folder2.
	folder2 messages add: message3.
	^Array with: user1 with: user2.
]

{ #category : #tables }
GlorpCompositeKeyDescriptorSystem >> tableForGR_FOLDER: aTable [ 
	| userId |
	userId := aTable createFieldNamed: 'USER_ID' type: platform integer.
	userId bePrimaryKey.
	aTable addForeignKeyFrom: userId
		to: ((self tableNamed: 'GR_USER') fieldNamed: 'ID').
	(aTable createFieldNamed: 'NAME' type: (platform varChar: 50)) bePrimaryKey.
]

{ #category : #tables }
GlorpCompositeKeyDescriptorSystem >> tableForGR_MESSAGE: aTable [ 
	| userId folderName |
	userId := aTable createFieldNamed: 'USER_ID' type: platform integer.
	userId bePrimaryKey.
	folderName := aTable createFieldNamed: 'FOLDER_NAME' type: (platform varChar: 50).
	folderName bePrimaryKey.
	aTable addForeignKeyFrom: userId
		to: ((self tableNamed: 'GR_USER') fieldNamed: 'ID').

	aTable addForeignKeyFrom: userId
		to: ((self tableNamed: 'GR_FOLDER') fieldNamed: 'USER_ID')
		from: folderName
		to: ((self tableNamed: 'GR_FOLDER') fieldNamed: 'NAME').


	(aTable createFieldNamed: 'SUBJECT' type: (platform varChar: 50)) bePrimaryKey.
	aTable createFieldNamed: 'CONTENTS' type: (platform varChar: 100).
]

{ #category : #tables }
GlorpCompositeKeyDescriptorSystem >> tableForGR_USER: aTable [ 
	| |
	(aTable createFieldNamed: 'ID' type: platform integer)
		bePrimaryKey.
	aTable createFieldNamed: 'NAME' type: (platform varChar: 50).
]

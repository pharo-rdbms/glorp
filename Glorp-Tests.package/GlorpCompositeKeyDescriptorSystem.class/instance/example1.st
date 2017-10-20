examples
example1
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
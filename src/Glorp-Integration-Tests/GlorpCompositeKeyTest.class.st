Class {
	#name : #GlorpCompositeKeyTest,
	#superclass : #GlorpSessionBasedTest,
	#category : #'Glorp-Integration-Tests-Database'
}

{ #category : #setup }
GlorpCompositeKeyTest >> setUp [
	super setUp.
	system := (GlorpCompositeKeyDescriptorSystem forPlatform: session platform).
	session system: system.
	session beginTransaction.
	session transact: [session register: system example1].
	session reset.
]

{ #category : #setup }
GlorpCompositeKeyTest >> tearDown [
	session rollbackTransaction.
	session resetPermissions.
	super tearDown.
]

{ #category : #'tests- basic reading' }
GlorpCompositeKeyTest >> testAlsoFetch [
	| users |
	users := session read: GlorpUser.
]

{ #category : #'tests- basic reading' }
GlorpCompositeKeyTest >> testBasicReadFolder [
	| folders |
	folders := (session read: GlorpFolder) asSortedCollection: [:a :b | a name <= b name].
	self assert: folders size = 3.
	self assert: folders first name = 'One'.
	self assert: folders last name = 'Two'.
]

{ #category : #'tests- basic reading' }
GlorpCompositeKeyTest >> testBasicReadMessage [
	| messages |
	messages := (session read: GlorpMessage) asSortedCollection: [:a :b | a subject <= b subject].
	self assert: messages size = 3.
	self assert: messages first subject = 'also goes in folder 1'.
	self assert: (messages at: 2) subject = 'goes in folder 1'.
	self assert: messages last subject = 'goes in folder 2'.
]

{ #category : #'tests- basic reading' }
GlorpCompositeKeyTest >> testBasicReadUser [
	| users |
	users := (session read: GlorpUser) asSortedCollection: [:a :b | a id <= b id].
	self assert: users size = 2.
	self assert: users first name = 'User One'.
	self assert: users last name = 'User Two'.
]

{ #category : #'tests- basic reading' }
GlorpCompositeKeyTest >> testFaulting [
	| users user1 sortedFolders user2 |
	users := session read: GlorpUser.
	user1 := users detect: [:each | each id = 1].
	self assert: user1 folders size = 2.
	sortedFolders := user1 folders asSortedCollection: [:a :b | a name < b name].
	self assert: sortedFolders first name = 'One'.
	user2 := users detect: [:each | each id = 2].
	self assert: user2 folders first messages first subject = 'goes in folder 2'.
]

{ #category : #'tests- basic reading' }
GlorpCompositeKeyTest >> testFolderIdentity [
	| folders |
	folders := session read: GlorpFolder.
	folders do: [:each | | individualFolders individualFolder otherIndividualFolder|
		individualFolders := session read: GlorpFolder where: [:eachFolder | eachFolder = each].
		self assert: individualFolders size = 1.
		individualFolder := individualFolders first.
		otherIndividualFolder := session readOneOf: GlorpFolder where: [:eachFolder | eachFolder = each].
		self assert: individualFolder == each.
		self assert: otherIndividualFolder == individualFolder].
]

{ #category : #'tests- basic reading' }
GlorpCompositeKeyTest >> testMessageCacheHit [

	| messages |
	messages := session read: GlorpMessage.
	messages do: [ :each |
		| individualMessages individualMessage otherIndividualMessage |
		individualMessages := session
			                      read: GlorpMessage
			                      where: [ :eachMessage | eachMessage = each ].
		self assert: individualMessages size equals: 1.
		individualMessage := individualMessages first.
		session accessor denyReads.
		otherIndividualMessage := session
			                          readOneOf: GlorpMessage
			                          where: [ :eachMessage |
			                          eachMessage = each ].
		session accessor resetPermissions.
		self assert: individualMessage identicalTo: each.
		self assert: otherIndividualMessage identicalTo: individualMessage ]
]

{ #category : #'tests- basic reading' }
GlorpCompositeKeyTest >> testMessageIdentity [
	| messages |
	messages := session read: GlorpMessage.
	messages do: [:each | | individualMessages individualMessage otherIndividualMessage|
		individualMessages := session read: GlorpMessage where: [:eachMessage | eachMessage = each].
		self assert: individualMessages size = 1.
		individualMessage := individualMessages first.
		otherIndividualMessage := session readOneOf: GlorpMessage where: [:eachMessage | eachMessage = each].
		self assert: individualMessage == each.
		self assert: otherIndividualMessage == individualMessage].
]

{ #category : #'tests- basic reading' }
GlorpCompositeKeyTest >> testReadWithCacheHitFromExpression [
	| message |
	session reset.
	message := session readOneOf: GlorpMessage where: [:each | each subject = 'goes in folder 1'].
	self assert: message folder name = 'One'.
	session accessor permitNothing.
	session readOneOf: GlorpFolder where: [:each | each user id = 1 & (each name = 'One')].
]

{ #category : #'tests- basic reading' }
GlorpCompositeKeyTest >> testReadWithCacheHitFromJoin [
	| message |
	session reset.
	message := session readOneOf: GlorpMessage where: [:each | each subject = 'goes in folder 1'].
	session readOneOf: GlorpFolder where: [:each | each user id = 1 & (each name = 'One')].
	session accessor permitNothing.
	self assert: message folder name = 'One'.
]

{ #category : #'tests- basic reading' }
GlorpCompositeKeyTest >> testReadWithCacheHitFromParameterizedExpression [
	| message query |
	session reset.
	message := session readOneOf: GlorpMessage where: [:each | each subject = 'goes in folder 1'].
	self assert: message folder name = 'One'.
	session accessor permitNothing.
	query := Query readOneOf: GlorpFolder where: [:each | each user id = (each parameter: 1)  & (each name = (each parameter: 2))].
	query executeWithParameters: #(1 'One') in: session.
]

{ #category : #'tests- basic reading' }
GlorpCompositeKeyTest >> testReadWithJoins [
	| users |
	users := session read: GlorpUser where: [:each | each folders anySatisfyJoin: [:eachFolder |
		eachFolder messages anySatisfyJoin: [:eachMessage | eachMessage subject = 'goes in folder 1']]].
	self assert: users size = 1.
	self assert: users first id = 1.
]

{ #category : #'tests- basic reading' }
GlorpCompositeKeyTest >> testReadWithSubselect [
	| users |
	users := session read: GlorpUser where: [:each | each folders anySatisfyExists: [:eachFolder |
		eachFolder messages anySatisfyExists: [:eachMessage | eachMessage subject = 'goes in folder 1']]].
	self assert: users size = 1.
	self assert: users first id = 1.
]

{ #category : #'tests- basic reading' }
GlorpCompositeKeyTest >> testReadWithSubselectAndINClause [
	| users |
	self should: [
		users := session read: GlorpUser where: [:each | 
			each folders anySatisfyExists: [:eachFolder |
				| q |
				q := Query read: GlorpFolder.
				eachFolder in: q]]]
		raise: GlorpInvalidExpressionError.
]

{ #category : #'tests- basic reading' }
GlorpCompositeKeyTest >> testUserIdentity [
	| users |
	users := session read: GlorpUser.
	users
		do:
			[:each | 
			| individualUser otherIndividualUser individualUsers |
			individualUsers := session
				read: GlorpUser
				where: [:eachIndividual | eachIndividual id = each id].
			self assert: individualUsers size = 1.
			individualUser := individualUsers first.
			otherIndividualUser := session
				readOneOf: GlorpUser
				where: [:eachIndividual | eachIndividual id = each id].
			self assert: individualUser == each.
			self assert: otherIndividualUser == individualUser].
]

{ #category : #'tests- basic reading' }
GlorpCompositeKeyTest >> testUserIdentityViaMessage [
	| users |
	users := session read: GlorpUser.
	users
		do:
			[:each | 
			each folders
				do:
					[:eachFolder | 
					eachFolder messages
						do: [:eachMessage | 
							self assert: eachMessage folder yourSelf == eachFolder.
							self assert: eachMessage user yourSelf == each]]].
]

{ #category : #'tests- basic reading' }
GlorpCompositeKeyTest >> testUserIdentityViaMessageInUnitOfWork [
	session beginUnitOfWork.
	[self testUserIdentityViaMessage] ensure: [session rollbackUnitOfWork].
]

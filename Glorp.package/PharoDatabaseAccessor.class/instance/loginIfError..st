login
loginIfError: aBlock 
	self log: 'Login'.
	self databaseDriver: self connectionClass new.
	self
		execute: [
			self databaseDriver connect: currentLogin.
			currentLogin secure 
				ifTrue: [ currentLogin discardPassword ]
			]
		ifError: aBlock.
	self log: 'Login finished'
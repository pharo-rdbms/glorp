api/queries
undelete: anObject
	self undelete: anObject ifNotDeleted: [self error: 'Trying to undelete something that was not deleted'].
api/queries
deleteAllSatisfying: aQuery
	^aQuery deleteWithParameters: #() in: self.
accessing
= aLogin 
	^self class == aLogin class and: 
			[self name = aLogin name and: 
					[self database class = aLogin database class and: 
							[self username = aLogin username and: 
									[self connectString = aLogin connectString]]]]
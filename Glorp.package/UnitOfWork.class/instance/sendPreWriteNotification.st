private
sendPreWriteNotification
	self 
		registeredObjectsDo: [:eachObject | session sendPreWriteEventTo: eachObject]
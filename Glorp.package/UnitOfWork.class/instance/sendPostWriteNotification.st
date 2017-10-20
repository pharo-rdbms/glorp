private
sendPostWriteNotification
	self 
		registeredObjectsDo: [:eachObject | session sendPostWriteEventTo: eachObject]
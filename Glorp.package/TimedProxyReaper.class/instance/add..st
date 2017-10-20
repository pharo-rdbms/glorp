caching
add: aTimedProxy
	[mutex wait.
	self noWaitAdd: aTimedProxy] ensure: [mutex signal].
	self restartIfNecessary.
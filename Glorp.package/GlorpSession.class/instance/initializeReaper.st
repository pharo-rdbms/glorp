initialize
initializeReaper

	self releaseReaper.
	reaper := TimedProxyReaper new.
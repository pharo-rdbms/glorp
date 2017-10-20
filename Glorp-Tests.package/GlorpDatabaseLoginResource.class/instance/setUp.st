initialize/release
setUp
	Transcript show: self class name asString, ' setUp'; cr.
	super setUp.
	self login: self class defaultLogin.
	accessor := DatabaseAccessor forLogin: login.
	accessor login.
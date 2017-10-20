tests
testGroupWriting
	"Oracle does not group-write:  when binding, it says it does solely to take the code path that leads to array buinding.  We therefore do not test Oracle here."

	| platform |
	platform := PostgreSQLPlatform new.
	platform useBinding: false.
	self assertGroupWritingOnPlatform: platform.

	platform := SQLServerPlatform new.
	platform useBinding: false.
	self assertGroupWritingOnPlatform: platform.
	platform := SQLServerPlatform new.
	platform useBinding: true.
	self assertGroupWritingOnPlatform: platform.
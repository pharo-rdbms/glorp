"
A generator that puts Timestamp now into fields when it is invoked.
"
Class {
	#name : 'TimestampVersionGenerator',
	#superclass : 'VersionGenerator',
	#category : 'Glorp-Database',
	#package : 'Glorp',
	#tag : 'Database'
}

{ #category : 'sequencing' }
TimestampVersionGenerator >> nextValueFor: aField in: aRow [
	"If a platform maps the timestamp class to something else (e.g. SQLite maps timestamps to strings as it has no support for time-related types), then it must be allowed to do so here as well.  For most platforms, the wrapping #toTimestamp:for: call will be a noop."

	^ aField type platform
		  toTimestamp: Dialect timestampNow
		  for: aField type
]

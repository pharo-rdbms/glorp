mapping
createDeleteRowFor: anObject in: aRowMap
	"This is like firing the mapping, but instead of creating the data, we just need to check if there are link table entries, and if so, make sure they are deleted"
	| target mementoizedTarget|
	self canWrite ifFalse: [^self].
	self usesLinkTable ifFalse: [^self].
	target := self getValueFrom: anObject.
	target := self session realObjectFor: target ifNone: [^self].
	(self isValidTarget: target) ifTrue: [
		mementoizedTarget := aRowMap collectionMementoFor: target.
		self createDeleteRowForLinkFrom: anObject toTarget: mementoizedTarget in: aRowMap].
mapping
mapFromObject: anObject intoRowsIn: aRowMap 
	"Our target is a collection. The tricky bit is that if we're building rows into a RowMapForMementos, then the collection we contain isn't the one we want to use. We want the old version. Ask the row map to give it to us. If it's a normal row map, we'll just get the same thing back" 
	| target mementoizedTarget|
	self canWrite ifFalse: [^self].
	target := self getValueFrom: anObject.
	target := self session realObjectFor: target ifNone: [^self].
	(self isValidTarget: target) ifTrue: [
		mementoizedTarget := aRowMap collectionMementoFor: target.
		self mapFromObject: anObject toTarget: mementoizedTarget puttingRowsIn: aRowMap].
accessing
representativeMapping
	"At some points we may need to have this mapping behave some way without knowing yet which of its cases is satisfied. We assume that there is some basic level of similarity so that we can use one mapping as a representative to discover, e.g. what the reference class is. This works all right for cases where we have a mapping or a constant. It wouldn't work very well if we have a one to one mapping to one class in case (a) but a many-many to an entirely different class in the other"
	^cases first value
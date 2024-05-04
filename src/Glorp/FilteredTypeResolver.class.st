"
This is a type resolver for inheritance where all of the classes are represented in a single table, with some sort of identifying field for which subclass they are. The table would have the union of all possible fields for all classes. It's called filtering, because for any particular class, we filter out those instances from all those represented in the table.
"
Class {
	#name : 'FilteredTypeResolver',
	#superclass : 'BasicTypeResolver',
	#category : 'Glorp-Mappings',
	#package : 'Glorp',
	#tag : 'Mappings'
}

{ #category : 'instance creation' }
FilteredTypeResolver class >> forRootClass: aClass [
	^(self new)
		rootClass: aClass;
		yourself.
]

{ #category : 'accessing' }
FilteredTypeResolver >> allTablesFor: aDescriptor [
	"Return all tables used by this descriptor or its subclasses. Since all our subclasses use a single table, this is the same as for a normal descriptor."
	^aDescriptor tables
]

{ #category : 'type resolving' }
FilteredTypeResolver >> askConcreteMembersForConcreteClassFor: row withBuilder: builder [
	concreteMembers do: [:each |
		each describedConcreteClassFor: row withBuilder: builder]
]

{ #category : 'accessing' }
FilteredTypeResolver >> classesRequiringIndependentQueriesFor: aClass [
	^Array with: aClass
]

{ #category : 'type resolving' }
FilteredTypeResolver >> describedConcreteClassFor: row withBuilder: builder descriptor: aDescriptor [
	^aDescriptor typeMapping describedConcreteClassFor: row withBuilder: builder
]

{ #category : 'accessing' }
FilteredTypeResolver >> descriptorsRequiringIndependentQueriesFor: aClass [
	"A FilteredTypeResolver holds all its subclasses' data in a single table, so should never require independent queries;  thus the only descriptor is that for aClass, and this should never need to be called.
	It is possible that some fields in the table are only meaningful for some subclasses, and so are only defined in the descriptors of some subclasses.  If a query using the field is made (presumably by mistake) for a class without the mapping, #mappingFromMeOrSubclasses will call this method in a (vain) attempt to find defined for FilteredTypeResolver, thence return nil and so enable #mappingFromMeOrSubclasses to fall through to the normal error processing (as its last comment says).
	Therefore we define this method, although expecting it will only ever be called en route to an error."

	^members select: [:each | each describedClass = aClass]
]

{ #category : 'type resolving' }
FilteredTypeResolver >> fieldsForSelectStatement [
	"Return fields that are needed in a select statement - i.e. return all inherited fields that are part of the tables we are already selecting for this object, but not in the main descriptor"
	| fields rootFields |
	fields := OrderedCollection new.
	rootFields := self rootDescriptor mappedFields asSet.
	self concreteMembers do: [:each |
		each == self rootDescriptor ifFalse: [
			each mappedFields do: [:eachSubField |
				(rootFields includes: eachSubField) ifFalse: [
					fields add: eachSubField]]]].
	^fields
]

{ #category : 'type resolving' }
FilteredTypeResolver >> isAbstract: aDescriptor [
	^aDescriptor == self rootDescriptor
]

{ #category : 'registering' }
FilteredTypeResolver >> register: aDescriptor abstract: aBoolean [
	super register: aDescriptor abstract: aBoolean.
	aBoolean
		ifTrue:
			[| fakeTypeMapping |
			fakeTypeMapping := FilteredTypeMapping to: nil keyedBy: nil.
			fakeTypeMapping attribute name: #filteredTypeResolverFilterMapping.
			fakeTypeMapping readOnly: true.
			aDescriptor typeMapping: fakeTypeMapping]
]

{ #category : 'registering' }
FilteredTypeResolver >> register: aDescriptor keyedBy: aKey field: aField [
	self register: aDescriptor abstract: false.
	aDescriptor typeMapping: (FilteredTypeMapping to: aField keyedBy: aKey)
]

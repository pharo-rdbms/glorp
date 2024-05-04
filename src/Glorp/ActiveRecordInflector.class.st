"
I am an inflector that can convert words from singular to plural and back.

I work using regular expressions with a single capture expression.  Typically this means the capture expression should begin with a .* to capture arbitrary substrings.  The captured prefix is kept and the new suffix is added on.

For intance:

self addPluralRule: '(.*x|.*ch|.*ss|.*sh)$'  asRegexIgnoringCase replacement: 'es'.

Will match any phrase ending in x, ch, ss, or sh and append es to it.  

Uncountables are words that are same in plural or singular like 'sheep'.  You can add new uncountables with addUncountable:.

Irregulars are words that completely change form like person to people.  Adding an irregular adds a rule to both the plurals and the singulars rules.  As rules are applied from most recently added to oldest, the most general rules are added first and irregulars are added last.
"
Class {
	#name : 'ActiveRecordInflector',
	#superclass : 'Object',
	#instVars : [
		'uncountable',
		'singular',
		'plural',
		'prefix',
		'pluralizeTableNames',
		'prefixTableNames',
		'prefixClassKeys'
	],
	#category : 'Glorp-ActiveRecord',
	#package : 'Glorp',
	#tag : 'ActiveRecord'
}

{ #category : 'accessing' }
ActiveRecordInflector >> accessor: aString [

	^ (self camelize: aString capitalized: false) asSymbol
]

{ #category : 'adding' }
ActiveRecordInflector >> addIrregularSingular: asSingular plural: asPlural [

	self removeUncountable: asSingular.
	self removeUncountable: asPlural.

	self addPluralRule: '(.*)' , asSingular , '$' replacement: asPlural.
	self addSingularRule: '(.*)' , asPlural , '$' replacement: asSingular
]

{ #category : 'adding' }
ActiveRecordInflector >> addPluralRule: rule replacement: replacement [

	rule isString ifTrue: [ self removeUncountable: rule ].
	self removeUncountable: replacement.
	plural addFirst: (rule isString
			 ifTrue: [ rule asRegexIgnoringCase ]
			 ifFalse: [ rule ]) -> replacement
]

{ #category : 'adding' }
ActiveRecordInflector >> addSingularRule: rule replacement: replacement [

	rule isString ifTrue: [ self removeUncountable: rule ].
	self removeUncountable: replacement.
	singular addFirst: (rule isString
			 ifTrue: [ rule asRegexIgnoringCase ]
			 ifFalse: [ rule ]) -> replacement
]

{ #category : 'adding' }
ActiveRecordInflector >> addUncountable: aString [

	uncountable add: (self uncountableRegexFrom: aString)
]

{ #category : 'private' }
ActiveRecordInflector >> applyRules: rules to: aString [

	^ uncountable
		  detect: [ :ea | ea matches: aString ]
		  ifFound: [ :ea | aString ]
		  ifNone: [
			  rules
				  detect: [ :ea | ea key matches: aString ]
				  ifFound: [ :ea |
				  (ea key subexpression: ea key subexpressionCount) , ea value ]
				  ifNone: [ aString ] ]
]

{ #category : 'accessing' }
ActiveRecordInflector >> camelize: aString [

	| subs |
	subs := aString substrings: ':_- ,.'.
	^ subs size = 1
		  ifTrue: [ aString capitalized ]
		  ifFalse: [
		  (subs collect: [ :ea | ea asLowercase capitalized ]) joinUsing: '' ]
]

{ #category : 'accessing' }
ActiveRecordInflector >> camelize: aString capitalized: shouldCapitalize [

	^ shouldCapitalize
		  ifTrue: [ self camelize: aString ]
		  ifFalse: [ (self camelize: aString) uncapitalized ]
]

{ #category : 'accessing' }
ActiveRecordInflector >> classKey: aClass [

	^ self prefixClassKeys
		  ifTrue: [ aClass asString ]
		  ifFalse: [ self demodulize: aClass asString ]
]

{ #category : 'accessing' }
ActiveRecordInflector >> classify: aTableName [

	| name |
	name := aTableName.
	(self prefixTableNames and: [
		 name asLowercase beginsWith: prefix asLowercase , '_' ]) ifTrue: [
		name := name copyAfter: $_ ].
	self pluralizeTableNames ifTrue: [ name := self singularize: name ].
	^ self modulize: (self camelize: name)
]

{ #category : 'accessing' }
ActiveRecordInflector >> constantize: aString [

	^ self class environment at: aString asSymbol ifAbsent: [  ]
]

{ #category : 'accessing' }
ActiveRecordInflector >> demodulize: aString [

	^ (prefix notEmpty and: [ aString beginsWith: prefix ])
		  ifTrue: [ aString last: aString size - prefix size ]
		  ifFalse: [ aString ]
]

{ #category : 'accessing' }
ActiveRecordInflector >> foreignKey: aClassName [

	^ self prefixTableNames
		  ifTrue: [ (self tableize: aClassName) , '_id' copyAfter: $_ ]
		  ifFalse: [ (self tableize: aClassName) , '_id' ]
]

{ #category : 'initialization' }
ActiveRecordInflector >> initialize [

	super initialize.
	prefix := ''.
	prefixClassKeys := true.
	prefixTableNames := true.
	pluralizeTableNames := true.
	singular := OrderedCollection new.
	plural := OrderedCollection new.
	uncountable := OrderedCollection new.
	self initializePlural.
	self initializeSingular.
	self initializeIrregular.
	self initializeUncountable.
	^ self
]

{ #category : 'private - initialization' }
ActiveRecordInflector >> initializeIrregular [

	{
		('person' -> 'people').
		('man' -> 'men').
		('child' -> 'children').
		('sex' -> 'sexes').
		('move' -> 'moves').
		('zombie' -> 'zombies') } do: [ :assoc |
		self addIrregularSingular: assoc key plural: assoc value ].
	^ self
]

{ #category : 'private - initialization' }
ActiveRecordInflector >> initializePlural [
	"Rules based on Rails Inflector at https://github.com/rails/rails/blob/f33d52c95217212cbacc8d5e44b5a8e3cdc6f5b3/activesupport/lib/active_support/inflections.rb"

	self addPluralRule: '.*$' asRegexIgnoringCase replacement: 's'.
	self addPluralRule: '(.*x|.*ch|.*ss|.*sh)$'  asRegexIgnoringCase replacement: 'es'.
	self addPluralRule: '(^.*[^aeiou])y$'  asRegexIgnoringCase replacement: 'ies'.
	self addPluralRule: '(.*s)eries$' asRegexIgnoringCase replacement:  'eries'.
	self addPluralRule: '(.*matr|.*vert|.*ind)[ie]x$'  asRegexIgnoringCase replacement: 'ices'.
	self addPluralRule: '(.*)fe?$'  asRegexIgnoringCase replacement: 'ves'.
	self addPluralRule: '(.*ba|.*diagno|.*analy)sis$'  asRegexIgnoringCase replacement: 'ses'.
	self addPluralRule: '(.*[ti])um$'  asRegexIgnoringCase replacement: 'a'.
	self addPluralRule: '(.*quiz)$'  asRegexIgnoringCase replacement: 'zes'.
	self addPluralRule: '^(ox)$'  asRegexIgnoringCase replacement: 'en'.
	self addPluralRule: '(.*buffal|.*tomat)o$'  asRegexIgnoringCase replacement: 'oes'.
	self addPluralRule: '(.*bu)s$'  asRegexIgnoringCase replacement: 'ses'.
	self addPluralRule: '(.*alias|.*status)$'  asRegexIgnoringCase replacement: 'es'.
	self addPluralRule: '^(.*m|.*l)ouse$'  asRegexIgnoringCase replacement: 'ice'.
	self addPluralRule: '(.*octop|.*vir)us$'  asRegexIgnoringCase replacement: 'i'.
	self addPluralRule: '^(.*ax|.*test|.*bas|.*cris)is$'  asRegexIgnoringCase replacement: 'es'.

	^ self
]

{ #category : 'private - initialization' }
ActiveRecordInflector >> initializeSingular [

	self addSingularRule: '(.*)s$' asRegexIgnoringCase replacement:  ''.
	self addSingularRule: '(.*x|.*ch|.*ss|.*sh)es$' asRegexIgnoringCase replacement:  ''.
	self addSingularRule: '(.*[^aeiou])ies$'  asRegexIgnoringCase replacement: 'y'.
	self addSingularRule: '(.*s)eries$' asRegexIgnoringCase replacement:  'eries'.
	self addSingularRule: '(.*m)ovies$' asRegexIgnoringCase replacement:  'ovie'.
	self addSingularRule: '(.*vert|.*ind)ices$' asRegexIgnoringCase replacement:  'ex'.
	self addSingularRule: '(.*[^f])ves$' asRegexIgnoringCase replacement:  'fe'.
	self addSingularRule: '(.*hive)s$' asRegexIgnoringCase replacement:  ''.
	self addSingularRule: '(.*[lr])ves$' asRegexIgnoringCase replacement:  'f'.
	self addSingularRule: '(.*[md]ove|.*[lt]ive)s$' asRegexIgnoringCase replacement:  ''.
   self addSingularRule: '(.*analy|.*ba|.*diagno|.*parenthe|.*progno|.*synop|.*the)s[ie]s$' asRegexIgnoringCase replacement:  'sis'.
	self addSingularRule: '(.*[ti])a$' asRegexIgnoringCase replacement:  'um'.
	self addSingularRule: '(.*quiz)zes$' asRegexIgnoringCase replacement:  ''.
	self addSingularRule: '^(.*ox)en' asRegexIgnoringCase replacement:  ''.
	self addSingularRule: '(.*o)es$' asRegexIgnoringCase replacement:  ''.
	self addSingularRule: '(.*b|.*stat)uses$' asRegexIgnoringCase replacement:  'us'.
	self addSingularRule: '^(.*m|.*l)ice$' asRegexIgnoringCase replacement:  'ouse'.
	self addSingularRule: '(.*octop|.*vir)i$' asRegexIgnoringCase replacement:  'us'.
	self addSingularRule: '(.*alias)es$' asRegexIgnoringCase replacement:  ''.
	self addSingularRule: '(.*matr)ices$' asRegexIgnoringCase replacement:  'ix'.
	self addSingularRule: '(.*ax|.*test|.*cris)es$' asRegexIgnoringCase replacement:  'is'.
	self addSingularRule: '(.*shoe)s$' asRegexIgnoringCase replacement:  ''.
	self addSingularRule: '(database)s$' asRegexIgnoringCase replacement:  ''.
"   self addSingularRule: '(.*)ss$' asRegexIgnoringCase replacement:  ''.
   self addSingularRule: '(n)ews$' asRegexIgnoringCase replacement:  'ews'.
   self addSingularRule: '(.*[ti])a$' asRegexIgnoringCase replacement:  'um'.
   self addSingularRule: '(.*analy|.*ba|.*diagno|.*parenthe|.*progno|.*synop|.*the)s[ie]s$' asRegexIgnoringCase replacement:  'sis'.
   self addSingularRule: '(^analy)s[ie]s$' asRegexIgnoringCase replacement:  'sis'.
   self addSingularRule: '([^f])ves$' asRegexIgnoringCase replacement:  'fe'.
   self addSingularRule: '(hive)s$' asRegexIgnoringCase replacement:  ''.
   self addSingularRule: '(tive)s$' asRegexIgnoringCase replacement:  ''.
   self addSingularRule: '(.*[lr])ves$' asRegexIgnoringCase replacement:  'f'.
   self addSingularRule: '(.*[^aeiouy]|qu)ies$' asRegexIgnoringCase replacement:  'y'.
   self addSingularRule: '(s)eries$' asRegexIgnoringCase replacement:  'eries'.
   self addSingularRule: '(m)ovies$' asRegexIgnoringCase replacement:  'ovie'.

   self addSingularRule: '^(m|l)ice$' asRegexIgnoringCase replacement:  'ouse'.
   self addSingularRule: '(bus)(es)?$' asRegexIgnoringCase replacement:  ''.
   self addSingularRule: '(o)es$' asRegexIgnoringCase replacement:  ''.
   self addSingularRule: '(shoe)s$' asRegexIgnoringCase replacement:  ''.
   self addSingularRule: '(cris|test)(is|es)$' asRegexIgnoringCase replacement:  'is'.
   self addSingularRule: '^(a)x[ie]s$' asRegexIgnoringCase replacement:  'xis'.
   self addSingularRule: '(octop|vir)(us|i)$' asRegexIgnoringCase replacement:  'us'.
   self addSingularRule: '(alias|status)(es)?$' asRegexIgnoringCase replacement:  ''.
   self addSingularRule: '^(ox)en' asRegexIgnoringCase replacement:  ''.
   self addSingularRule: '(vert|ind)ices$' asRegexIgnoringCase replacement:  'ex'.
   self addSingularRule: '(matr)ices$' asRegexIgnoringCase replacement:  'ix'.
   self addSingularRule: '(quiz)zes$' asRegexIgnoringCase replacement:  ''.
   self addSingularRule: '(database)s$' asRegexIgnoringCase replacement:  ''."

	^self
]

{ #category : 'private - initialization' }
ActiveRecordInflector >> initializeUncountable [

	#('bison' 'bream' 'breeches' 'britches' 'carp' 'chassis' 'clippers' 'cod' 'contretemps' 'corps' 'debris' 'deer' 'diabetes' 'djinn' 'eland' 'elk' 'equipment' 'fish' 'flounder' 'gallows' 'graffiti' 'headquarters' 'herpes' 'high-jinks' 'homework' 'information' 'innings' 'itis' 'jackanapes' 'jeans' 'mackerel' 'measles' 'metadata' 'mews' 'money' 'mumps' 'news' 'ois' 'pincers' 'pliers' 'police' 'pox' 'proceedings' 'rabies' 'rice' 'salmon' 'scissors' 'sea-bass' 'shears' 'sheep' 'species' 'swine' 'trout' 'tuna' 'whiting' 'wildebeest') do: [ :ea | self addUncountable: ea ]
]

{ #category : 'accessing' }
ActiveRecordInflector >> modulize: aString [

	^ (prefix notEmpty and: [ aString beginsWith: prefix ])
		  ifTrue: [ aString ]
		  ifFalse: [ prefix , aString ]
]

{ #category : 'accessing' }
ActiveRecordInflector >> mutator: aString [

	^ ((self camelize: aString capitalized: false) , ':') asSymbol
]

{ #category : 'accessing' }
ActiveRecordInflector >> ordinal: anInteger [

	| integer |
	integer := anInteger asInteger abs.
	^ (integer \\ 100 between: 11 and: 13)
		  ifTrue: [ 'th' ]
		  ifFalse: [
		  #( 'st' 'nd' 'rd' ) at: integer \\ 10 ifAbsent: [ 'th' ] ]
]

{ #category : 'accessing' }
ActiveRecordInflector >> ordinalize: anInteger [

	^ anInteger asString , (self ordinal: anInteger)
]

{ #category : 'debugging' }
ActiveRecordInflector >> pluralMatch: aString [

	^ plural detect: [ :ea | ea key matches: aString ]
]

{ #category : 'accessing' }
ActiveRecordInflector >> pluralize: aString [

	^ self applyRules: plural to: aString
]

{ #category : 'configuration' }
ActiveRecordInflector >> pluralizeTableNames [

	^ pluralizeTableNames
]

{ #category : 'configuration' }
ActiveRecordInflector >> pluralizeTableNames: aBoolean [

	pluralizeTableNames := aBoolean
]

{ #category : 'configuration' }
ActiveRecordInflector >> prefix [

	^ prefix
]

{ #category : 'configuration' }
ActiveRecordInflector >> prefix: aString [

	prefix := aString ifNil: [ '' ] ifNotNil: [ aString asUppercase ]
]

{ #category : 'configuration' }
ActiveRecordInflector >> prefixClassKeys [

	^ prefix notEmpty and: [ prefixClassKeys ]
]

{ #category : 'configuration' }
ActiveRecordInflector >> prefixClassKeys: aBoolean [

	prefixClassKeys := aBoolean
]

{ #category : 'configuration' }
ActiveRecordInflector >> prefixTableNames [

	^ prefix notEmpty and: [ prefixTableNames ]
]

{ #category : 'configuration' }
ActiveRecordInflector >> prefixTableNames: aBoolean [

	prefixTableNames := aBoolean
]

{ #category : 'accessing' }
ActiveRecordInflector >> primaryKey: aClassName [

	^ 'id'
]

{ #category : 'adding' }
ActiveRecordInflector >> removeUncountable: aString [

	uncountable
		remove: (self uncountableRegexFrom: aString)
		ifAbsent: [  ]
]

{ #category : 'debugging' }
ActiveRecordInflector >> singularMatch: aString [

	^ singular detect: [ :ea | ea key matches: aString ]
]

{ #category : 'accessing' }
ActiveRecordInflector >> singularize: aString [

	^ self applyRules: singular to: aString
]

{ #category : 'accessing' }
ActiveRecordInflector >> tableize: aClassName [

	| name |
	name := self demodulize: aClassName.
	^ (self prefixTableNames
		   ifTrue: [ prefix asLowercase , '_' ]
		   ifFalse: [ '' ]) , (pluralizeTableNames
		   ifTrue: [ self pluralize: (self underscore: name) ]
		   ifFalse: [ self underscore: name ])
]

{ #category : 'adding' }
ActiveRecordInflector >> uncountableRegexFrom: aString [

	^ (String streamContents: [ :s |
		   s
			   nextPutAll: '.*\b';
			   nextPutAll: aString asLowercase;
			   nextPutAll: '$' ]) asRegexIgnoringCase
]

{ #category : 'accessing' }
ActiveRecordInflector >> underscore: aString [

	^ String streamContents: [ :s |
		  | in c first prev |
		  in := ReadStream on: aString.
		  c := in next.
		  first := true.
		  prev := nil.

		  [ c notNil ] whileTrue: [
			  c isUppercase ifTrue: [
				  (first not and: [ in atEnd not ]) ifTrue: [
					  (in peek isLowercase or: [ prev isLowercase ]) ifTrue: [
						  s nextPut: $_ ] ] ].

			  prev := c.
			  s nextPut: c asLowercase.
			  c := in next.
			  first := false ] ]
]

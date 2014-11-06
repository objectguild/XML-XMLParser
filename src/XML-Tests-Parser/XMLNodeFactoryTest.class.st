Class {
	#name : #XMLNodeFactoryTest,
	#superclass : #TestCase,
	#category : #'XML-Tests-Parser-Factories'
}

{ #category : #testing }
XMLNodeFactoryTest class >> shouldInheritSelectors [
	^ true
]

{ #category : #accessing }
XMLNodeFactoryTest >> cdataClass [
	^ XMLCData
]

{ #category : #accessing }
XMLNodeFactoryTest >> commentClass [
	^ XMLComment
]

{ #category : #accessing }
XMLNodeFactoryTest >> documentClass [
	^ XMLDocument
]

{ #category : #accessing }
XMLNodeFactoryTest >> elementClass [
	^ XMLElement
]

{ #category : #accessing }
XMLNodeFactoryTest >> factoryClass [
	^ XMLNodeFactory
]

{ #category : #'instance creation' }
XMLNodeFactoryTest >> newFactory [
	^ self factoryClass new
]

{ #category : #accessing }
XMLNodeFactoryTest >> piClass [
	^ XMLPI
]

{ #category : #'source XML' }
XMLNodeFactoryTest >> sampleUserXML [
	^
	XMLWriter new
		enablePrettyPrinting;
		writeWith: [:writer |
			writer pi
				target: 'xml-stylesheet';
				data: 'type="text/css" href="sample.css"'.
			writer comment: 'sample'.
			writer tag
				name: 'user:user';
				xmlnsAt: 'user' put: 'urn:user';
				with: [
					writer
						tag: 'user:username' with: 'jsmith';
						tag: 'user:real-name' with: 'John Smith';
						tag: 'user:date-registered' with: [writer cdata: DateAndTime now printString];
						tag: 'user:date-last-active' with: [writer cdata: DateAndTime now printString];
						tag: 'table-name' with: 'users';
						tag: 'row-id' with: '1000';
						tag: 'serializationFormat' with: 'XML']];
		contents
]

{ #category : #accessing }
XMLNodeFactoryTest >> stringClass [
	^ XMLString
]

{ #category : #tests }
XMLNodeFactoryTest >> testCDataCreation [
	| factory document cdata |

	factory := self newFactory.
	document := factory newDocument.
	cdata := document newCData: 'test'.
	self
		assert: cdata class == self cdataClass;
		assert: cdata string = 'test'.
]

{ #category : #tests }
XMLNodeFactoryTest >> testCommentCreation [
	| factory document comment |

	factory := self newFactory.
	document := factory newDocument.
	comment := document newComment: 'test'.
	self
		assert: comment class == self commentClass;
		assert: comment string = 'test'.
]

{ #category : #tests }
XMLNodeFactoryTest >> testDocumentCreation [
	| factory document newDocument |

	factory := self newFactory.
	document := factory newDocument.
	newDocument := document newDocument.
	self
		assert: newDocument class == self documentClass;
		assert: newDocument configuration == document configuration;
		assert: newDocument nodeFactory == factory.
]

{ #category : #tests }
XMLNodeFactoryTest >> testElementCreation [
	| factory document element |

	factory := self newFactory.
	document := factory newDocument.
	element := document newElement.
	self
		assert: element class == self elementClass;
		assert: element configuration == document configuration;
		assert: element nodeFactory == factory.

	element := element newElementNamed: 'test'.
	self
		assert: element class == self elementClass;
		assert: element configuration == document configuration;
		assert: element name = 'test';
		assert: element nodeFactory == factory.

	element := element newElementNamed: 'prefix:test' namespaceURI: 'prefixNS'.
	self
		assert: element class == self elementClass;
		assert: element configuration == document configuration;
		assert: element name = 'prefix:test';
		assert: element namespaceURI = 'prefixNS';
		assert: element nodeFactory == factory.
]

{ #category : #tests }
XMLNodeFactoryTest >> testPICreation [
	| factory document pi |

	factory := self newFactory.
	document := factory newDocument.
	pi := document newPI.
	self assert: pi class == self piClass.
]

{ #category : #tests }
XMLNodeFactoryTest >> testParsingSample [
	| document factory |

	factory := self newFactory.
	document :=
		(XMLDOMParser on: self sampleUserXML)
			nodeFactory: factory;
			preservesCDataNodes: true;
			preservesCommentNodes: true;
			parseDocument.
	self
		assert: document class == self documentClass;
		assert: document nodeFactory == factory.

	document allElementsDo: [:each |
		self
			assert: each class == self elementClass;
			assert: each nodeFactory == factory].

	document allNodesDo: [:each |
		each isStringNode
			ifTrue: [
				self assert:
					each class == 
						(each isCData
							ifTrue: [self cdataClass]
							ifFalse: [self stringClass])].
		each isComment
			ifTrue: [self assert: each class == self commentClass].
		each isPI
			ifTrue: [self assert: each class == self piClass]].
]

{ #category : #tests }
XMLNodeFactoryTest >> testStringCreation [
	| factory document string |

	factory := self newFactory.
	document := factory newDocument.
	string := document newString: 'test'.
	self
		assert: string class == self stringClass;
		assert: string string = 'test'.
]
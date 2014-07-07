suite 'app.Store', ->

  Store = app.Store
  store = null

  setup ->
    store = new Store 'test'

  suite 'constructor', ->
    test 'should set name', ->
      assert.equal store.name, 'test'

  suite 'toJson', ->
    test 'should throw error because method is abstract', ->
      assert.throw store.toJson

  suite 'fromJson', ->
    test 'should throw error because method is abstract', ->
      assert.throw store.fromJson

  suite 'instanceFromJson', ->
    test 'should create instance then mixin json', ->
      SomeClass = ->
      json = a: 'a', b: 'b'
      instance = store.instanceFromJson SomeClass, json
      assert.instanceOf instance, SomeClass
      assert.deepEqual instance, json

    test 'should return instance factory, useful for Array map', ->
      SomeClass = ->
      json = a: 'a', b: 'b'
      create = store.instanceFromJson SomeClass
      instance = create json
      instance2 = create json
      assert.notEqual instance, instance2
      assert.instanceOf instance, SomeClass
      assert.deepEqual instance, json
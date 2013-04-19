part of jester_test;

actor_tests() {

  group('-actor- should ', () {

    test('do stuff', () {
      var testPort = ReceivePortProxy.wrap(new ReceivePort());
      var sutPort = new ReceivePort();
      var mockActor = new MockActor(sutPort);

      expect(true, false, reason: 'do stuff');
    });
  });

}
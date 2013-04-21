part of jester_test;

actor_tests() {

  group('-actor- should', () {

    test('upgrade provided ReceviePort to SafeReceivePort if basic is provided', () {
      // Arrange
      ReceivePort receivePort = new ReceivePort();


      /*using(new ReceivePortProxy(), (ReceivePortProxy testPort) {
        using(new ReceivePortProxy(), (ReceivePortProxy sutPort) {

          var mockActor = new MockActor(sutPort.receivePort);

        });
      });*/


      //expect(true, false, reason: 'do stuff');
    });
  });

}
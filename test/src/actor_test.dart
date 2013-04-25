part of jester_test;

actor_tests() {

  group('-actor- should', () {

    test('emit events following command execution', () {
      // Arrange
      /*
      var stream = new JSink();
      var actorChannel = new JSink();
      Command command = Command.create(Actor.CLOSE_COMMAND, 'data');
      usingAsync(new MockActor(actorChannel), (MockActor actor) {
        actor.sendTo(stream)(command);
      });

      */

      //usingAsync(new MockActor(SafeReceivePort.create()), (Actor actor) {

        //actor.commandPort < (command, port);
      //});

      //receivePort.close();
      /*using(new ReceivePortProxy(), (ReceivePortProxy testPort) {
        using(new ReceivePortProxy(), (ReceivePortProxy sutPort) {

          var mockActor = new MockActor(sutPort.receivePort);

        });
      });*/


      //expect(true, false, reason: 'do stuff');
    });

    test('emit events following command execution', () {
      // Arrange
      /*Command command = Command.create(Actor.CONFIGURE_COMMAND, 'data');
      usingAsync(new SafeReceivePort(), (SafeReceivePort safePort) {


        Actor actor = new MockActor(safePort);

        //SendPort sendPort = safePort.toSendPort();

        //actor.send(command, to)
        // Act
        //sendPort.send('stuff', sendPort);

        return safePort.messages.first;

      }).then(expectAsync1((ReceivedMessage receivedMessage) {

        // Assert
        expect(command, isNotNull);
        expect(command.data, 'stuff');
      }));*/
    });
  });

}
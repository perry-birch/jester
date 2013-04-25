part of jester_test;

safe_receive_port_tests() {

  group('-safe_receive_port- should', () {

    // This is prety much just for demonstration
    test('wrap a receive port', () {
      // Arrange
     var recPort = new ReceivePort();

     // Act
     var safePort = new SafeReceivePort(recPort);

     // Assert
     expect(safePort, isNotNull);

     safePort.dispose();
    });

    // This is to prove the deficiency of built in ReceivePort
    // If the throw line is commented then the untrappable error shows up
    test('fail to receive a message without registering callback manually', () {
      // Arrange
      ReceivePort recPort = new ReceivePort();
      SendPort sendPort = recPort.toSendPort();
      bool caught = false;

      // Act
      // Sending to a ReceivePort without a registered receive
      // triggers an untrappable error
      try {
        throw('cannot proceed...');
        sendPort.send('stuff', sendPort);
      } catch(ex) {
        caught = true;
      } finally {
        recPort.close();
      }

      // Assert
      expect(caught, isTrue);
    });

    test('be able to receive a message without registering callback manually', () {
      // Arrange
      SafeReceivePort safePort = new SafeReceivePort();
      SendPort sendPort = safePort.toSendPort();

      // Act
      // Safeport adds a default receive callback
      sendPort.send('stuff', sendPort);

      // Assert

      safePort.dispose();
    });

    test('trigger stream event when message is received', () {
      // Arrange
      SafeReceivePort safePort = new SafeReceivePort();
      SendPort sendPort = safePort.toSendPort();
      ReceivedMessage message;

      // Attaches to the port and gets a future representing the first value emitted
      Future<ReceivedMessage> future = safePort.messages.first;

      // Act
      sendPort.send('stuff', sendPort);

      future.then(expectAsync1((ReceivedMessage receivedMessage) {
        message = receivedMessage;

        // Assert
        expect(message, isNotNull);
        expect(message.message.data, 'stuff');

        safePort.dispose();
      }));
    });

    test('trigger provided callback method if one has been provided', () {
      // Arrange
      SafeReceivePort safePort = new SafeReceivePort();
      SendPort sendPort = safePort.toSendPort();
      var message = null;
      safePort.receive((dynamic data, SendPort replyTo) {
        message = data;
      });

      // This is used to coordinate the expects below
      Future<ReceivedMessage> future = safePort.messages.first;

      // Act
      sendPort.send('stuff', sendPort);

      future.then(expectAsync1((ReceivedMessage receivedMessage) {
        // Assert
        expect(message, isNotNull);
        expect(message, 'stuff');

        safePort.dispose();
      }));
    });

    test('trigger provided callback method if one has been provided via using', () {
      // Arrange
      var message = null;
      usingAsync(new SafeReceivePort(), (SafeReceivePort safePort) {

        safePort.receive((dynamic data, SendPort replyTo) {
          message = data;
        });

        SendPort sendPort = safePort.toSendPort();

        // Act
        sendPort.send('stuff', sendPort);

        return safePort.messages.first;

      }).then(expectAsync1((ReceivedMessage receivedMessage) {

        // Assert
        expect(message, isNotNull);
        expect(message, 'stuff');

        // safePort.dispose() is omitted, using handles dispose
      }));
    });

    test('throw an exception if null callback is set', () {
      // Arrange
      SafeReceivePort safePort = new SafeReceivePort();
      var error = null;

      // Act
      try {
        safePort.receive(null);
      } catch(ex) {
        error = ex;
      }

      expect(error, isNotNull);

      safePort.dispose();
    });
  });
}
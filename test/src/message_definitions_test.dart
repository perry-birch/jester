part of jester_test;

isolate_boundary() {
  var expectedMessageType = new MessageTypes('SECRET', 'TYPE');
  port.receive((dynamic message, SendPort replyTo) {
    if(message is! Iterable<int>) {
      replyTo.send([false, 'invalid message type']);
      return;
    }
    try {
      var receivedMessageType = MessageTypes.fromUid(message);
      var equal = receivedMessageType == expectedMessageType;
      if(!equal) {
        replyTo.send([false, 'wrong message type, was ${receivedMessageType} but expected ${expectedMessageType}']);
        return;
      }
      replyTo.send([true]);
    } catch(ex) {
      replyTo.send([false, 'error ${ex}']);
    }
  });
}

message_definitions_tests() {

  group('-mesage_definitions:', () {

    group('message_types- should', () {

      test('be able to define a new MessageType', () {
        // Arrange
        var scope = 'TEST_SCOPE';
        var description = 'TEST_DESCRIPTION';

        // Act
        var messageType = new MessageTypes(scope, description);

        // Assert
        expect(messageType.scope, 'TEST_SCOPE');
        expect(messageType.key, 'TEST_DESCRIP'); // Limited to 12 chars length
      });

      test('instantiate a message type by a two int uid', () {
        // Arrange
        var uid = [1, 2];

        // Act
        var messageType = MessageTypes.fromUid(uid);

        // Assert
        expect(messageType.uid, uid);
        expect(messageType.scope, 'A');
        expect(messageType.key, 'B');
      });

      test('compare MessageType sucessfully within process', () {
        // Arrange
        var messageType1 = new MessageTypes('TEST_SCOPE', 'TEST_DESCRIPTION');
        var messageType2 = new MessageTypes('TEST_SCOPE', 'TEST_DESCRIPTION');

        // Act
        var equal = messageType1 == messageType2;

        // Assert
        expect(equal, true);
      });

      test('compare MessageType sucessfully across isolates', () {
        // Arrange
        usingAsync(new SafeReceivePort(), (recPort) {
          SendPort sendPort = spawnFunction(isolate_boundary);
          var messageType = new MessageTypes('SECRET', 'TYPE');
          recPort.receive((message, replyTo) {
            recPort.dispose(message);
          });

          // Act
          sendPort.send(messageType.uid, recPort.toSendPort());

          return recPort.disposed;
        })
        .then(expectAsync1((Iterable<int> result) {
          // Assert
          if(result == null) {
            expect(false, true, reason: 'result was null');
          }
          expect(result.first, true);
        }));
      });

      test('compare different MessageType sucessfully across isolates', () {
        // Arrange
        usingAsync(new SafeReceivePort(), (recPort) {
          SendPort sendPort = spawnFunction(isolate_boundary);
          var messageType = new MessageTypes('SECRET', 'WRONG');
          recPort.receive((message, replyTo) {
            recPort.dispose(message);
          });

          // Act
          sendPort.send(messageType.uid, recPort.toSendPort());

          return recPort.disposed;
        })
        .then(expectAsync1((Iterable<int> result) {
          if(result == null) {
            expect(false, true, reason: 'result was null');
          }
          expect(result.first, false);
        }));
      });

    });

    group('message- should', () {

      test('create a message that has provided values', () {
        // Arrange
        var messageType = new MessageTypes('A', 'B');
        var data = 'data';

        // Act
        var message = new Message(messageType, data);

        // Assert
        expect(message.type, messageType);
        expect(message.data, data);
      });

      test('serialize a message and deserialize it to an equatable version', () {
        // Arrange
        var messageType = new MessageTypes('A', 'B');
        var data = 'data';
        var message = new Message(messageType, data);

        // Act
        List serialized = message.serialize();
        Message de_serialized = Message.deserialize(serialized);

        // Assert
        expect(serialized.length, 2);
        expect(de_serialized.type, messageType);
        expect(de_serialized.data, data);
        expect(message, de_serialized);
      });

    });

    group('received_message- should', () {

      test('capture received message with proper message type if provided', () {
        // Arrange
        var commmandType = new CommandTypes('SCOPE', 'DESC');
        var message = new Command(commmandType, 'data');

        // Act
        var receivedMessage = new ReceivedMessage(message, null);

        // Assert
        expect(receivedMessage is ReceivedCommand, isTrue);
        expect(receivedMessage.message.type, commmandType);
      });

      test('wrap incoming messages with RAW_MESSAGE type for non MessageType', () {
        // Arrange
        var data = 'data';

        // Act
        ReceivedMessage receivedMessage = new ReceivedMessage(data, null);

        // Assert
        expect(receivedMessage is ReceivedMessage, isTrue);
        expect(receivedMessage.message.type, Message.RAW_MESSAGE);
        expect(receivedMessage.message.data, data);
      });

    });
  });

}
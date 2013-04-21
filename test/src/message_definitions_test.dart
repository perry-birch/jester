part of jester_test;

isolate_boundary() {
  port.receive((dynamic message, SendPort replyTo) {
    replyTo.send(message, replyTo);
  });
}

message_definitions_tests() {

  group('-mesage_definitions- should', () {

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

    test('default received message according to message type received', () {
    });

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
    });

    test('compare successfully across isolates', () {
      // Arrange

      /*using(new ReceivePortProxy(), (proxy) {


      // Act

      // Assert

      });*/

    });

  });

}
part of jester_test;

message_definitions_tests() {

  group('-mesage_definitions- should', () {

    test('be able to define a new MessageType', () {
      // Arrange
      var scope = 'TEST_SCOPE';
      var description = 'TEST_DESCRIPTION';

      // Act
      var messageType = new MessageTypes(scope, description);

      // Assert
      expect(messageType.scope, PackedInt.pack('TEST_SCOPE'));
      expect(messageType.key, PackedInt.pack('TEST_DESCRIPTION'));
    });

  });

}
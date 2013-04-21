part of jester_test;

safe_receive_port_tests() {

  group('-safe_receive_port- should', () {

    test('wrap a receive port', () {
      // Arrange
     var recPort = new ReceivePort();

     // Act
     var safePort = new SafeReceivePort(recPort);

     // Assert
     expect(safePort, isNotNull);

     safePort.dispose();
    });

    test('be able to receive a message without registering callback manually', () {
      // Arrange
      var recPort = new ReceivePort();
      SafeReceivePort safePort = new SafeReceivePort(recPort);

      //SendPort sender = new ReceivePort().toSendPort();

      // Act
      safePort.toSendPort().send('stuff', safePort.toSendPort());

      // Assert

      safePort.dispose();
    });
  });
}
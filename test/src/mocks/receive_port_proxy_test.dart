part of jester_test;

receive_port_proxy_tests() {

  group('-receive_port_proxy- should', () {

    test('wrap a receive port', () {
      // Arrange
      var proxy = ReceivePortProxy.wrap(new ReceivePort());
      ReceivePort sutPort = new ReceivePort(); // Isolate port

      var command = Message.create(Actor.CONFIGURE_COMMAND, 'data');

      var future = proxy.where((message) {
        return true;
      });

      sutPort.receive((Message message, SendPort replyTo) {
        replyTo.send(message, replyTo); // Echo back to the caller
      });

      // Act
      sutPort.toSendPort().send(command, proxy.sendPort);

      // Assert
      future.then(expectAsync1((Message message) {
        print('got message: ${message.type}');
        expect(message, null);
      }));
    });

  });
}
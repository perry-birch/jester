part of jester_test;

receive_port_proxy_tests() {

  group('-receive_port_proxy- should', () {

   /* test('wrap a receive port', () {
      // Arrange
      var outerCompleter = new Completer<IDisposable>();
      usingAsync(new SafeReceivePort(), (SafeReceivePort proxy) {
        var innerCompleter = new Completer<IDisposable>();

        usingAsync(new ReceivePortProxy(), (ReceivePortProxy sutPort) {

          var command = Message.create(Actor.CONFIGURE_COMMAND, 'data');


          Timer.run(() {
            innerCompleter.complete(sutPort);
            outerCompleter.complete(proxy);
          });

          return innerCompleter.future;
        });
        return outerCompleter.future;
      });

    });*/

  });
}

/*var future = proxy.where((message) {
return true; // Accept any message that comes through
});*/

/*sutPort.receivePort.receive((Message message, SendPort replyTo) {
replyTo.send(message, replyTo); // Echo back to the caller
});

// Act
sutPort.sendPort.send(command, proxy.sendPort);

// Assert
future.then(expectAsync1((Message message) {
expect(message.data, 'data');
innerCompleter.complete(sutPort);
outerCompleter.complete(proxy);
}));*/
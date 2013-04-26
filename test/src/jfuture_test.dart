part of jester_test;

jfuture_tests() {

  group('-jfuture- should', () {

    test('handle then as Future does', () {
      // Arrange
      Completer completer = new Completer();
      JFuture future = JFuture.$(completer.future);

      // Act
      completer.complete('data');

      future.then((value) {
        // Assert
        expect(value, 'data');
      })
      .then(expectAsync1((_) { }));
    });

    test('handle catchError as Future does', () {
      // Arrange
      Completer completer = new Completer();
      JFuture future = JFuture.$(completer.future);

      var errorFuture = future.catchError(((error) {
        return error;
      }), test: (e) => true);

      // Act
      completer.completeError('error');

      errorFuture.then((value) {
        // Assert
        expect(value, 'error');
      })
      .then(expectAsync1((_) { }));
    });

    test('call action after complete composing error, whenComplete and then using operators', () {
      // Arrange
      Completer completer = new Completer();
      JFuture future = JFuture.$(completer.future);
      bool called = false;

      // Assert
      future = future
          .catchError((error) => 'error:${error}')
          .whenComplete(() => called = true)
          .then((value) {
            expect(value, 'data');
            expect(called, true);
          })
          .then(expectAsync1((_) { }));

      // Act
      completer.complete('data');
    });

    test('call action after completeError composing error, whenComplete and then using operators', () {
      // Arrange
      Completer completer = new Completer();
      JFuture future = JFuture.$(completer.future);
      bool called = false;

      // Assert
      future = future
          .catchError((error) => 'error:${error}')
          .whenComplete(() => called = true)
          .then((value) {
            expect(value, 'error:error');
            expect(called, true);
          })
          .then(expectAsync1((_) { }));

      // Act
      completer.completeError('error');
    });

    test('call action after completeError composint error, whenComplete and then using exec', () {
      // Arrange
      Completer completer = new Completer();
      JFuture future = JFuture.$(completer.future);
      bool called = false;

      future = future
          .catchError((error) => 'error:${error}')
          .whenComplete(() => called = true)
          .then((value) {
              // Assert
              expect(value, 'error:error');
              expect(called, true);
            })
            .then(expectAsync1((_) { }));

      // Act
      completer.completeError('error');
    });
  });

}
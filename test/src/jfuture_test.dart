part of jester_test;

jfuture_tests() {

  group('-jfuture- should', () {

    test('handle then as Future does', () {
      // Arrange
      Completer completer = new Completer();
      JFuture future = JFuture.$(completer.future);

      // Act
      completer.complete('data');

      future.then(expectAsync1((value) {
        // Assert
        expect(value, 'data');
      }));
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

      errorFuture.then(expectAsync1((value) {
        // Assert
        expect(value, 'error');
      }));
    });

    test('', () {
      // Arrange
      Completer completer = new Completer();
      JFuture future = JFuture.$(completer.future);

      // Act
      completer.complete('data');

      //future | expectAsync1((value) {

      //});
    });

  });

}
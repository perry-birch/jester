part of jester_test;

disposable_tests() {

  group('-disposable-', () {

    test('not throw exception on dispose when no callback is provided', () {
      // Arrange
      IDisposable disposable = new Disposable();
      bool exceptionCaught = false;

      // Act
      try {
        disposable.dispose();
      } catch(ex) {
        exceptionCaught = true;
      }

      // Assert
      expect(exceptionCaught, false);
    });

    test('trigger callback when disposed', () {
      // Arrange
      bool disposed = false;
      IDisposable disposable = new Disposable(([_]) { disposed = true; });

      // Act
      disposable.dispose();

      // Assert
      expect(disposed, true);
    });

    test('only trigger dispose method at most once', () {
      // Arrange
      int disposedCount = 0;
      var callback = ([_]) { disposedCount++; };
      IDisposable disposable = new Disposable(callback);

      // Act
      disposable.dispose();
      disposable.dispose();
      disposable.dispose();

      // Assert
      expect(disposedCount, 1);
    });

    test('trigger mulitiple callbacks from CompositeDisposable', () {
      // Arrange
      int disposedCount = 0;
      var callback = ([_]) { disposedCount++; };
      IDisposable disposable1 = new Disposable(callback);
      IDisposable disposable2 = new Disposable(callback);
      IDisposable disposable3 = new Disposable(callback);

      IDisposable compositeDisposable = new CompositeDisposable.fromDisposables([
        disposable1,
        disposable2,
        disposable3]);

      // Act
      compositeDisposable.dispose();

      // Assert
      expect(disposedCount, 3);
    });

    test('immediately dispose items added to a CompositeDisposable that was already disposed', () {
      // Arrange
      int disposedCount = 0;
      var callback = ([_]) { disposedCount++; };
      IDisposable disposable = new Disposable(callback);

      CompositeDisposable compositeDisposable = new CompositeDisposable.empty();

      // Act
      compositeDisposable.dispose();
      expect(disposedCount, 0, reason: 'should not have been disposed yet');
      compositeDisposable.add(new Disposable(([_]) => disposedCount++));

      // Assert
      expect(disposedCount, 1, reason: 'should have been disposed without calling dispose on the composite');
    });

    test('dispose and remove an item from CopositeDisposable', () {
      // Arrange
      int disposedCount = 0;
      var callback = ([_]) { disposedCount++; };
      IDisposable disposable = new Disposable(callback);

      CompositeDisposable compositeDisposable = new CompositeDisposable.fromDisposables([disposable]);
      expect(disposedCount, 0, reason: 'should not have been disposed yet');

      // Act
      compositeDisposable.remove(disposable);

      // Assert
      expect(disposedCount, 1, reason: 'should not have been disposed yet');
    });

    test('dispose and remove all items from CompositeDisposable without triggering a dispose on the composite itself', () {
      // Arrange
      int disposedCount = 0;
      var callback = ([_]) { disposedCount++; };
      IDisposable disposable1 = new Disposable(callback);
      IDisposable disposable2 = new Disposable(callback);

      CompositeDisposable compositeDisposable = new CompositeDisposable.fromDisposables([disposable1]);

      expect(disposedCount, 0, reason: 'should not have been disposed yet');

      // Act
      compositeDisposable.clear();
      expect(disposedCount, 1, reason: 'should not have been disposed yet');

      compositeDisposable.add(disposable2);

      // Assert
      expect(disposedCount, 1, reason: 'should not have been disposed yet');
    });

    test('properly dispose items added to CompositeDisposable prior to it being disposed', () {
      // Arrange
      int disposedCount = 0;
      var callback = ([_]) { disposedCount++; };
      IDisposable disposable = new Disposable(callback);

      CompositeDisposable compositeDisposable = new CompositeDisposable.empty();

      // Act
      compositeDisposable.add(new Disposable(([_]) => disposedCount++));
      expect(disposedCount, 0, reason: 'should not have been disposed yet');

      compositeDisposable.dispose();

      // Assert
      expect(disposedCount, 1, reason: 'should have been disposed after the composite was');
    });

    test('trigger dispose when exiting using statement', () {
      // Arrange
      bool disposed = false;

      // Act
      using(new Disposable(([_]) => disposed = true), (disposable) {
        expect(disposed, false);
      });

      // Assert
      expect(disposed, true);
    });

    test('trigger dispose when exiting usingAsync statement', () {
      // Arrange
      bool disposed = false;

      // Act
      usingAsync(new Disposable(([_]) => disposed = true), (disposable) {
        expect(disposed, false, reason: 'should not have disposed inside the main method scope');

        return new Future.sync(() {
          expect(disposed, false, reason: 'should not have disposed before the returned Future has completed');
        });
      }).then(expectAsync1((_) {
        expect(disposed, true, reason: 'should have disposed after the Future completed');
      }));

      // Assert
      expect(disposed, false, reason: 'should not have disposed in the sync scope');
    });
  });

}
part of jester_test;

disposable_tests() {

  group('-disposable-', () {

    test('not throw exception on dispose when null callback is provided', () {
      // Arrange
      IDisposable disposable = Disposable.create(null);
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
      IDisposable disposable = Disposable.create(() => disposed = true);

      // Act
      disposable.dispose();

      // Assert
      expect(disposed, true);
    });

    test('only trigger dispose method at most once', () {
      // Arrange
      int disposedCount = 0;
      IDisposable disposable = Disposable.create(() => disposedCount++);

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
      IDisposable disposable1 = Disposable.create(() => disposedCount++);
      IDisposable disposable2 = Disposable.create(() => disposedCount++);
      IDisposable disposable3 = Disposable.create(() => disposedCount++);

      IDisposable compositeDisposable = CompositeDisposable.fromDisposables([
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
      IDisposable disposable = Disposable.create(() => disposedCount++);

      CompositeDisposable compositeDisposable = CompositeDisposable.empty();

      // Act
      compositeDisposable.dispose();
      expect(disposedCount, 0, reason: 'should not have been disposed yet');
      compositeDisposable.add(Disposable.create(() => disposedCount++));

      // Assert
      expect(disposedCount, 1, reason: 'should have been disposed without calling dispose on the composite');
    });

    test('dispose and remove an item from CopositeDisposable', () {
      // Arrange
      int disposedCount = 0;
      IDisposable disposable = Disposable.create(() => disposedCount++);

      CompositeDisposable compositeDisposable = CompositeDisposable.fromDisposables([disposable]);
      expect(disposedCount, 0, reason: 'should not have been disposed yet');

      // Act
      compositeDisposable.remove(disposable);

      // Assert
      expect(disposedCount, 1, reason: 'should not have been disposed yet');
    });

    test('dispose and remove all items from CompositeDisposable without triggering a dispose on the composite itself', () {
      // Arrange
      int disposedCount = 0;
      IDisposable disposable1 = Disposable.create(() => disposedCount++);
      IDisposable disposable2 = Disposable.create(() => disposedCount++);

      CompositeDisposable compositeDisposable = CompositeDisposable.fromDisposables([disposable1]);

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
      IDisposable disposable = Disposable.create(() => disposedCount++);

      CompositeDisposable compositeDisposable = CompositeDisposable.empty();

      // Act
      compositeDisposable.add(Disposable.create(() => disposedCount++));
      expect(disposedCount, 0, reason: 'should not have been disposed yet');

      compositeDisposable.dispose();

      // Assert
      expect(disposedCount, 1, reason: 'should have been disposed after the composite was');
    });

    test('trigger dispose when exiting using statement', () {
      // Arrange
      bool disposed = false;

      // Act
      using(Disposable.create(() => disposed = true), (disposable) {
        expect(disposed, false);
      });

      // Assert
      expect(disposed, true);
    });

    test('trigger dispose when exiting usingAsync statement', () {
      // Arrange
      bool disposed = false;

      // Act
      usingAsync(Disposable.create(() => disposed = true), (disposable) {
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
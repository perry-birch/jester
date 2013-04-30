part of jester_test;

sequence_tests() {

  group('-seq_subscription- should', () {

    /*
Awesome Go syntax
var c chan int
c = make(chan int)
c := make(chan int)

// Send
c <- 1

// Receive
value = <-c
     */
    test('patch observable values to observer', () {
      // Arrange
      List<int> collected = new List<int>();

      // Act
      SeqSubscription subscription = new SeqSubscription(
          (int value) => collected.add(value),
          (Action<int> observable) => observable(10));

      // Assert
      expect(collected.length, 1);
      expect(collected[0], 10);
    });

    test('patch multiple values to observer', () {

    });
  });

  group('-Seq- should', () {

    test('not block with no listeners', () {
      // Arrange
      SeqSource source = new SeqSource();
      Seq sequence = source.sequence;

      // Act
      //source.next(10);

      // Assert
      expect(true, true, reason: 'will not get here if source.next blocks');
    });

      test('be awesome', () {
        SeqSource source = new SeqSource();

        Seq sequence = source.sequence;

        List<int> collected = new List<int>();

        IDisposable subscription = sequence.sip((int event) => collected.add(event));

        source.next(10);

        // Assert
        expect(collected.length, 1);
        expect(collected[0], 10);

        subscription.dispose();

        /*
        // Arrange
        SeqSource seqSource = SeqSource.fromIterable([10, 20, 30, 40]);


        Seq seqL = Seq.fromSource(seqSource);
        Seq seqR = Seq.fromSource(seqSource);

        // Act
        Seq seqZipped = Seq.zip(seqL, seqR);
        Iterable<int> result = seqZipped.take(4).toIterable();

        seqSource.emit();

        // Assert
        expect(result[0][0], 10);
        expect(result[0][1], 1);
        expect(result[3][0], 40);
        expect(result[3][1], 4);
        */
      });

  });
}
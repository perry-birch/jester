part of jester_test;

packed_int_tests() {

  group('-packed_int- should', () {

    test('return zero for empty string', () {
      // Arrange
      var value = '';

      // Act
      var packed = PackedInt.pack(value);

      // Assert
      expect(packed, 0x00);
    });

    test('return one for a', () {
      // Arrange
      var value = 'a';

      // Act
      var packed = PackedInt.pack(value);

      // Assert
      expect(packed, 0x01);
    });

    test('return 00 0010 0001 for aa', () {
      // Arrange
      var value = 'aa';

      // Act
      var packed = PackedInt.pack(value);

      // Assert
      expect(packed, 0x21);
    });

    test('return 000 0100 0010 0001 for aaa', () {
      // Arrange
      var value = 'aaa';

      // Act
      var packed = PackedInt.pack(value);

      // Assert
      expect(packed, 0x421);
    });

    test('return 000 0100 0010 0001 for AAA', () {
      // Arrange
      var value = 'AAA';

      // Act
      var packed = PackedInt.pack(value);

      // Assert
      expect(packed, 0x421);
    });

    test('return ... a big bit mask for 12 a', () {
      // Arrange
      var value = 'aaaaaaaaaaaa';

      // Act
      var packed = PackedInt.pack(value);

      // Assert
      expect(packed, 0x84210842108421);
    });

    test('unpack a value after being packed', () {
      // Arrange
      var value = 'asdfasdf';
      var packed = PackedInt.pack(value);

      // Act
      var unpacked = PackedInt.unpack(packed);

      // Assert
      expect(unpacked, 'ASDFASDF');
    });

    test('ignore strings longer than 12 chars', () {
      // Arrange
      var value = 'asdfasdfasdfasdf';
      var packed = PackedInt.pack(value);

      // Act
      var unpacked = PackedInt.unpack(packed);

      // Assert
      expect(unpacked, 'ASDFASDFASDF');
    });

    test('ignore any non alpha chars (except _)', () {
      // Arrange
      var value = '@asdf123!_~asdf123@';
      var packed = PackedInt.pack(value);

      // Act
      var unpacked = PackedInt.unpack(packed);

      // Assert
      expect(unpacked, 'ASDF_ASDF');
    });

  });

}
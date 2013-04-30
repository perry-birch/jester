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

    test('fit correct number of chars in 128 bit int', () {
      // Arrange
      var value = 'arbitrarily_large_set_of_chars_to_fill_big_int_value';
      var packed = PackedInt.pack(value, bitCount: 128);

      // Act
      var unpacked = PackedInt.unpack(packed, bitCount: 128);

      // Assert
      expect(unpacked, 'ARBITRARILY_LARGE_SET_OF_');
    });

    test('fit correct number of chars in 1024 bit int', () {
      // Arrange
      var value = 'arbitrarily_large_set_of_chars_to_fill_big_int_value_xone_arbitrarily_large_set_of_chars_to_fill_big_int_value_xtwo_arbitrarily_large_set_of_chars_to_fill_big_int_value_xthree_arbitrarily_large_set_of_chars_to_fill_big_int_value_xfour';
      var packed = PackedInt.pack(value, bitCount: 1024);

      // Act
      var unpacked = PackedInt.unpack(packed, bitCount: 1024);

      // Assert - 154 chars of 204 ... indicates smaller max size?
      expect(unpacked, 'ARBITRARILY_LARGE_SET_OF_CHARS_TO_FILL_BIG_INT_VALUE_XONE_ARBITRARILY_LARGE_SET_OF_CHARS_TO_FILL_BIG_INT_VALUE_XTWO_ARBITRARILY_LARGE_SET_OF_CHARS_TO_FILL_BIG_INT_VALUE_XTHREE_ARBITRARILY_LARGE_SET_OF_CHA');
    });

    test('fit correct number of chars in 1024 bit int', () {
      // Arrange
      var value = 'arbitrarily_large_set_of_chars_to_fill_big_int_value_xone_arbitrarily_large_set_of_chars_to_fill_big_int_value_xtwo_arbitrarily_large_set_of_chars_to_fill_big_int_value_xthree_arbitrarily_large_set_of_chars_to_fill_big_int_value_xfour';
      var packed = PackedInt.pack(value, bitCount: 1016);

      // Act
      var unpacked = PackedInt.unpack(packed, bitCount: 1016);

      // Assert - 154 chars of 204 ... indicates smaller max size?
      expect(unpacked, 'ARBITRARILY_LARGE_SET_OF_CHARS_TO_FILL_BIG_INT_VALUE_XONE_ARBITRARILY_LARGE_SET_OF_CHARS_TO_FILL_BIG_INT_VALUE_XTWO_ARBITRARILY_LARGE_SET_OF_CHARS_TO_FILL_BIG_INT_VALUE_XTHREE_ARBITRARILY_LARGE_SET_OF_CHA');
    });
  });

}
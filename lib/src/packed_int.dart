part of jester;

// TODO: Implement a variant which restricts the top 16 ascii chars, maybe based on: http://en.wikipedia.org/wiki/Letter_frequency
/*
 *  Packs and unpacks up to 12 chars into a 64 bit (8 bytes)
 *  A 50% increase in storage at the cost of limiting to ASCII chars and ignoring case
 *  Might want to limit the scope to 52/53 bits due to JS limitations for client side execution
 */
class PackedInt {
  static const int _mask = 0x1F; // 0001 1111
  static const int _upper = 0x40; // 0100 0000
  static const int _lower = 0x60; // 0110 0000
  static final dynamic pack = (String target, {int bitCount: 64}) {
    var maxChars = maxChars(bitCount);
    int hash = 0;

    var bytes = target.codeUnits
        .where((byte) => byte > 0x40) // Ensure all pulled bytes fall in the alpha range of ASCII
        .map((byte) => byte & _mask) // Mask off the first three bits of each byte
        .where((byte) => (0 < byte && byte <= 26) || byte == 0x1F) // Ensure all bytes are actually letters (or _)
        .toList(growable: false); // Convert to a list to realize the query built above
    int count = bytes.length > maxChars ? maxChars : bytes.length;
    for(int i = 0; i < count; i++) {
      hash = (hash << 5) | bytes[i];
    }
    return hash;
  };

  static final dynamic unpack = (int target, {int bitCount: 64}) {
    var maxChars = maxChars(bitCount); // Need 5 bits for each char
    List<int> buffer = new List<int>(maxChars);
    var index = 0;
    while(target > 0) {
      buffer[index++] = 0x40 | (target & _mask);
      target = target >> 5;
    }
    StringBuffer sb = new StringBuffer();
    while(index > 0) {
      sb.writeCharCode(buffer[--index]);
    }
    return sb.toString();
  };

  /*
   * Calculates the number of full 5 bit sets available
   */
  static int maxChars(int bitCount) {
    var mod = bitCount % 5;
    var availableBits = bitCount - mod;
    var charCount = availableBits ~/ 5;
    return charCount;
  }
}
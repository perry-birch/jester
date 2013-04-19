part of jester;

/// Packs and unpacks up to 12 chars into a 64 bit
class PackedInt {
  static const int _mask = 0x1F; // 0001 1111
  static const int _upper = 0x40; // 0100 0000
  static const int _lower = 0x60; // 0110 0000
  static final dynamic pack = (String target) {
    int hash = 0;

    var bytes = target.codeUnits
        .where((byte) => byte > 0x40) // Ensure all pulled bytes fall in the alpha range of ASCII
        .map((byte) => byte & _mask) // Mask off the first three bits of each byte
        .where((byte) => (0 < byte && byte <= 26) || byte == 0x1F) // Ensure all bytes are actually letters (or _)
        .toList(growable: false); // Convert to a list to realize the query built above
    int count = bytes.length > 12 ? 12 : bytes.length;
    for(int i = 0; i < count; i++) {
      hash = (hash << 5) | bytes[i];
    }
    return hash;
  };

  static final dynamic unpack = (int target) {
    List<int> buffer = new List<int>(12);
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
}
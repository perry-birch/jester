part of jester;

/// Packs and unpacks up to 12 chars into a 64 bit
class PackedInt {
  static const int _mask = 0x1F; // 0001 1111
  static final dynamic pack = (String target) {
    int hash = 0;
    int count = target.length > 12 ? 12 : target.length;
    for(int i = 0; i < count; i++) {
      hash = (hash << 5) | (target.codeUnits[i] & _mask);
    }
    return hash;
  };

  static final dynamic unpack = (int target) {
    List<int> buffer = new List<int>(12);
    var index = 0;
    while(target > 0) {
      buffer[index++] = 0x60 | (target & _mask);
      target = target >> 5;
    }
    StringBuffer sb = new StringBuffer();
    while(index > 0) {
      sb.writeCharCode(buffer[--index]);
    }
    return sb.toString();
  };
}
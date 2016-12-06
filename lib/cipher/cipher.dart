import 'dart:convert';
import 'dart:typed_data';

import 'package:pointycastle/pointycastle.dart';


class FileCipher {
  final passSize = 16;

  BlockCipher cipher;
  CipherParameters param;

  initCipher(String pass) {

    while(pass.length < passSize) {
      pass += pass;
    }

    if (pass.length > passSize) {
      pass = pass.substring(0, passSize);
    }

    var k = UTF8.encode(pass);

    final key = new Uint8List.fromList(k);
    //print("key length: ${key.length}");

    param = new KeyParameter(key);
    cipher = new BlockCipher('AES');
  }

  Uint8List processBlocks( Uint8List inp ) {
    if (inp.lengthInBytes % 16 != 0) {
      inp = new Uint8List((inp.lengthInBytes + 15) ~/ 16 * 16);
    }
    var out = new Uint8List(inp.lengthInBytes);

    for( var offset=0 ; offset < inp.lengthInBytes ; ) {
      var len = cipher.processBlock( inp, offset, out, offset );
      offset += len;
    }
    return out;
  }

}


class FileCipherEncode extends FileCipher {

  Uint8List encodeBytes(List<int> bytes) {

    var input = new Uint8List((bytes.length + 15) ~/ 16 * 16);
    input.setRange(0, bytes.length, bytes);

    cipher.reset();
    cipher.init(true, param);

    var encoded = processBlocks(input);

    return encoded;
  }

}


class FileCipherDecode extends FileCipher {

  decodeBytes(List<int> bytes, [int maxSize = 0]) {

    var input = new Uint8List.fromList(bytes);

    cipher.reset();
    cipher.init(false, param);

    var encoded = processBlocks(input);

    if (maxSize > 0 && encoded.lengthInBytes > maxSize) {
      encoded = encoded.sublist(0, maxSize);
    }

    return encoded;
  }

}

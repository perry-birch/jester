library jester_test;

import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:unittest/unittest.dart';
import 'package:jester/jester.dart';

part 'src/mocks/mock_actor.dart';

part 'src/actor_test.dart';
part 'src/message_definitions_test.dart';
part 'src/packed_int_test.dart';
part 'src/safe_receive_port_test.dart';

main() {
  actor_tests();
  message_definitions_tests();
  packed_int_tests();
  safe_receive_port_tests();
}
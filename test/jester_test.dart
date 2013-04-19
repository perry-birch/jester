library jester_test;

import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:unittest/unittest.dart';
import 'package:jester/jester.dart';

part 'src/mocks/mock_base_actor.dart';
part 'src/mocks/receive_port_proxy.dart';

part 'src/mocks/receive_port_proxy_test.dart';

part 'src/actor_test.dart';
part 'src/message_definitions_test.dart';
part 'src/packed_int_test.dart';

main() {

  // Mock tests
  receive_port_proxy_tests();

  // Actual tests
  actor_tests();
  message_definitions_tests();
  packed_int_tests();

}
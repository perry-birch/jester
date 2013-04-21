part of jester_test;

// Use as a top level entry point for isolate creation
void createMockActor() {
  new MockActor(port);
}
class MockActor extends Actor {
  MockActor._(ReceivePort receivePort) : super(receivePort);

  factory MockActor(ReceivePort receivePort) {
    var mockActor = new MockActor._(receivePort);
    mockActor | MockActor.initB; // Assign a starting behavior
    return mockActor;
  }

  // To enable creation inside an isolate boundary try:
  static final MockActor create = () {
    return Actor.create(createMockActor);
  };

  /// Define the scope for all commands and events in this type
  static const String SCOPE = 'UNIQUE_KEY_FOR_ACTOR';

  /// Define commands the type accepts
  static const CommandTypes START_COMMAND = const CommandTypes(SCOPE, 'START_COMMAND');
  static const CommandTypes STOP_COMMAND = const CommandTypes(SCOPE, 'STOP_COMMAND');

  /// Define events the type emits
  static const EventTypes STARTING_EVENT = const EventTypes(SCOPE, 'STARTING_EVENT');
  static const EventTypes STARTED_EVENT = const EventTypes(SCOPE, 'STARTED_EVENT');
  static const EventTypes STOPPING_EVENT = const EventTypes(SCOPE, 'STOPPING_EVENT');
  static const EventTypes STOPPED_EVENT = const EventTypes(SCOPE, 'STOPPED_EVENT');

  /// Actor behaviors are defined by a series of COMMAND and EVENT handlers
  /// Changing behaviors is one way that actors can mutate
  static final Behavior initB = new Behavior([

    ]);
}
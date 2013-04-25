part of jester;

// Actor
typedef void IsolateLoader();
typedef bool IsolateErrorHandler(IsolateUnhandledException ex);
typedef SendPort BaseActorCreator(IsolateLoader loader, [IsolateErrorHandler errorHandler]);
typedef SendPort ActorCreator();
typedef TProxy ProxyCreator<TProxy>();
typedef void MessageHandler(Actor actor, dynamic data, IStream replyTo);
typedef void SendTo(dynamic message, [IStream from]);

// SafeReceivePort
typedef void ReceivePortCallback<T>(T arg, SendPort replyTo);

// Disposable
typedef void UsingFunction(IDisposable target);
typedef Future<T> UsingAsyncFunction<T>(IDisposable target);
typedef Future<T> UsingAsync<T>(IDisposable target, UsingAsyncFunction<T> func);
typedef void DisposableCallback();
part of jester;

abstract class Scheduler {
  /*
   * Minimum granularity of period is 4 ms in d2js
   */
  IAsyncDisposable recurringWithState(dynamic state, void action(dynamic state), { Duration period: Duration.ZERO }) {
    var s = state;
    var callback = () => action(s);
    if(period == Duration.ZERO) {
      IAsyncDisposable disposable = new AsyncDisposable();
      var timerCallback = () {                // Define recursive function
        if(disposable.isDisposed) { return; } // Break the callback chain once disposed
        callback();                           // Trigger the provided callback
        Timer.run(timerCallback);             // Recursively trigger itself
      };
      timerCallback();                        // Begin recursive callbacks
      return disposable;
    } else {
      Timer timer = new Timer(period, callback);
      return new AsyncDisposable(() => timer.cancel());
    }
  }
}
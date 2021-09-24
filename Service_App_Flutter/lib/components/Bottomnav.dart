import 'globals.dart' as globals;

class MyComponent {
  view() {
    if (globals.isLoggedIn) {
      doSomething();
  }}

  void doSomething() {}

  void doSomethingElse() {}
}
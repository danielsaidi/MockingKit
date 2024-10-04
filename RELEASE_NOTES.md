# Release Notes


## 1.5

This version makes the SDK use Swift 6.



## 1.4.2

This version adds support for strict concurrency.



## 1.4.1

This version adds support for visionOS.



## 1.4

This version bumps Swift to 5.9.



## 1.3

Thanks to [Tim Andersson](https://github.com/Boerworz) and the people at BookBeat, MockingKit now supports keypaths.

### ✨ New Features

* `Mockable` now supports keypaths for all functions except `call`.



## 1.2

This version removes all external dependencies.

### 📦 Dependencies

* MockingKit no longer uses Quick and Nimble.



## 1.1.1

This version adds a mock pasteboard for macOS and adjusts the documentation setup.

### ✨ New Features

* `MockPasteboard` now supports macOS as well.

### 💡 Behavior changes

* MockingKit no longer uses the DocC documentation plugin.



## 1.1

### ✨ New Features

* This version adds support for Swift concurrency and `async` functions.

### 💥 Breaking Changes

* Since Swift Concurrency requires iOS 13 and tvOS and later, the minimum platform versions for this library have been bumped.



## 1.0

This version bumps the package Swift version to 5.5 to enable extended DocC support.

It also removes previously deprecated parts of the library and removes `call` functions with implicitly unwrapped args.



## 0.9.4

This version replaces the accidental SSH dependencies to Quick and Nimble with HTTPS ones.

Big thanks to Dave Verwer and [SPI](https://swiftpackageindex.com) for noticing this!



## 0.9.3

`MockTextDocumentProxy` no longer modifies its state when calling its functions.



## 0.9.2

`MockTextDocumentProxy` has a new `keyboardAppearance` property.



## 0.9.1

Thanks to [@jinuman](https://github.com/jinuman) this version fixes the incorrectly high deployment targets.

This version also annotates another invoke function as deprecated.



## 0.9.0

This version renames invoke/invocation to call/calls to make the code cleaner and less technical:

* `AnyInvokation` → `AnyCall`
* `MockInvokation` → `MockCall`
* `Mock` `registeredInvokations` → `registeredCalls`
* `Mockable` `hasInvoked(_)` → `hasCalled(_)`
* `Mockable` `hasInvoked(_, numberOfTimes:)` → `hasCalled(_, numberOfTimes:)`
* `Mockable` `invoke` → `call`
* `Mockable` `invokations(of:)` → `calls(to:)`
* `Mockable` `resetInvokations` → `resetCalls`
* `Mockable` `resetInvokations(for:)` → `resetCalls(to:)`

This also solves that with my Swedish eyes spelled invocation as invokation, which is how it's spelled here :)   

The old invoke/invokation parts are marked as deprecated and will be removed in 1.0. 



## 0.8.2

This version adds a `MockPasteboard` and a `MockTextDocumentProxy`.



## 0.8.1

This version adds `stringArray` support to `MockUserDefaults`.



## 0.8.0

This version renames Mockery to MockingKit.



## 0.7.0

This version's podspec has been adjusted to support macOS 10.10.

There is also a new demo app with more demos and examples. 



## 0.6.1

This version supports macOS 10.10 instead of 10.15.



## 0.6.0

This version adds improved support for watchOS, tvOS and macOS.



## 0.5.0

This version adds mock classes that lets you commonly used `Foundation` classes:

* `MockNotificationCenter`
* `MockUserDefaults`



## 0.4.0

This version replaces the memory address resolve logic with a new `MockReference` approach.

`MockReference`, replaces the brittle memory address-based approach from previous versions and makes invokations much more reliable. This means that it's now possible to use Mockery for more architectures and devices than 64 bit, that mocks can be shared across frameworks etc.



## 0.3.3

This version removes deprecations and updates to latest Quick and Nimble.



## 0.3.2

This version updates Nimble to `8.0.7`.



## 0.3.1

This version fixes a typo in the `executions(of:)` deprecation.



## 0.3.0

This version adds a `Mockable` protocol, which removes the need for the previous recorder approach. `Mock` implements `Mockable` by providing itself as mock.



## 0.2.0

This version renames some methods and introduces new typealiases to make the api more readable.

* The new typealias `MemoryAddress`  is used instead of `Int`, which is the underlying type.
* `AnyExecution` has been renamed to `AnyInvokation`
* `Execution` has been renamed to `Invokation`
* `executions(of:)` has been renamed to `invocations(of:)`
* There are new `didInvoke` functions that help simplify inspections.
* The `default` invoke argument has been renamed to `fallback` 

This version also specifies an explicit "current project version", to avoid some Carthage problems. 



## 0.1.0

This version renames Mock n Roll to Mockery and adds support for Xcode 11 and SPM.



## 0.0.1

This is the first versioned push to the CocoaPods trunk, but I will polish it a bit more until I bump it up to a real version.

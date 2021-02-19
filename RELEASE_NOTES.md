# Release Notes


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

# Release Notes


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

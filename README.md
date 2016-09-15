# RxEventHub

[![CI Status](http://img.shields.io/travis/zzdjk6/RxEventHub.svg?style=flat)](https://travis-ci.org/RxSwiftCommunity/RxEventHub)
[![Version](https://img.shields.io/cocoapods/v/RxEventHub.svg?style=flat)](http://cocoapods.org/pods/RxEventHub)
[![License](https://img.shields.io/cocoapods/l/RxEventHub.svg?style=flat)](http://cocoapods.org/pods/RxEventHub)
[![Platform](https://img.shields.io/cocoapods/p/RxEventHub.svg?style=flat)](http://cocoapods.org/pods/RxEventHub)

## Overview

`RxEventHub` is an event hub in `RxSwift` world, it makes multicasting event easy, type-safe and error-free, it's intent to replace usage of `NSNotificationCenter` in most cases.

To make multicasting event type-safe and error-free, this lib provides `RxEventProvider` with generic type. For each type of event you want to send and observe, you create a subclass of `RxEventProvider`, just like below:

```swift
class ExampleIntEventProvider: RxEventProvider<Int>{}
```

This class is used to provide type info and event name. You may override the `typeKey` method to provide custom event name.

You can notify the hub when events occur by simply writing 1 line code like below:

```swift
RxEventHub.sharedHub.notify(ExampleIntEventProvider(), data: 2)
```

You can get the `Observable` (`Observable<T>` in this example) when events occur by simply writing 1 line code like below:

```swift
RxEventHub.sharedHub.eventObservable(ExampleIntEventProvider())
```

One more thing, you can either use the default hub `RxEventHub.sharedHub`, or create different hubs for different modules as you want.

## Requirements

* Swift 2.x (use another branch for Swift 3, work in progress)

## Installation

### CocoaPods

RxEventHub is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "RxEventHub"
```

### Manual

Just copy `RxEventHub.swift` into your project, and you're ready to go.

## License

RxEventHub is available under the MIT license. See the LICENSE file for more info.

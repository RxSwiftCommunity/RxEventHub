/*
 RxEventHub.swift
 
 Copyright (c) RxSwiftCommunity
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

import Foundation
import RxSwift

/// Event hub class, you can use `sharedHub` as provided, or create your own instance.
open class RxEventHub {
    
    /// Singleton
    open static let sharedHub = RxEventHub()
    
    /// DisposeBag
    private let disposeBag = DisposeBag()
    
    /// A dict to hold all `PublishSubject` of events.
    private var subjectDict = Dictionary<String, AnyObject>()
    
    /**
     Multicast event to observers.
     
     - parameter provider: An instance of RxEventProvider, provide name and type info for 1 kind of event.
     - parameter data:     The data packaged with notification, send to all observers.
     */
    open func notify<T>(_ provider: RxEventProvider<T>, data: T) {
        let subject = eventSubject(provider)
        subject.onNext(data)
    }
    
    /**
     Get the `Observable` for 1 kind of event, subscribe it to get notified when event multicasting.
     
     - parameter provider: An instance of `RxEventProvider`, provide name and type info for 1 kind of event.
     
     - returns: `Observable` for given kind of event.
     */
    open func eventObservable<T>(_ provider: RxEventProvider<T>) -> Observable<T> {
        let subject = eventSubject(provider)
        return subject.asObservable()
    }
    
    /**
     Get the `PublishSubject` for 1 kind of event, use it to control multicasting.
     
     Each king of event has only 1 subject in 1 hub.
     
     - parameter provider: An instance of `RxEventProvider`, provide name and type info for 1 kind of event.
     
     - returns: `PublishSubject` for given kind of event.
     */
    private func eventSubject<T>(_ provider: RxEventProvider<T>) -> PublishSubject<T> {
        let key = provider.typeKey()
        if let subject = subjectDict[key] as? PublishSubject<T> {
            return subject
        }
        
        let subject = provider.publishSubject()
        subjectDict[key] = subject
        return subject
    }
    
}

/// Event provider, provide name and type info for 1 kind of event.
open class RxEventProvider<T> {
    
    public init() {}
    
    /**
     Create `PublishSubject` for event.
     
     - returns: `PublishSubject` with type from given paramter.
     */
    open func publishSubject() -> PublishSubject<T> {
        return PublishSubject<T>()
    }
    
    /**
     Provide event name to be indexed in hub.
     
     Default event name is the class name, you can change it in subclass.
     
     - returns: Key string
     */
    open func typeKey() -> String {
        let key = NSStringFromClass(type(of: self))
        return key
    }
}

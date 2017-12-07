// https://github.com/Quick/Quick

import Quick
import Nimble
import RxSwift
import RxEventHub

fileprivate let CURRENT_TARGET = "RxEventHub_Tests"

class ExampleClass {
    var intVar: Int = 0
    var doubleVar: Double = 0.0
    var stringVar: String = ""
    
    init(intVar: Int = 0, doubleVar: Double = 0.0, stringVar: String = "") {
        self.intVar = intVar
        self.doubleVar = doubleVar
        self.stringVar = stringVar
    }
}

class ExampleOptionalEventProvider: RxEventProvider<Bool?>{}
class ExampleVoidEventProvider: RxEventProvider<Void>{}
class ExampleIntEventProvider: RxEventProvider<Int>{}
class ExampleDoubleEventProvider: RxEventProvider<Double>{}
class ExampleStringEventProvider: RxEventProvider<String>{}
class ExampleTupleEventProvider: RxEventProvider<(int: Int, double: Double, string: String)>{}
class ExampleClassEventProvider: RxEventProvider<ExampleClass>{
    override func typeKey() -> String {
        return String(describing: type(of: self)) + ".ExampleClass"
    }
}

class RxEventProviderSpec: QuickSpec {
    
    override func spec() {
        it("should have correct name") {
            expect(ExampleOptionalEventProvider().typeKey()) == "\(CURRENT_TARGET)." + "ExampleOptionalEventProvider"
            expect(ExampleVoidEventProvider().typeKey()) == "\(CURRENT_TARGET)." + "ExampleVoidEventProvider"
            expect(ExampleIntEventProvider().typeKey()) == "\(CURRENT_TARGET)." + "ExampleIntEventProvider"
            expect(ExampleDoubleEventProvider().typeKey()) == "\(CURRENT_TARGET)." + "ExampleDoubleEventProvider"
            expect(ExampleStringEventProvider().typeKey()) == "\(CURRENT_TARGET)." + "ExampleStringEventProvider"
            expect(ExampleTupleEventProvider().typeKey()) == "\(CURRENT_TARGET)." + "ExampleTupleEventProvider"
            expect(ExampleClassEventProvider().typeKey()) == "ExampleClassEventProvider.ExampleClass"
        }
        
        it("should create correct publish subject of given type") {
            expect(String(describing: type(of: ExampleOptionalEventProvider().publishSubject()))) == "PublishSubject<Optional<Bool>>"
            expect(String(describing: type(of: ExampleVoidEventProvider().publishSubject()))) == "PublishSubject<()>"
            expect(String(describing: type(of: ExampleIntEventProvider().publishSubject()))) == "PublishSubject<Int>"
            expect(String(describing: type(of: ExampleDoubleEventProvider().publishSubject()))) == "PublishSubject<Double>"
            expect(String(describing: type(of: ExampleStringEventProvider().publishSubject()))) == "PublishSubject<String>"
            expect(String(describing: type(of: ExampleTupleEventProvider().publishSubject()))) == "PublishSubject<(int: Int, double: Double, string: String)>"
            expect(String(describing: type(of: ExampleClassEventProvider().publishSubject()))) == "PublishSubject<ExampleClass>"
        }
    }
}

class RxEventHubSpec: QuickSpec {
    
    private var disposeBag = DisposeBag()
    
    override func spec() {
        let disposeBag = self.disposeBag
        let hub = RxEventHub.sharedHub
        
        it("can notify and subscribe events with Void Param") {
            var receivedNotification = false
            hub
                .eventObservable(ExampleVoidEventProvider())
                .do(onNext: {
                    receivedNotification = true
                })
                .subscribe()
                .addDisposableTo(disposeBag)
            hub.notify(ExampleVoidEventProvider(), data: ())
            
            waitUntil { done in
                done()
            }
            
            expect(receivedNotification) == true
        }
        
        it("can notify and subscribe events with Int Param") {
            var intVar = 0
            hub
                .eventObservable(ExampleIntEventProvider())
                .do(onNext: { obj in
                    intVar = obj
                })
                .subscribe()
                .addDisposableTo(disposeBag)
            hub.notify(ExampleIntEventProvider(), data: 2)
            
            waitUntil { done in
                done()
            }
            
            expect(intVar) == 2
        }
        
        it("can notify and subscribe events with Double Param") {
            var doubleVar = 0.0
            hub
                .eventObservable(ExampleDoubleEventProvider())
                .do(onNext: { obj in
                     doubleVar = obj
                })
                .subscribe()
                .addDisposableTo(disposeBag)
            hub.notify(ExampleDoubleEventProvider(), data: 2.2)
            
            waitUntil { done in
                done()
            }
            
            expect(doubleVar) == 2.2
        }
        
        it("can notify and subscribe events with String Param") {
            var stringVar = ""
            hub
                .eventObservable(ExampleStringEventProvider())
                .do(onNext: { obj in
                     stringVar = obj
                })
                .subscribe()
                .addDisposableTo(disposeBag)
            hub.notify(ExampleStringEventProvider(), data: "abc")
            
            waitUntil { done in
                done()
            }
            
            expect(stringVar) == "abc"
        }
        
        it("can notify and subscribe events with Tuple Param") {
            var tupleVar: (int: Int, double: Double, string: String) = (int: 0, double: 0.0, string: "")
            hub
                .eventObservable(ExampleTupleEventProvider())
                .do(onNext: { obj in
                     tupleVar = obj
                })
                .subscribe()
                .addDisposableTo(disposeBag)
            hub.notify(ExampleTupleEventProvider(), data: (int: 2, double: 2.2, string: "abc"))
            
            waitUntil { done in
                done()
            }
            
            expect(tupleVar.int) == 2
            expect(tupleVar.double) == 2.2
            expect(tupleVar.string) == "abc"
        }
        
        it("can notify and subscribe events with Custom Class Param") {
            var classVar: ExampleClass = ExampleClass()
            hub
                .eventObservable(ExampleClassEventProvider())
                .do(onNext: { obj in
                    classVar = obj
                })
                .subscribe()
                .addDisposableTo(disposeBag)
            hub.notify(ExampleClassEventProvider(), data: ExampleClass(intVar: 2, doubleVar: 2.2, stringVar: "abc"))
            
            waitUntil { done in
                done()
            }
            
            expect(classVar.intVar) == 2
            expect(classVar.doubleVar) == 2.2
            expect(classVar.stringVar) == "abc"
        }
        
        it("can notify and subscribe events with Optional Param") {
            var optionalVar: Bool? = true
            hub
                .eventObservable(ExampleOptionalEventProvider())
                .do(onNext: { obj in
                    optionalVar = obj
                })
                .subscribe()
                .addDisposableTo(disposeBag)
            hub.notify(ExampleOptionalEventProvider(), data: nil)
            
            waitUntil { done in
                done()
            }
            
            expect(optionalVar).to(beNil())
        }
    }
}

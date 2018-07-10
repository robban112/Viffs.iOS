//
//  TestScheduler+MarbleTests.swift
//  Blipp
//
//  Created by Oskar Ek on 2018-06-16.
//  Copyright © 2018 Blipp. All rights reserved.
//

import RxSwift
import RxTest
import RxCocoa

/**
 Tests like these are described here:
 https://github.com/ReactiveX/RxJS/blob/master/doc/writing-marble-tests.md
 These tests are called marble tests.
 */
extension TestScheduler {
  /**
   Transformation from this format:
   
   ---a---b------c-----
   
   to this format
   
   schedule onNext(1) @ 0.6s
   schedule onNext(2) @ 1.4s
   schedule onNext(3) @ 7.0s
   ....
   ]
   */
  func events<T>(fromTimeline timeline: String, values: [String: T], errors: [String: Swift.Error] = [:]) -> [Recorded<Event<T>>] {
    //print("parsing: \(timeline)")
    typealias RecordedEvent = Recorded<Event<T>>
    
    let segments = timeline.components(separatedBy:"-")
    let (time: _, events: events) = segments.reduce((time: 0, events: [RecordedEvent]())) { state, event in
      let tickIncrement = event.count + 1
      
      guard event.count > 0 else { return (state.time + tickIncrement, state.events) }
      
      let nextValue = values[event].map(Event<T>.next)
      let errorValue = errors[event].map(Event<T>.error)
      let newEventM = (nextValue ?? errorValue).map { RecordedEvent(time: state.time, value: $0) }
      
      guard let newEvent = newEventM else {
        fatalError("Value with key \(event) not registered as value:\n\(values)\nor error:\n\(errors)")
      }
      
      return (time: state.time + tickIncrement, events: state.events + [newEvent])
    }
    
    return events
  }
  
  /**
   Creates observable for marble tests.
   
   - parameter timeline: Timeline in the form `---a---b------c--|`
   - parameter values: Dictionary of values in timeline. `[a:1, b:2]`
   - parameter errors: Dictionary of errors in timeline.
   - returns: Observable sequence specified by timeline and values.
   */
  func createObservable<T>(fromTimeline timeline: String, values: [String: T], errors: [String: Swift.Error] = [:]) -> TestableObservable<T> {
    let events = self.events(fromTimeline: timeline, values: values, errors: errors)
    return createHotObservable(events)
  }
  
  /**
   Builds testable observer for a specific observable sequence, binds it's results and sets up disposal.
   
   - parameter source: Observable sequence to observe.
   - returns: Observer that records all events for observable sequence.
   */
  func record<O: ObservableConvertibleType>(source: O) -> TestableObserver<O.E> {
    let observer = self.createObserver(O.E.self)
    let disposable = source.asObservable().bind(to: observer)
    self.scheduleAt(100000) {
      disposable.dispose()
    }
    return observer
  }
}

//
//  main.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import Foundation

print("Hello, World!")

public func testMe() -> String {
  return "I have been tested"
}

open class TestMe {
  open func Please() -> String {
    return "I have been tested"
  }
}

////////////////////////////////////
// Money
//

public struct Money {
    public var amount : Int
    public var currency : String
    private var exchangeRateOf: Dictionary<String, Double>
    private var standardCurrency: String
    
    public init(amount : Int , currency: String) {
        self.amount = amount
        self.currency = currency
        self.exchangeRateOf = [
            "GBP" : 0.5,
            "EUR" : 1.5,
            "CAN" : 1.25
        ]
        self.standardCurrency = "USD"
    }
  
    public func convert(_ to: String) -> Money {
        var result = self
        // If the "currrency is not the same as current currency"
        if to != currency {
            // Standard Currency -> Foreign Currency
            if to != self.standardCurrency , let rate = exchangeRateOf[to] {
                result.amount = Int(rate * Double(self.amount))
                result.currency = to
            // Foreign Currency -> Standard Currency
            } else if let rate = exchangeRateOf[currency] {
                result.amount = Int(Double(self.amount) / rate)
                result.currency = to
            }
        }
        return result
    }
  
  public func add(_ to: Money) -> Money {
    // Convert to "to" currency
    var result = to
    result.amount += self.convert(to.currency).amount
    return result
  }
  public func subtract(_ from: Money) -> Money {
    // Convert to "from" currency
    var result = from
    result.amount -= self.convert(from.currency).amount
    return result
  }
}

////////////////////////////////////
// Job
//

open class Job {
  fileprivate var title : String
  fileprivate var type : JobType

  public enum JobType {
    case Hourly(Double)
    case Salary(Int)
  }

  public init(title : String, type : JobType) {
    self.title = title
    self.type = type
  }

  open func calculateIncome(_ hours: Int) -> Int {
    switch type {
    case .Hourly(let rate):
        return Int(rate * Double(hours))
    case .Salary(let rate):
        return rate
    }
  }

  open func raise(_ amt : Double) {
    switch type {
    case .Hourly(let rate):
        type = JobType.Hourly(rate + amt)
    case .Salary(let rate):
        type = JobType.Salary(Int(Double(rate) + amt))
    }
  }
}

////////////////////////////////////
// Person
//

open class Person {
  open var firstName : String = ""
  open var lastName : String = ""
  open var age : Int = 0

  fileprivate var _job : Job? = nil
  open var job : Job? {
    get { return _job }
    set(value) {
        if age >= 16 {
            _job = value
        }
    }
  }

  fileprivate var _spouse : Person? = nil
  open var spouse : Person? {
    get { return _spouse }
    set(value) {
        if age >= 18 {
            _spouse = value
        }
    }
  }

  public init(firstName : String, lastName: String, age : Int) {
    self.firstName = firstName
    self.lastName = lastName
    self.age = age
  }

  open func toString() -> String {
    var stringJob: String {
        if _job != nil {
            return (_job?.title)!
        }
        return "nil"
    }
    
    var stringSpouse: String {
        if _spouse != nil {
            return (_spouse?.firstName)!
        }
        return "nil"
    }
    
    return "[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(stringJob) spouse:\(stringSpouse)]"
  }
}

////////////////////////////////////
// Family
//

open class Family {
  fileprivate var members : [Person] = []

  public init(spouse1: Person, spouse2: Person) {
    if spouse1._spouse == nil, spouse2._spouse == nil {
        members.append(spouse1)
        members.append(spouse2)
        spouse1._spouse = spouse2
        spouse2._spouse = spouse1
    }
  }

  open func haveChild(_ child: Person) -> Bool {
    for member in members {
        if member.age >= 21 {
            members.append(child)
            return true
        }
    }
    return false
  }

  open func householdIncome() -> Int {
    var income = 0
    for member in members {
        if let memberJob = member._job {
            income += memberJob.calculateIncome(2000)
        }
    }
    return income
  }
}






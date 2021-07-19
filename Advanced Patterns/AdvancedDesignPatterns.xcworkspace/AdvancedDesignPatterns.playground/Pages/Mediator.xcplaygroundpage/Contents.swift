/*:
 [Previous](@previous)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Next](@next)
 
 # Mediator
 - - - - - - - - - -
 ![Mediator Diagram](Mediator_Diagram.png)
 
 The mediator pattern is a behavioral design pattern that encapsulates how objects communicate with one another. It involves four types:
 
 1. The **colleagues** are the objects that want to communicate with each other. They implement the colleague protocol.
 
 2. The **colleague protocol** defines methods and properties that each colleague must implement.
 
 3. The **mediator** is the object that controls the communication of the colleagues. It implements the mediator protocol.
 
 4. The **mediator protocol** defines methods and properties that the mediator must implement.
 
 ## Code Example
 */
// MARK: - Common Mediator Class

open class Mediator<ColleagueType> {
    
    private class ColleagueWrapper {
        var strongColleague: AnyObject?
        weak var weakColleague: AnyObject?
        
        var colleague: ColleagueType? {
            (weakColleague ?? strongColleague) as? ColleagueType
        }
        
        init(weakColleague: ColleagueType) {
            self.strongColleague = nil
            self.weakColleague = weakColleague as AnyObject
        }
        
        init(strongColleague: ColleagueType) {
            self.strongColleague = strongColleague as AnyObject
            self.weakColleague = nil
        }
    }
    
    // MARK: - Instance Properties
    
    private var colleagueWrappers: [ColleagueWrapper] = []
    
    public var colleagues: [ColleagueType] {
        colleagueWrappers.compactMap { $0.colleague }
    }
    
    // MARK: - Object Lifecycle
    
    public init() { }
    
    // MARK: - Colleague Management
    
    public func addColleague(_ colleague: ColleagueType, strongReference: Bool = true) {
        let wrapper: ColleagueWrapper
        if strongReference {
            wrapper = ColleagueWrapper(strongColleague: colleague)
        } else {
            wrapper = ColleagueWrapper(weakColleague: colleague)
        }
        colleagueWrappers.append(wrapper)
    }
    
    public func removeColleague(_ colleague: ColleagueType) {
        guard let index = colleagues.firstIndex(where: { ($0 as AnyObject) === (colleague as AnyObject)}) else { return }
        colleagueWrappers.remove(at: index)
    }
    
    public func invokeColleagues(closure: (ColleagueType) -> Void) {
        colleagues.forEach(closure)
    }
    
    public func invokeColleagues(by colleague: ColleagueType, closure: (ColleagueType) -> Void) {
        colleagues.forEach {
            guard ($0 as AnyObject) !== (colleague as AnyObject) else { return }
            closure($0)
        }
    }
}

// MARK: - Mediator Protocol

public protocol MediatorProtocol: AnyObject {
    
    func addColleague(_ colleague: Colleague)
    func sendMessage(_ message: String, by colleague: Colleague)
}

// MARK: - Mediator

public class MusketeerMediator: Mediator<Colleague> {
    
}

extension MusketeerMediator: MediatorProtocol {
    
    public func addColleague(_ colleague: Colleague) {
        self.addColleague(colleague, strongReference: true)
    }
    
    public func sendMessage(_ message: String, by colleague: Colleague) {
        invokeColleagues(by: colleague) {
            $0.colleague(colleague, didSendMessage: message)
        }
    }
}


// MARK: - Colleague Protocol

public protocol Colleague: AnyObject {
    
    func colleague(_ colleague: Colleague?, didSendMessage message: String)
}

// MARK: - Colleague

public class Musketeer {
    
    public var name: String
    public weak var mediator: MediatorProtocol?
    
    public init(mediator: MediatorProtocol, name: String) {
        self.mediator = mediator
        self.name = name
        mediator.addColleague(self)
    }
    
    public func sendMessage(_ message: String) {
        print("\(name) sent: \(message)")
        mediator?.sendMessage(message, by: self)
    }
}

extension Musketeer: Colleague {
    
    public func colleague(_ colleague: Colleague?, didSendMessage message: String) {
        print("\(name) received: \(message)")
    }
}

// MARK: - Expample

let mediator = MusketeerMediator()
let athos = Musketeer(mediator: mediator, name: "Athos")
let porthos = Musketeer(mediator: mediator, name: "Porthos")
let aramis = Musketeer(mediator: mediator, name: "Aramis")

athos.sendMessage("One for all...!")
print("")
porthos.sendMessage("and all for one...")
print("")
aramis.sendMessage("Unus pro omnibus, omnes pro uno!")
print("")

mediator.invokeColleagues {
    $0.colleague(nil, didSendMessage: "Charge!")
}

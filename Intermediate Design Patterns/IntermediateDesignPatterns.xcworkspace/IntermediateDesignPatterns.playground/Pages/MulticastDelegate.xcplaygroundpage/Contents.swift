/*:
 [Previous](@previous)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Next](@next)
 
 # Multicast Delegate
 - - - - - - - - - -
 ![Multicast Delegate Diagram](MulticastDelegate_Diagram.png)
 
 The multicast delegate pattern is a behavioral pattern and a variation on the delegate pattern. Instead of a one-to-one delegate relationship, the multicast delegate allows you to create one-to-many delegate relationships. It involes three types:
 
 1. The **delegate protocol** defines the methods a delegate may or should implement.
 2. The **delegate** is an object that implements the delegate protocol.
 3. The **Multicast Delegate** is a helper class that holds onto delegates and allows you to invoke _all_ of the delegates whenever a delegate-worthy event happens.
 
 ## Code Example
 */
public class MulticastDelegate<ProtocolType> {
    
    // MARK: - DelegateWrapper
    
    private class DelegateWrapper {
        
        weak var delegate: AnyObject?
        
        init(_ delegate: AnyObject) {
            self.delegate = delegate
        }
    }
    
    // MARK: - Instance Properties
    
    private var delegateWrappers: [DelegateWrapper]
    
    public var delegates: [ProtocolType] {
        delegateWrappers = delegateWrappers.filter { $0.delegate != nil }
        return delegateWrappers.map { $0.delegate! } as! [ProtocolType]
    }
    
    public init(delegates: [ProtocolType] = []) {
        delegateWrappers = delegates.map { DelegateWrapper($0 as AnyObject) }
    }
    
    // MARK: - Delegate Management
    
    public func addDelegate(_ delegate: ProtocolType) {
        let wrapper = DelegateWrapper(delegate as AnyObject)
        delegateWrappers.append(wrapper)
    }
    
    public func removeDelegate(_ delegate: ProtocolType) {
        guard let index = delegateWrappers.firstIndex(where: { $0.delegate === (delegate as AnyObject) }) else { return }
        delegateWrappers.remove(at: index)
    }
    
    public func invokeDelegates(_ closure: (ProtocolType) -> ()) {
        delegates.forEach { closure($0) }
    }
}

// MARK: - Delegate Protocol

public protocol EmergencyRespondingDelegate {
    
    func notifyFire(at location: String)
    func notifyCarCrash(at location: String)
}

// MARK: - Delegates

public class FireStation: EmergencyRespondingDelegate {
    
    public func notifyFire(at location: String) {
        print("Firefighters were norified about a fire at " + location)
    }
    
    public func notifyCarCrash(at location: String) {
        print("Firefighters were norified about a car crash at " + location)
    }
}

public class PoliceStation: EmergencyRespondingDelegate {
    
    public func notifyFire(at location: String) {
        print("Police were norified about a fire at " + location)
    }
    
    public func notifyCarCrash(at location: String) {
        print("Police were norified about a car crash at " + location)
    }
}

// MARK: - Delegating Object

public class DispatchSystem {
    
    let mulitcastDelegate = MulticastDelegate<EmergencyRespondingDelegate>()
}

// MARK: - Example

let dispatch = DispatchSystem()
var policeStation: PoliceStation! = PoliceStation()
var fireStation: FireStation! = FireStation()

dispatch.mulitcastDelegate.addDelegate(policeStation)
dispatch.mulitcastDelegate.addDelegate(fireStation)
dispatch.mulitcastDelegate.invokeDelegates { $0.notifyFire(at: "Ray's house!") }
print("")
fireStation = nil
dispatch.mulitcastDelegate.invokeDelegates { $0.notifyCarCrash(at: "Ray's garage!") }

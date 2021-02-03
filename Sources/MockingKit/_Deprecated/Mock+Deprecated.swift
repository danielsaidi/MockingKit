import Foundation

public extension Mock {
    
    @available(*, deprecated, renamed: "registeredCalls")
    var registeredInvokations: [UUID: [AnyInvokation]] {
        get { registeredCalls }
        set { registeredCalls = newValue }
    }
}

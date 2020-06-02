import Quick
import Nimble
@testable import Mockery

class Mockable_MemoryAddressTests: QuickSpec {
    
    override func spec() {
        
        var obj: TestClass!
        
        beforeEach {
            obj = TestClass()
        }
        
        describe("address of function") {
            
            it("is different for different signatures") {
                let add1 = obj.address(of: obj.handleArg1)
                let add2 = obj.address(of: obj.handleArg2)
                expect(add1).toNot(equal(add2))
            }
            
            it("is different for same signature") {
                let add1 = obj.address(of: obj.handleArg1)
                let add2 = obj.address(of: obj.handleArg1_1)
                expect(add1).toNot(equal(add2))
            }
        }
    }
}

private class TestClass: Mock {
    
    struct ArgType1 {}
    struct ArgType2 {}
    struct ReturnType1 {}
    struct ReturnType2 {}
    
    func handleArg1(_ obj: ArgType1) -> ReturnType1? { nil }
    func handleArg1_1(_ obj: ArgType1) -> ReturnType1? { nil }
    func handleArg2(_ obj: ArgType2) -> ReturnType2? { nil }
}

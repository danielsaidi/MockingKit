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
            
            it("is same for same function") {
                let add1 = obj.address(of: obj.handle)
                let add2 = obj.address(of: obj.handle)
                expect(add1).to(equal(add2))
            }
            
            it("is different for function with different name") {
                let add1 = obj.address(of: obj.handle)
                let add2 = obj.address(of: obj.handle2)
                expect(add1).toNot(equal(add2))
            }
            
            it("is different for function with different argument type") {
                let add1 = obj.address(of: obj.handle)
                let add2 = obj.address(of: obj.handle3)
                expect(add1).toNot(equal(add2))
            }
            
            it("is different for function with different return type") {
                let add1 = obj.address(of: obj.handle)
                let add2 = obj.address(of: obj.handle4)
                expect(add1).toNot(equal(add2))
            }
        }
    }
}

private class TestClass: Mock {
    
    struct Arg1 {}
    struct Arg2 {}
    struct ReturnType1 {}
    struct ReturnType2 {}
    struct ReturnType3 {}
    
    func handle(_ obj: Arg1) -> ReturnType1? { nil }
    func handle2(_ obj: Arg1) -> ReturnType1? { nil }
    func handle3(_ obj: Arg2) -> ReturnType2? { nil }
    func handle4(_ obj: Arg1) -> ReturnType3? { nil }
}

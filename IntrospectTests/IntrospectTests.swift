import XCTest
import SwiftUI

@testable import Introspect

private struct NavigationTestView: View {
    let spy: () -> Void
    var body: some View {
        NavigationView {
            VStack {
                EmptyView()
            }
            .introspectNavigationController { navigationController in
                self.spy()
            }
        }
    }
}

private struct ListTestView: View {
    
    let spy1: () -> Void
    let spy2: () -> Void
    
    var body: some View {
        List {
            Text("Item 1")
            Text("Item 2")
                .introspectTableView { tableView in
                    self.spy2()
                }
        }
        .introspectTableView { tableView in
            self.spy1()
        }
    }
}

private struct ScrollTestView: View {
    
    let spy1: () -> Void
    let spy2: () -> Void
    
    var body: some View {
        HStack {
            ScrollView {
                Text("Item 1")
            }
            .introspectScrollView { scrollView in
                self.spy1()
            }
            ScrollView {
                Text("Item 1")
                .introspectScrollView { scrollView in
                    self.spy2()
                }
            }
        }
    }
}

private struct TextFieldTestView: View {
    let spy: () -> Void
    @State private var textFieldValue = ""
    var body: some View {
        TextField("Text Field", text: $textFieldValue)
        .introspectTextField { textField in
            self.spy()
        }
    }
}

private struct ToggleTestView: View {
    let spy: () -> Void
    @State private var toggleValue = false
    var body: some View {
        Toggle("Toggle", isOn: $toggleValue)
        .introspectSwitch { uiSwitch in
            self.spy()
        }
    }
}

class IntrospectTests: XCTestCase {
    func testNavigation() {
        
        let expectation = XCTestExpectation()
        let view = NavigationTestView(spy: {
            expectation.fulfill()
        })
        TestUtils.present(view: view)
        wait(for: [expectation], timeout: 1)
    }
    
    func testList() {
        
        let expectation1 = XCTestExpectation()
        let expectation2 = XCTestExpectation()
        let view = ListTestView(
            spy1: { expectation1.fulfill() },
            spy2: { expectation2.fulfill() }
        )
        TestUtils.present(view: view)
        wait(for: [expectation1, expectation2], timeout: 1)
    }
    
    func testScrollView() {
        
        let expectation1 = XCTestExpectation()
        let expectation2 = XCTestExpectation()
        let view = ScrollTestView(
            spy1: { expectation1.fulfill() },
            spy2: { expectation2.fulfill() }
        )
        TestUtils.present(view: view)
        wait(for: [expectation1, expectation2], timeout: 1)
    }
    
    func testTextField() {
        
        let expectation = XCTestExpectation()
        let view = TextFieldTestView(spy: {
            expectation.fulfill()
        })
        TestUtils.present(view: view)
        wait(for: [expectation], timeout: 1)
    }
    
    func testToggle() {
        
        let expectation = XCTestExpectation()
        let view = ToggleTestView(spy: {
            expectation.fulfill()
        })
        TestUtils.present(view: view)
        wait(for: [expectation], timeout: 1)
    }
}
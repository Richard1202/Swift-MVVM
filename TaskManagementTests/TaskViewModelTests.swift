//
//  TaskViewModelTests.swift
//  TaskManagementTests
//
//  Created by Richard Stewart on 2020/9/6.
//  Copyright © 2020 Richard Stewart. All rights reserved.
//

import XCTest
@testable import TaskManagement

class TaskViewModelTests: XCTestCase {
    var authViewModel: AuthViewModel!
    
    var viewModel: TaskViewModel!
    
    let testUserId = 1
    let testTaskId = 4

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = TaskViewModel()
        
        authViewModel = AuthViewModel()
        login()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
    }
    
    func login() {
        let exp = expectation(description: "Check Login Invalid Email")
        
        authViewModel.login(email: "b@mail.com", password: "Pass1234")
        
        authViewModel.state.observe(on: self) { state in
            if state != ActionState.waiting {
                exp.fulfill()
            }
        }
        
        waitForExpectations(timeout: 4.0) {
            error in
            if let _ = error {
                XCTAssert(false, "Timeout while attempting login")
            }
        }
            
    }
    
    // MARK: - Load Test Case
    
    func testLoad() throws {
        let exp = expectation(description: "Check Task Load")

        viewModel.load()

        // Assert
        viewModel.state.observe(on: self) { state in
            if state != ActionState.waiting {
                XCTAssertEqual(self.viewModel.state.value, ActionState.success)

                exp.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5.0) {
            error in
            if let _ = error {
                XCTAssert(false, "Timeout while attempting load")
            }
        }
    }

    // MARK: - Add Test Case

    func testAddEmptyTitle() throws {
        let exp = expectation(description: "Check Add Empty Title")

        viewModel.add(title: "", description: "Description", date: "2020-08-12", hours: 3)

        // Assert
        viewModel.state.observe(on: self) { state in
            if state != ActionState.waiting {
                XCTAssertEqual(self.viewModel.state.value, ActionState.fail)
                XCTAssertEqual(self.viewModel.error.value, "The title field is required.")

                exp.fulfill()
            }
        }
        
        waitForExpectations(timeout: 4.0) {
            error in
            if let _ = error {
                XCTAssert(false, "Timeout while attempting add")
            }
        }
    }
    
    func testAddEmptyDescription() throws {
        let exp = expectation(description: "Check Add Empty Description")

        viewModel.add(title: "Title", description: "", date: "2020-08-12", hours: 3)

        // Assert
        viewModel.state.observe(on: self) { state in
            if state != ActionState.waiting {
                XCTAssertEqual(self.viewModel.state.value, ActionState.fail)
                XCTAssertEqual(self.viewModel.error.value, "The description field is required.")

                exp.fulfill()
            }
        }
        
        waitForExpectations(timeout: 4.0) {
            error in
            if let _ = error {
                XCTAssert(false, "Timeout while attempting add")
            }
        }
    }
    
    func testAddEmptyDate() throws {
        let exp = expectation(description: "Check Add Empty Date")

        viewModel.add(title: "Test", description: "Description", date: "", hours: 3)

        // Assert
        viewModel.state.observe(on: self) { state in
            if state != ActionState.waiting {
                XCTAssertEqual(self.viewModel.state.value, ActionState.fail)
                XCTAssertEqual(self.viewModel.error.value, "The date field is required.")

                exp.fulfill()
            }
        }
        
        waitForExpectations(timeout: 4.0) {
            error in
            if let _ = error {
                XCTAssert(false, "Timeout while attempting add")
            }
        }
    }
    
    func testAddSuccess() throws {
        let exp = expectation(description: "Check Add Success")

        viewModel.add(title: "Test", description: "Description", date: "2020-08-20", hours: 3)

        // Assert
        viewModel.state.observe(on: self) { state in
            if state != ActionState.waiting {
                XCTAssertEqual(self.viewModel.state.value, ActionState.success)
                
                exp.fulfill()
            }
        }
        
        waitForExpectations(timeout: 4.0) {
            error in
            if let _ = error {
                XCTAssert(false, "Timeout while attempting add")
            }
        }
    }
        
    // MARK: - Update Test Case

    func testUpdateEmptyTitle() throws {
        let exp = expectation(description: "Check Update Empty Title")

        viewModel.update(id: 4, userId: AuthManager.shared.userInfo!.id, title: "", description: "Description", date: "2020-08-12", hours: 3)

        // Assert
        viewModel.state.observe(on: self) { state in
            if state != ActionState.waiting {
                XCTAssertEqual(self.viewModel.state.value, ActionState.fail)
                XCTAssertEqual(self.viewModel.error.value, "The title field is required.")

                exp.fulfill()
            }
        }
        
        waitForExpectations(timeout: 4.0) {
            error in
            if let _ = error {
                XCTAssert(false, "Timeout while attempting update")
            }
        }
    }

    func testUpdateEmptyDescription() throws {
        let exp = expectation(description: "Check Update Empty Description")

        viewModel.update(id: testTaskId, userId: testUserId, title: "Title", description: "", date: "2020-08-12", hours: 3)

        // Assert
        viewModel.state.observe(on: self) { state in
            if state != ActionState.waiting {
                XCTAssertEqual(self.viewModel.state.value, ActionState.fail)
                XCTAssertEqual(self.viewModel.error.value, "The description field is required.")

                exp.fulfill()
            }
        }
        
        waitForExpectations(timeout: 4.0) {
            error in
            if let _ = error {
                XCTAssert(false, "Timeout while attempting update")
            }
        }
    }

    func testUpdateEmptyDate() throws {
        let exp = expectation(description: "Check Update Empty Date")

        viewModel.update(id: testTaskId, userId: testUserId, title: "Test", description: "Description", date: "", hours: 3)

        // Assert
        viewModel.state.observe(on: self) { state in
            if state != ActionState.waiting {
                XCTAssertEqual(self.viewModel.state.value, ActionState.fail)
                XCTAssertEqual(self.viewModel.error.value, "The date field is required.")

                exp.fulfill()
            }
        }
        
        waitForExpectations(timeout: 4.0) {
            error in
            if let _ = error {
                XCTAssert(false, "Timeout while attempting update")
            }
        }
    }

    func testUpdateInvalidDate() throws {
        let exp = expectation(description: "Check Update Invalid Date")

        viewModel.update(id: testTaskId, userId: testUserId, title: "Test", description: "Description", date: "2020", hours: 3)
        
        // Assert
        viewModel.state.observe(on: self) { state in
            if state != ActionState.waiting {
                XCTAssertEqual(self.viewModel.state.value, ActionState.fail)
                XCTAssertEqual(self.viewModel.error.value, "The date is not a valid date.")

                exp.fulfill()
            }
        }
        
        waitForExpectations(timeout: 4.0) {
            error in
            if let _ = error {
                XCTAssert(false, "Timeout while attempting update")
            }
        }
    }
    
    func testUpdateSuccess() throws {
        let exp = expectation(description: "Check Update Success")

        viewModel.update(id: testTaskId, userId: testUserId, title: "Test", description: "Description", date: "2020-08-20", hours: 3)

        // Assert
        viewModel.state.observe(on: self) { state in
            if state != ActionState.waiting {
                XCTAssertEqual(self.viewModel.state.value, ActionState.success)

                exp.fulfill()
            }
        }
        
        waitForExpectations(timeout: 4.0) {
            error in
            if let _ = error {
                XCTAssert(false, "Timeout while attempting update")
            }
        }
    }

    // MARK: - Delete Test Case

    func testDeleteWrongId() throws {
        let exp = expectation(description: "Check Delete Invalid Id")

        viewModel.delete(id: 100)

        // Assert
        viewModel.state.observe(on: self) { state in
            if state != ActionState.waiting {
                XCTAssertEqual(self.viewModel.state.value, ActionState.fail)
                XCTAssertEqual(self.viewModel.error.value, "Could not find the task")

                exp.fulfill()
            }
        }
        
        waitForExpectations(timeout: 4.0) {
            error in
            if let _ = error {
                XCTAssert(false, "Timeout while attempting delete")
            }
        }
    }

    func testDeleteSuccess() throws {
        let exp = expectation(description: "Check Delete Success")

        viewModel.delete(id: 12)

        // Assert
        viewModel.state.observe(on: self) { state in
            if state != ActionState.waiting {
                XCTAssertEqual(self.viewModel.state.value, ActionState.success)
                
                exp.fulfill()
            }
        }
        
        waitForExpectations(timeout: 4.0) {
            error in
            if let _ = error {
                XCTAssert(false, "Timeout while attempting delete")
            }
        }
    }
}

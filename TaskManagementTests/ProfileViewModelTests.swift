//
//  ProfileViewModelTests.swift
//  TaskManagementTests
//
//  Created by Richard Stewart on 2020/9/6.
//  Copyright © 2020 Richard Stewart. All rights reserved.
//

import XCTest
@testable import TaskManagement


class ProfileViewModelTests: XCTestCase {
    var authViewModel: AuthViewModel!
    
    var viewModel: ProfileViewModel!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = ProfileViewModel()
        
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
    
    func testEmptyName() throws {
        let exp = expectation(description: "Check Empty Name")

        viewModel.update(id:AuthManager.shared.userInfo!.id, email: "b@mail.com", name: "", password: "Pass1234", role: Role.user.rawValue, preferWorkHours: 3)

        // Assert
        viewModel.state.observe(on: self) { state in
            if state != ActionState.waiting {
                XCTAssertEqual(self.viewModel.state.value, ActionState.fail)
                XCTAssertEqual(self.viewModel.error.value, "The name must be a string.")

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

    func testUpdateInvalidEmail() throws {
        let exp = expectation(description: "Check Invalid Email")

        viewModel.update(id:AuthManager.shared.userInfo!.id, email: "b", name: "Richard Stewart", password: "", role: "", preferWorkHours: 6)

        // Assert
        viewModel.state.observe(on: self) { state in
            if state != ActionState.waiting {
                XCTAssertEqual(self.viewModel.state.value, ActionState.fail)
                XCTAssertEqual(self.viewModel.error.value, "The email must be a valid email address.")

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

    func testUpdateSameEmail() throws {
        let exp = expectation(description: "Check Same Email")

        viewModel.update(id:AuthManager.shared.userInfo!.id, email: "richard@mail.com", name: "Richard Stewart", password: "Pass1234", role: "", preferWorkHours: 3)

        // Assert
        viewModel.state.observe(on: self) { state in
            if state != ActionState.waiting {
                XCTAssertEqual(self.viewModel.state.value, ActionState.fail)
                XCTAssertEqual(self.viewModel.error.value, "The email has already been taken.")

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

    func testUpdateEmptyRole() throws {
        let exp = expectation(description: "Check Empty Role")

        viewModel.update(id:AuthManager.shared.userInfo!.id, email: "b@mail.com", name: "Richard Stewart", password: "Pass1234", role: "", preferWorkHours: 5)

        // Assert
        viewModel.state.observe(on: self) { state in
            if state != ActionState.waiting {
                XCTAssertEqual(self.viewModel.state.value, ActionState.fail)
                XCTAssertEqual(self.viewModel.error.value, "The role must be a string.")

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

    func testInvalidPassword() throws {
        let exp = expectation(description: "Check Invalid Password")

        viewModel.update(id:AuthManager.shared.userInfo!.id, email: "b@mail.com", name: "Richard Stewart", password: "a1qwe", role: Role.user.rawValue, preferWorkHours: 3)

        // Assert
        viewModel.state.observe(on: self) { state in
            if state != ActionState.waiting {
                XCTAssertEqual(self.viewModel.state.value, ActionState.fail)
                XCTAssertEqual(self.viewModel.error.value, "The password must be at least 6 characters.")

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

    func testSuccess() throws {
        let exp = expectation(description: "Check Success")

        viewModel.update(id:AuthManager.shared.userInfo!.id, email: "b@mail.com", name: "Richard Stewart", password: "Pass1234", role: Role.user.rawValue, preferWorkHours: 5)

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
}

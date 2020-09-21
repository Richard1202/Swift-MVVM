//
//  AuthViewModelTests.swift
//  TaskManagementTests
//
//  Created by Richard Stewart on 2020/9/5.
//  Copyright © 2020 Richard Stewart. All rights reserved.
//

import XCTest
@testable import TaskManagement

class AuthViewModelTests: XCTestCase {
    var viewModel: AuthViewModel!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = AuthViewModel()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
    }

    // MARK: - Login Test Case
    
    func testLoginInvalidEmail() throws {
        let exp = expectation(description: "Check Login Invalid Email")
        
        viewModel.login(email: "test", password: "")
        
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
                XCTAssert(false, "Timeout while attempting login")
            }
        }
    }
    
    func testLoginEmptyPassword() throws {
        let exp = expectation(description: "Check Login Empty Password")
        
        viewModel.login(email: "b@mail.com", password: "")
        
        // Assert
        viewModel.state.observe(on: self) { state in
            if state != ActionState.waiting {
                XCTAssertEqual(self.viewModel.state.value, ActionState.fail)
                XCTAssertEqual(self.viewModel.error.value, "The password field is required.")
                
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

    func testLoginInvalidPassword() throws {
        let exp = expectation(description: "Check Login Invalid Password")
        
        viewModel.login(email: "b@mail.com", password: "a")
        
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
                XCTAssert(false, "Timeout while attempting login")
            }
        }
    }

    func testLoginWrongCredential() throws {
        let exp = expectation(description: "Check Login Wrong Credentail")
        
        viewModel.login(email: "b@mail.com", password: "12345678")
        
        // Assert
        viewModel.state.observe(on: self) { state in
            if state != ActionState.waiting {
                XCTAssertEqual(self.viewModel.state.value, ActionState.fail)
                XCTAssertEqual(self.viewModel.error.value, "Unauthorized")
                
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
    
    func testLoginSuccess() throws {
        let exp = expectation(description: "Check Login Success")
        
        viewModel.login(email: "b@mail.com", password: "Pass1234")
        
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
                XCTAssert(false, "Timeout while attempting login")
            }
        }
    }
    
    // MARK: - Register Test Case
    
    func testRegisterEmptyName() throws {
        let exp = expectation(description: "Check Register Empty Name")
        
        viewModel.register(email: "a123@mail.com", name: "", password: "Pass1234", role: Role.user.rawValue)
        
        // Assert
        viewModel.state.observe(on: self) { state in
            if state != ActionState.waiting {
                XCTAssertEqual(self.viewModel.state.value, ActionState.fail)
                XCTAssertEqual(self.viewModel.error.value, "The name field is required.")
                
                exp.fulfill()
            }
        }
        
        waitForExpectations(timeout: 4.0) {
            error in
            if let _ = error {
                XCTAssert(false, "Timeout while attempting register")
            }
        }
    }
    
    func testRegisterInvalidEmail() throws {
        let exp = expectation(description: "Check Register Invalid Email")
        
        viewModel.register(email: "a123", name: "Test", password: "Pass1234", role: Role.user.rawValue)
        
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
                XCTAssert(false, "Timeout while attempting register")
            }
        }
    }
    
    func testRegisterInvalidPassword() throws {
        let exp = expectation(description: "Check Register Invalid Password")
        
        viewModel.register(email: "a1234@mail.com", name: "Test", password: "asd", role: Role.user.rawValue)
        
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
                XCTAssert(false, "Timeout while attempting register")
            }
        }
    }
    
    func testRegisterEmptyRole() throws {
        let exp = expectation(description: "Check Register Empty Role")
        
        viewModel.register(email: "a124@mail.com", name: "Test", password: "asd", role: "")
        
        // Assert
        viewModel.state.observe(on: self) { state in
            if state != ActionState.waiting {
                XCTAssertEqual(self.viewModel.state.value, ActionState.fail)
                XCTAssertEqual(self.viewModel.error.value, "The role field is required.")
                
                exp.fulfill()
            }
        }
        
        waitForExpectations(timeout: 4.0) {
            error in
            if let _ = error {
                XCTAssert(false, "Timeout while attempting register")
            }
        }
    }
    
    func testRegisterSuccess() throws {
        let exp = expectation(description: "Check Register Success")
        
        viewModel.register(email: "a126@mail.com", name: "Test", password: "Pass1234", role: Role.user.rawValue)
        
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
                XCTAssert(false, "Timeout while attempting register")
            }
        }
    }
    
}

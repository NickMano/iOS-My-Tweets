//
//  RegisterViewModelTest.swift
//  MyTweetsTests
//
//  Created by Nicolas Manograsso on 04/08/2021.
//

import XCTest
@testable import MyTweets

final class RegisterViewModelTest: XCTestCase {
    var sut: RegisterViewModel!
    
    override func setUpWithError() throws {
        sut = RegisterViewModel(repository: UserRepositorySuccesfulMock())
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testValidForm() {
        let value = sut.isValidForm(userName: "user", password: "pass", email: "email")
        
        XCTAssertTrue(value.isValid)
        XCTAssertNil(value.error)
    }
    
    func testEmptyForm() {
        let value = sut.isValidForm(userName: "", password: "", email: "")
        
        XCTAssertFalse(value.isValid)
        XCTAssertEqual(value.error, .allFields)
    }
    
    func testEmptyUserName() {
        let value = sut.isValidForm(userName: "", password: "pass", email: "email")
        
        XCTAssertFalse(value.isValid)
        XCTAssertEqual(value.error, .someField)
    }
    
    func testEmptyPassword() {
        let value = sut.isValidForm(userName: "user", password: "", email: "email")
        
        XCTAssertFalse(value.isValid)
        XCTAssertEqual(value.error, .someField)
    }
    
    func testEmptyEmail() {
        let value = sut.isValidForm(userName: "user", password: "pass", email: "")
        
        XCTAssertFalse(value.isValid)
        XCTAssertEqual(value.error, .someField)
    }
    
    func testErrorForm() {
        let value = sut.isValidForm(userName: nil, password: "pass", email: "")
        
        XCTAssertFalse(value.isValid)
        XCTAssertEqual(value.error, .generic)
    }
    
    func testGetPostsWithError() {
        sut = RegisterViewModel(repository: UserRepositoryErrorMock())
        let request = RegisterRequest(email: "email", password: "pass", names: "user")
        
        var onError = false
        var onSuccess = false
        
        sut.register(request) {_ in
            onError = true
        } onSuccess: {
            onSuccess = true
        }
       
        XCTAssertFalse(onSuccess)
        XCTAssertTrue(onError)
    }
    
    func testGetPostsSuccesful() {
        let request = RegisterRequest(email: "email", password: "pass", names: "user")
        
        var onError = false
        var onSuccess = false
        
        sut.register(request) { _ in
            onError = true
        } onSuccess: {
            onSuccess = true
        }
        
        XCTAssertTrue(onSuccess)
        XCTAssertFalse(onError)
    }
}

//
//  StoreTests.swift
//  2FTests
//
//  Created by Javier Matusevich on 29/12/2017.
//  Copyright © 2017 Javier Matusevich. All rights reserved.
//

import XCTest
import OneTimePassword
@testable import _F


class StoreTests: XCTestCase {
    
    static let oldValidURL = "otpauth://totp/Google%3Ajaviermatusevich%40gmail.com?secret=ts54hhurdmpijxa2hc64mltd6irze3ar&issuer=Google"
    static let invalidURL = "http://sdfsdf.com"
    
    var store : OTPStore?
    override func setUp() {
        super.setUp()
        store = OTPStore()
        store!.clearAllItems()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        store = nil
        super.tearDown()
    }
    
    func testEmptyList() {
        XCTAssertNotNil(store)
        let response = store!.listTokens()
        XCTAssertEqual(response.count, 0)
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testList() {
        XCTAssertNotNil(store)
        let response = store!.listTokens()
        XCTAssertEqual(response.count, 0)
        let validURL = URL(string: StoreTests.oldValidURL)
        XCTAssertNotNil(validURL)
        let newToken = store!.addToken(otpURL: validURL!)
        XCTAssertNotNil(newToken)
        sleep(4)
        let newResponse = store!.listTokens()
        XCTAssertEqual(newResponse.count, 1)
        let removeResult = store!.removeToken(token: newToken!)
        XCTAssert(removeResult)
        let finalResponse = store!.listTokens()
        XCTAssertEqual(finalResponse.count, 0)
    }
    
    func testInvalidURL() {
        XCTAssertNotNil(store)
        let response = store!.listTokens()
        XCTAssertEqual(response.count, 0)
        let invalidURL = URL(string: StoreTests.invalidURL)
        XCTAssertNotNil(invalidURL)
        let newToken = store!.addToken(otpURL: invalidURL!)
        XCTAssertNil(newToken)
        sleep(4)
        let secondResponse = store!.listTokens()
        XCTAssertEqual(secondResponse.count, 0)
    }
    
    func testValidURL() {
        XCTAssertNotNil(store)
        let response = store!.listTokens()
        XCTAssertEqual(response.count, 0)
        let validURL = URL(string: StoreTests.oldValidURL)
        XCTAssertNotNil(validURL)
        let newToken = store!.addToken(otpURL: validURL!)
        XCTAssertNotNil(newToken)
        sleep(4)
        let secondResponse = store!.listTokens()
        XCTAssertEqual(secondResponse.count, 1)
    }
    
    func testPasswordGenerator() {
        XCTAssertNotNil(store)
        let response = store!.listTokens()
        XCTAssertEqual(response.count, 0)
        let validURL = URL(string: StoreTests.oldValidURL)
        XCTAssertNotNil(validURL)
        let newToken = store!.addToken(otpURL: validURL!)
        XCTAssertNotNil(newToken)
        // TODO: Test password at known time
        do {
            let passwordAtTime = try newToken!.generator.password(at: Date(timeIntervalSince1970: 1514563624))
            print("Password at time: \(passwordAtTime)")
            XCTAssertEqual("099355", passwordAtTime)
        } catch {
            print("Cannot generate password for invalid time \(time)")
            print("error: \(error)")
            XCTFail()
        }
    }
    
    func testSavePerformance() {
        XCTAssertNotNil(store)
        let response = store!.listTokens()
        XCTAssertEqual(response.count, 0)
        let validURL = URL(string: StoreTests.oldValidURL)
        XCTAssertNotNil(validURL)
        // This is an example of a performance test case.
        self.measure {
            let newToken = store!.addToken(otpURL: validURL!)
            XCTAssertNotNil(newToken)
            // Put the code you want to measure the time of here.
        }
    }
    
}

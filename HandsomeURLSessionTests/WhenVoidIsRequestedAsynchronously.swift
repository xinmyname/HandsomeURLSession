//
//  WhenATextRequstIsMadeAsynchronously.swift
//  HandsomeURLSession
//
//  Created by Andy Sherwood on 7/21/16.
//
//

import XCTest
import HandsomeURLSession

class WhenVoidIsRequestedAsynchronously: XCTestCase {

    let _request = URLRequest(url: URL(string:"http://atp.fm/feedback")!)
    
    func testThatHTTPStatusCodeIsInResponseWithoutError() {
        
        let expectedStatusCode = 300
        let session = MockURLSession(for: _request, statusCode:expectedStatusCode)
        let exp = expectation(description: "")
        
        let task = session.textTask(with: _request) { (text:String?, response:HTTPURLResponse?, error:NSError?) in
            
            XCTAssertEqual(response?.statusCode, expectedStatusCode)
            XCTAssertNil(error)
            exp.fulfill()
        }
        
        task.resume()
        
        waitForExpectations(timeout: 2)
    }

    func testThatNoResponseYieldsAnError() {
        
        let session = MockURLSession(response: nil)
        let exp = expectation(description: "")
        
        let task = session.textTask(with: _request) { (text:String?, response:HTTPURLResponse?, error:NSError?) in
            
            XCTAssertNil(response)
            XCTAssertNotNil(error)
            exp.fulfill()
        }
        
        task.resume()
        
        waitForExpectations(timeout: 2)
    }
}

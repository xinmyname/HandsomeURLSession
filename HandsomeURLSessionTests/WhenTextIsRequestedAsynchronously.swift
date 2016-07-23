//
//  WhenATextRequstIsMadeAsynchronously.swift
//  HandsomeURLSession
//
//  Created by Andy Sherwood on 7/21/16.
//
//

import XCTest
import HandsomeURLSession

class WhenTextIsRequestedAsynchronously: XCTestCase {

    let _request = URLRequest(url: URL(string:"http://marco.coffee")!)
    let _text = "Casey was right."
    
    func testThatTheTextMatches() {
        
        let session = MockURLSession(for: _request, text:_text)
        let exp = expectation(description: "")
        
        let task = session.textTask(with: _request) { (text:String?, response:HTTPURLResponse?, error:NSError?) in
            
            XCTAssertEqual(text, self._text)
            exp.fulfill()
        }
        
        task.resume()
        
        waitForExpectations(timeout: 2)
    }

    func testThatFailedHTTPStatusCodesAreInResponseWithoutError() {
        
        let expectedStatusCode = 404
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

//
//  WhenATextRequstIsMadeAsynchronously.swift
//  HandsomeURLSession
//
//  Created by Andy Sherwood on 7/21/16.
//
//

import XCTest
import HandsomeURLSession

class WhenJsonIsRequestedAsynchronously: XCTestCase {

    let _request = URLRequest(url: URL(string:"http://marco.org")!)
    let _jsonText = "{\"relatedTo\":[\"Tiff\",\"Adam\",\"Hops\",\"Some Ducks\"]}"
    
    func testThatTheJsonMatches() {
        
        let session = MockURLSession(for: _request, jsonText:_jsonText)
        let exp = expectation(description: "")
        
        let task = session.jsonTask(with: _request) { (json:Any?, response:HTTPURLResponse?, error:Error?) in
            
            guard let json = json else {
                XCTFail()
                return
            }
            
            let jsonData = try! JSONSerialization.data(withJSONObject: json, options: [])
            let jsonText = String(data: jsonData, encoding: .utf8)
            
            XCTAssertEqual(jsonText, self._jsonText)
            exp.fulfill()
        }
        
        task.resume()
        
        waitForExpectations(timeout: 2)
    }

    func testThatFailedHTTPStatusCodeIsInResponse() {
        
        let expectedStatusCode = 404
        let session = MockURLSession(for: _request, statusCode:expectedStatusCode)
        let exp = expectation(description: "")
        
        let task = session.jsonTask(with: _request) { (json:Any?, response:HTTPURLResponse?, error:Error?) in
            
            XCTAssertNil(json)
            XCTAssertEqual(response?.statusCode, expectedStatusCode)
            exp.fulfill()
        }
        
        task.resume()
        
        waitForExpectations(timeout: 2)
    }

    func testThatNoResponseYieldsAnError() {
        
        let session = MockURLSession(response: nil)
        let exp = expectation(description: "")
        
        let task = session.jsonTask(with: _request) { (json:Any?, response:HTTPURLResponse?, error:Error?) in
            
            XCTAssertNil(json)
            XCTAssertNil(response)
            XCTAssertNotNil(error)
            exp.fulfill()
        }
        
        task.resume()
        
        waitForExpectations(timeout: 2)
    }
}

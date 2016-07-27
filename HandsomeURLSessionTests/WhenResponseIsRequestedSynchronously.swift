//
//  WhenATextRequstIsMadeAsynchronously.swift
//  HandsomeURLSession
//
//  Created by Andy Sherwood on 7/21/16.
//
//

import XCTest
import HandsomeURLSession

class WhenResponseIsRequestedSynchronously: XCTestCase {

    let _request = URLRequest(url: URL(string:"http://caseyliss.com")!)
    
    func testThatTheDataMatches() {
        
        let session = MockURLSession(for: _request, statusCode:222)
        let response:HTTPURLResponse = try! session.awaitResponse(with: _request)
        
        XCTAssertEqual(response.statusCode, 222)
    }

    func testThatNoResponseThrowsException() {
        
        let session = MockURLSession(response: nil)
        
        XCTAssertThrowsError(try session.awaitResponse(with: _request))
    }
    
}

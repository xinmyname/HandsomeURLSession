//
//  WhenATextRequstIsMadeAsynchronously.swift
//  HandsomeURLSession
//
//  Created by Andy Sherwood on 7/21/16.
//
//

import XCTest
import HandsomeURLSession

class WhenTextIsRequestedSynchronously: XCTestCase {

    let _request = URLRequest(url: URL(string:"http://marco.coffee")!)
    let _text = "Casey was right."
    
    func testThatTheTextMatches() {
        
        let session = MockURLSession(for: _request, text:_text)
        
        XCTAssertEqual(try! session.awaitText(with: _request), _text)
    }

    func testThatFailedHTTPStatusCodeThrowsException() {
        
        let session = MockURLSession(for: _request, statusCode: 404)
        
        XCTAssertThrowsError(try session.awaitText(with: _request))
    }

    func testThatNoResponseThrowsException() {
        
        let session = MockURLSession(response: nil)
        
        XCTAssertThrowsError(try session.awaitText(with: _request))
    }
    
}

//
//  WhenATextRequstIsMadeAsynchronously.swift
//  HandsomeURLSession
//
//  Created by Andy Sherwood on 7/21/16.
//
//

import XCTest
import HandsomeURLSession

class WhenVoidIsRequestedSynchronously: XCTestCase {

    let _request = URLRequest(url: URL(string:"http://atp.fm/feedback")!)
    
    func testThatSuccessfulHTTPStatusCodeDoesntThrowException() {
        
        let session = MockURLSession(for: _request, statusCode: 200)
        
        try! session.awaitVoid(with: _request)
    }

    func testThatFailedHTTPStatusCodeThrowsException() {
        
        let session = MockURLSession(for: _request, statusCode: 404)
        
        XCTAssertThrowsError(try session.awaitVoid(with: _request))
    }

    func testThatNoResponseThrowsException() {
        
        let session = MockURLSession(response: nil)
        
        XCTAssertThrowsError(try session.awaitVoid(with: _request))
    }
    
}

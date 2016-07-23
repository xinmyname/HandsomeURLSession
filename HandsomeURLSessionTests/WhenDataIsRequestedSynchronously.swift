//
//  WhenATextRequstIsMadeAsynchronously.swift
//  HandsomeURLSession
//
//  Created by Andy Sherwood on 7/21/16.
//
//

import XCTest
import HandsomeURLSession

class WhenDataIsRequestedSynchronously: XCTestCase {

    let _request = URLRequest(url: URL(string:"http://hypercritical.co")!)
    let _data = Data(base64Encoded: "Q2Fub25pY2FsIGJhZ2Vscw==")
    
    func testThatTheDataMatches() {
        
        let session = MockURLSession(for: _request, data:_data)
        
        XCTAssertEqual(try! session.awaitData(with: _request), _data)
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

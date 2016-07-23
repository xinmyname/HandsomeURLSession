//
//  WhenATextRequstIsMadeAsynchronously.swift
//  HandsomeURLSession
//
//  Created by Andy Sherwood on 7/21/16.
//
//

import XCTest
import HandsomeURLSession

class WhenJsonIsRequestedSynchronously: XCTestCase {

    let _request = URLRequest(url: URL(string:"http://marco.org")!)
    let _jsonText = "{\"relatedTo\":[\"Tiff\",\"Adam\",\"Hops\",\"Some Ducks\"]}"
    
    func testThatTheTextMatches() {
        
        let session = MockURLSession(for: _request, jsonText: _jsonText)
        let json = try! session.awaitJson(with: _request)
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: [])
        let jsonText = String(data: jsonData, encoding: .utf8)
        
        XCTAssertEqual(jsonText, _jsonText)
    }

    func testThatFailedHTTPStatusCodeThrowsException() {
        
        let session = MockURLSession(for: _request, statusCode: 404)
        
        XCTAssertThrowsError(try session.awaitJson(with: _request))
    }

    func testThatNoResponseThrowsException() {
        
        let session = MockURLSession(response: nil)
        
        XCTAssertThrowsError(try session.awaitJson(with: _request))
    }
    
}

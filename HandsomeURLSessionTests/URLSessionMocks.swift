//
//  URLSessionMocks.swift
//  HandsomeURLSession
//
//  Created by Andy Sherwood on 7/21/16.
//
//

import Foundation

class MockURLSessionDataTask: URLSessionDataTask {

    private let _request:URLRequest
    private let _response:MockResponse?
    private let _queue:DispatchQueue
    private let _completionHandler: (Data?, URLResponse?, NSError?) -> Void
    
    init(request:URLRequest, response:MockResponse?, queue:DispatchQueue, completionHandler: (Data?, URLResponse?, NSError?) -> Void) {
        _request = request
        _response = response
        _queue = queue
        _completionHandler = completionHandler
    }
    
    override func resume() {
        
        _queue.async {
            
            guard let response = self._response else {
                let error = NSError(domain: "NSURLErrorDomain", code: -1003, userInfo: [NSLocalizedDescriptionKey:"A server with the specified hostname could not be found."])
                self._completionHandler(nil, nil, error)
                return
            }

            self._completionHandler(response.data, response.urlResponse, nil)
        }
    }
}

class MockURLSession: URLSession {

    private let _queue = DispatchQueue(label: "MockURLSession")
    private var _response:MockResponse?
    
    init(response:MockResponse?) {
        _response = response
    }
    
    override func dataTask(with request: URLRequest, completionHandler: (Data?, URLResponse?, NSError?) -> Void) -> URLSessionDataTask {
        return MockURLSessionDataTask(request:request, response:_response, queue:_queue, completionHandler:completionHandler)
    }
    
    func sends(_ response:MockResponse) {
        _response = response
    }
}

class MockResponse {
    
    var data:Data?
    var urlResponse:URLResponse?
    
    init(request:URLRequest, data:Data) {
        self.data = data
        self.urlResponse = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: [:])
    }
    
    init(request:URLRequest, text:String) {
        self.data = text.data(using: .utf8)
        self.urlResponse = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: [:])
    }
    
    init(request:URLRequest, statusCode:Int) {
        let errorText = HTTPURLResponse.localizedString(forStatusCode: statusCode)
        self.data = "<html><body><h1>\(statusCode) \(errorText)</h1></body></html>".data(using: .utf8)
        self.urlResponse = HTTPURLResponse(url: request.url!, statusCode: statusCode, httpVersion: "HTTP/1.1", headerFields: [:])
    }
}


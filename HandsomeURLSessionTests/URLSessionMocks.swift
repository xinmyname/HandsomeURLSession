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
    private let _completionHandler: (Data?, URLResponse?, Error?) -> Void
    
    init(request:URLRequest, response:MockResponse?, queue:DispatchQueue, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
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
    
    convenience init(for request:URLRequest, statusCode:Int) {
        self.init(response: MockResponse(request:request, statusCode:statusCode))
    }

    convenience init(for request:URLRequest, text:String?) {
        let data = text?.data(using: .utf8)
        self.init(response: MockResponse(request:request, data:data))
    }

    convenience init(for request:URLRequest, jsonText:String?) {
        let data = jsonText?.data(using: .utf8)
        self.init(response: MockResponse(request:request, data:data))
    }
    
    convenience init(for request:URLRequest, data:Data?) {
        self.init(response: MockResponse(request:request, data:data))
    }
    
    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return MockURLSessionDataTask(request:request, response:_response, queue:_queue, completionHandler:completionHandler)
    }
    
    func sends(_ response:MockResponse) {
        _response = response
    }
}

class MockResponse {
    
    var data:Data?
    var urlResponse:URLResponse?
    
    init(request:URLRequest, data:Data?) {
        self.data = data
        self.urlResponse = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: [:])
    }
    
    init(request:URLRequest, statusCode:Int) {
        let errorText = HTTPURLResponse.localizedString(forStatusCode: statusCode)
        self.data = "<html><body><h1>\(statusCode) \(errorText)</h1></body></html>".data(using: .utf8)
        self.urlResponse = HTTPURLResponse(url: request.url!, statusCode: statusCode, httpVersion: "HTTP/1.1", headerFields: [:])
    }
}


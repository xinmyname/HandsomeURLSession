//
//  AwaitNSURLSession.swift
//  PhotoMon
//
//  Created by Andy Sherwood on 4/19/16.
//  Copyright © 2016 Clean Water Services. All rights reserved.
//


public extension NSURLSession {
    
    public enum UTF8Decoding : ErrorType { case error }
    public enum ImageDecoding : ErrorType { case error }
    
    public class HttpResponse : ErrorType {
        public let _domain: String
        public let _code: Int
        
        init(code: Int) {
            _domain = "NSHTTPURLResponse"
            _code = code
        }
    }
    
    public func voidTaskWithURL(url:NSURL, completionHandler:(NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {
        
        return self.dataTaskWithURL(url, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) in
            completionHandler(response, error)
        })
    }
    
    public func voidTaskWithRequest(request:NSURLRequest, completionHandler:(NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {
        
        return self.dataTaskWithRequest(request, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) in
            completionHandler(response, error)
        })
    }
    
    
    public func jsonTaskWithURL(url:NSURL, completionHandler:(AnyObject?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {
        
        return self.dataTaskWithURL(url, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) in
            
            if let data = data {
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                    completionHandler(json, response, error)
                }
                catch let error as NSError {
                    completionHandler(nil, response, error)
                }
            } else {
                completionHandler(data, response, error)
            }
        })
    }
    
    public func jsonTask(request:NSURLRequest, completionHandler:(AnyObject?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {
        
        return self.dataTaskWithRequest(request, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) in
            
            if let data = data {
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                    completionHandler(json, response, error)
                }
                catch let error as NSError {
                    completionHandler(nil, response, error)
                }
            } else {
                completionHandler(data, response, error)
            }
        })
    }
    
    
    public func textTaskWithURL(url:NSURL, completionHandler:(String?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {
        
        return self.dataTaskWithURL(url, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) in
            
            if let data = data {
                completionHandler(String(data: data, encoding: NSUTF8StringEncoding), response, error)
            } else {
                completionHandler(nil, response, error)
            }
        })
    }
    
    public func textTask(request:NSURLRequest, completionHandler:(String?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {
        
        return self.dataTaskWithRequest(request, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) in
            
            if let data = data {
                completionHandler(String(data: data, encoding: NSUTF8StringEncoding), response, error)
            } else {
                completionHandler(nil, response, error)
            }
        })
    }
    
    public func imageTaskWithURL(url:NSURL, completionHandler:(UIImage?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {
        
        return self.dataTaskWithURL(url, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) in
            
            if let data = data {
                completionHandler(UIImage(data: data), response, error)
            } else {
                completionHandler(nil, response, error)
            }
        })
    }
    
    public func imageTask(request:NSURLRequest, completionHandler:(UIImage?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {
        
        return self.dataTaskWithRequest(request, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) in
            
            if let data = data {
                completionHandler(UIImage(data: data), response, error)
            } else {
                completionHandler(nil, response, error)
            }
        })
    }
    
    public func xmlTaskWithURL(url:NSURL, completionHandler:(NSXMLParser?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {
        
        return self.dataTaskWithURL(url, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) in
            
            if let data = data {
                completionHandler(NSXMLParser(data: data), response, error)
            } else {
                completionHandler(nil, response, error)
            }
        })
    }
    
    public func xmlTask(request:NSURLRequest, completionHandler:(NSXMLParser?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {
        
        return self.dataTaskWithRequest(request, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) in
            
            if let data = data {
                completionHandler(NSXMLParser(data: data), response, error)
            } else {
                completionHandler(nil, response, error)
            }
        })
    }
    
    
    public func awaitVoid(forRequest request:NSURLRequest) throws -> Void {
        
        let sem: dispatch_semaphore_t = dispatch_semaphore_create(0)
        var resError:NSError?
        var resStatusCode:Int?
        
        let task = self.dataTaskWithRequest(request) { (data:NSData?, response:NSURLResponse?, error:NSError?) in
            
            resError = error
            
            if let response = response as? NSHTTPURLResponse {
                resStatusCode = response.statusCode
            }
            
            dispatch_semaphore_signal(sem)
        }
        
        task.resume()
        
        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER)
        
        if let resStatusCode = resStatusCode {
            
            if resStatusCode < 200 || resStatusCode >= 300 {
                throw HttpResponse(code: resStatusCode)
            }
        }
        
        if resError != nil {
            throw resError!
        }
    }
    
    public func awaitData(forRequest request:NSURLRequest) throws -> NSData {
        
        let sem: dispatch_semaphore_t = dispatch_semaphore_create(0)
        var resData:NSData?
        var resError:NSError?
        var resStatusCode:Int?
        
        let task = self.dataTaskWithRequest(request) { (data:NSData?, response:NSURLResponse?, error:NSError?) in
            
            resData = data
            resError = error
            
            if let response = response as? NSHTTPURLResponse {
                resStatusCode = response.statusCode
            }
            
            dispatch_semaphore_signal(sem)
        }
        
        task.resume()
        
        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER)
        
        if let resStatusCode = resStatusCode {
            
            if resStatusCode < 200 || resStatusCode >= 300 {
                throw HttpResponse(code: resStatusCode)
            }
        }
        
        guard let data = resData else {
            throw resError!
        }
        
        return data
    }
    
    public func awaitText(forRequest request:NSURLRequest) throws -> String {
        
        let data = try self.awaitData(forRequest:request)
        
        guard let text = String(data: data, encoding: NSUTF8StringEncoding) else {
            throw UTF8Decoding.error
        }
        
        return text
    }
    
    public func awaitJson(forRequest request:NSURLRequest) throws -> AnyObject {
        
        let data = try self.awaitData(forRequest:request)
        
        return try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
    }
    
    public func awaitImage(forRequest request:NSURLRequest) throws -> UIImage {
        
        let data = try self.awaitData(forRequest:request)
        
        guard let image = UIImage(data: data) else {
            throw ImageDecoding.error
        }
        
        return image
    }
    
    public func awaitXml(forRequest request:NSURLRequest) throws -> NSXMLParser {
        
        let data = try self.awaitData(forRequest:request)
        
        return NSXMLParser(data: data)
    }
}


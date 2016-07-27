//
//  HandsomeURLSession.h
//  HandsomeURLSession
//
//  MIT License
//
//  Copyright (c) 2016 Andy Sherwood
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

#import <Foundation/Foundation.h>

#include "TargetConditionals.h"
#if TARGET_OS_IOS || TARGET_OS_WATCH || TARGET_OS_TV
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
#endif

FOUNDATION_EXPORT double HandsomeURLSession_VersionNumber;
FOUNDATION_EXPORT const unsigned char HandsomeURLSession_VersionString[];

/**

 This extension to NSURLSession gives you typed responses from HTTP requests, both asynchronous and synchronous. Exceptions are thrown if an error occurs.
 
 Assumptions: 
 * All requests are HTTP, responses are cast to `NSHTTPURLResponse`
 * All text is decoded as UTF8
 
 The following typed responses are supported:
 
 * Text : `String`
 * JSON : `[String:AnyObject]`
 * Data : `NSData`
 * Images : `UIImage` or `NSImage`
 * XML : `NSXMLParser`
 
 */
@interface NSURLSession(Handsome)

/**
 Makes a task to send data to a URL, without expecting a body in the response.
 
 @param request Includes URL, HTTP method, body, headers, etc.
 @param completionHandler Called when the request is complete, with or without an error. If you pass nil, you'll need to use a delegate.
 @returns A session data task - make sure you call `resume` on this object to start the task.
 */
- (NSURLSessionDataTask* _Nonnull)voidTaskWithRequest:(NSURLRequest* _Nonnull)request
                                    completionHandler:(void (^ _Nonnull)(NSHTTPURLResponse* _Nullable, NSError* _Nullable))completionHandler;

/**
 Makes a task to request UTF8 text from a URL and, upon success, converts the response body to an `NSString`.
 
 @param request Includes URL, HTTP method, body, headers, etc.
 @param completionHandler Called when the request is complete, with or without an error. If you pass nil, you'll need to use a delegate.
 @returns A session data task - make sure you call `resume` on this object to start the task.
 */
- (NSURLSessionDataTask* _Nonnull)textTaskWithRequest:(NSURLRequest* _Nonnull)request
                                    completionHandler:(void (^ _Nonnull)(NSString* _Nullable, NSHTTPURLResponse* _Nullable, NSError* _Nullable))completionHandler;

/**
 Makes a task to request JSON from a URL and, upon success, converts the response body to a Foundation object, `NSDictionary` or `NSArray`.
 
 @param request Includes URL, HTTP method, body, headers, etc.
 @param completionHandler Called when the request is complete, with or without an error. If you pass nil, you'll need to use a delegate.
 @returns A session data task - make sure you call `resume` on this object to start the task.
 */
- (NSURLSessionDataTask* _Nonnull)jsonTaskWithRequest:(NSURLRequest* _Nonnull)request
                                    completionHandler:(void (^ _Nonnull)(id _Nullable, NSHTTPURLResponse* _Nullable, NSError* _Nullable))completionHandler;

/**
 Makes a task to request XML from a URL and, upon success, prepares an `NSXMLParser` with the response body. It is the caller's responsibility to attach an `NSXMLParserDelegate` and call the `parse` method.
 
 @param request Includes URL, HTTP method, body, headers, etc.
 @param completionHandler Called when the request is complete, with or without an error. If you pass nil, you'll need to use a delegate.
 @returns A session data task - make sure you call `resume` on this object to start the task.
 */
- (NSURLSessionDataTask* _Nonnull)xmlTaskWithRequest:(NSURLRequest* _Nonnull)request
                                   completionHandler:(void (^ _Nonnull)(NSXMLParser* _Nullable, NSHTTPURLResponse* _Nullable, NSError* _Nullable))completionHandler;

#if TARGET_OS_IOS || TARGET_OS_WATCH || TARGET_OS_TV
/**
 Makes a task to request an image from a URL and, upon success, converts the response body to a `UIImage` instance.
 
 @param request Includes URL, HTTP method, body, headers, etc.
 @param completionHandler Called when the request is complete, with or without an error. If you pass nil, you'll need to use a delegate.
 @returns A session data task - make sure you call `resume` on this object to start the task.
 */
- (NSURLSessionDataTask* _Nonnull)imageTaskWithRequest:(NSURLRequest* _Nonnull)request
                                     completionHandler:(void (^ _Nonnull)(UIImage* _Nullable, NSHTTPURLResponse* _Nullable, NSError* _Nullable))completionHandler;
#else
/**
 Makes a task to send data to a URL and, upon success, converts the response body to an `NSImage` instance.
 
 @param request Includes URL, HTTP method, body, headers, etc.
 @param completionHandler Called when the request is complete, with or without an error. If you pass nil, you'll need to use a delegate.
 @returns A session data task - make sure you call `resume` on this object to start the task.
 */
- (NSURLSessionDataTask* _Nonnull)imageTaskWithRequest:(NSURLRequest* _Nonnull)request
                                     completionHandler:(void (^ _Nonnull)(NSImage* _Nullable, NSHTTPURLResponse* _Nullable, NSError* _Nullable))completionHandler;
#endif

/**
 Synchronously sends a request to a URL and returns data.
 
 @param request Includes URL, HTTP method, body, headers, etc.
 @param error `nil` if successful, otherwise an `NSError` object with information about the error.
 @returns An instance of `NSData` if successful, otherwise `nil`.
 */
- (NSData* _Nullable)awaitDataWithRequest:(NSURLRequest* _Nonnull)request
                                    error:(NSError* _Nullable * _Null_unspecified)error;

/**
 Synchronously sends a request to a URL.
 
 @param request Includes URL, HTTP method, body, headers, etc.
 @param error `nil` if successful, otherwise an `NSError` object with information about the error.
 @returns YES if successful, otherwise NO.
 */
- (BOOL)awaitVoidWithRequest:(NSURLRequest* _Nonnull)request
                       error:(NSError* _Nullable * _Null_unspecified)error;

/**
 Synchronously sends a request to a URL.
 
 @param request Includes URL, HTTP method, body, headers, etc.
 @param error `nil` if successful, otherwise an `NSError` object with information about the error.
 @returns YES if successful, otherwise NO.
 */
- (NSHTTPURLResponse* _Nullable)awaitResponseWithRequest:(NSURLRequest* _Nonnull)request
                                                   error:(NSError* _Nullable * _Null_unspecified)error;


/**
 Synchronously sends a request to a URL and returns UTF8 text.
 
 @param request Includes URL, HTTP method, body, headers, etc.
 @param error `nil` if successful, otherwise an `NSError` object with information about the error.
 @returns An instance of `NSString` decoded as UTF-8 if successful, otherwise `nil`.
 */
- (NSString* _Nullable)awaitTextWithRequest:(NSURLRequest* _Nonnull)request
                                      error:(NSError* _Nullable * _Null_unspecified)error;

/**
 Synchronously sends a request to a URL and returns JSON as a Foundation object, `NSDictionary` or `NSArray`.
 
 @param request Includes URL, HTTP method, body, headers, etc.
 @param error `nil` if successful, otherwise an `NSError` object with information about the error.
 @returns A Foundation object, `NSDictionary` or `NSArray` if successful, otherwise `nil`.
 */
- (id _Nullable)awaitJsonWithRequest:(NSURLRequest* _Nonnull)request
                               error:(NSError* _Nullable * _Null_unspecified)error;

/**
 Synchronously sends a request to a URL and returns an XML parser.
 
 @param request Includes URL, HTTP method, body, headers, etc.
 @param error `nil` if successful, otherwise an `NSError` object with information about the error.
 @returns An instance of `NSXMLParser` if successful, otherwise `nil`.
 */
- (NSXMLParser* _Nullable)awaitXmlWithRequest:(NSURLRequest* _Nonnull)request
                                        error:(NSError* _Nullable * _Null_unspecified)error;

#if TARGET_OS_IOS || TARGET_OS_WATCH || TARGET_OS_TV
/**
 Synchronously sends a request to a URL and returns an image.
 
 @param request Includes URL, HTTP method, body, headers, etc.
 @param error `nil` if successful, otherwise an `NSError` object with information about the error.
 @returns An instance of `UIImage` if successful, otherwise `nil`.
 */
- (UIImage* _Nullable)awaitImageWithRequest:(NSURLRequest* _Nonnull)request
                                      error:(NSError* _Nullable * _Null_unspecified)error;
#else
/**
 Synchronously sends a request to a URL and returns an image.
 
 @param request Includes URL, HTTP method, body, headers, etc.
 @param error `nil` if successful, otherwise an `NSError` object with information about the error.
 @returns An instance of `NSImage` if successful, otherwise `nil`.
 */
- (NSImage* _Nullable)awaitImageWithRequest:(NSURLRequest* _Nonnull)request
                                      error:(NSError* _Nullable * _Null_unspecified)error;
#endif

@end

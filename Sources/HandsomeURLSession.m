//
//  HandsomeURLSession.m
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

#import "HandsomeURLSession.h"

@implementation NSURLSession(Handsome)

// TESTED
- (NSURLSessionDataTask* _Nonnull)voidTaskWithRequest:(NSURLRequest* _Nonnull)request completionHandler:(void (^)(NSHTTPURLResponse* _Nullable, NSError* _Nullable))completionHandler
{
    return [self dataTaskWithRequest:request completionHandler:^(NSData* data, NSURLResponse* response, NSError* error) {
        completionHandler((NSHTTPURLResponse*)response, error);
    }];
}

// TESTED
- (NSURLSessionDataTask* _Nonnull)textTaskWithRequest:(NSURLRequest* _Nonnull)request completionHandler:(void (^)(NSString* _Nullable, NSHTTPURLResponse* _Nullable, NSError* _Nullable))completionHandler
{
    return [self dataTaskWithRequest:request completionHandler:^(NSData* data, NSURLResponse* response, NSError* error) {
        
        if (data != nil)
        {
            NSString* text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            completionHandler(text, (NSHTTPURLResponse*)response, error);
        }
        else
            completionHandler(nil, (NSHTTPURLResponse*)response, error);
    }];
}

- (NSURLSessionDataTask* _Nonnull)jsonTaskWithRequest:(NSURLRequest* _Nonnull)request completionHandler:(void (^)(id _Nullable, NSHTTPURLResponse* _Nullable, NSError* _Nullable))completionHandler
{
    return [self dataTaskWithRequest:request completionHandler:^(NSData* data, NSURLResponse* response, NSError* error) {
        
        if (data != nil)
        {
            NSError* jsonError = nil;
            id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
            
            if (json != nil)
                completionHandler(json, (NSHTTPURLResponse*)response, error);
            else
                completionHandler(nil, (NSHTTPURLResponse*)response, jsonError);
        }
        else
            completionHandler(nil, (NSHTTPURLResponse*)response, error);
    }];
}

- (NSURLSessionDataTask* _Nonnull)xmlTaskWithRequest:(NSURLRequest* _Nonnull)request completionHandler:(void (^)(NSXMLParser* _Nullable, NSHTTPURLResponse* _Nullable, NSError* _Nullable))completionHandler
{
    return [self dataTaskWithRequest:request completionHandler:^(NSData* data, NSURLResponse* response, NSError* error) {
        
        if (data != nil)
        {
            NSXMLParser* parser = [[NSXMLParser alloc] initWithData:data];
            completionHandler(parser, (NSHTTPURLResponse*)response, error);
        }
        else
            completionHandler(nil, (NSHTTPURLResponse*)response, error);
    }];
}

#if TARGET_OS_IOS || TARGET_OS_WATCH || TARGET_OS_TV
- (NSURLSessionDataTask* _Nonnull)imageTaskWithRequest:(NSURLRequest* _Nonnull)request completionHandler:(void (^ _Nonnull)(UIImage* _Nullable, NSHTTPURLResponse* _Nullable, NSError* _Nullable))completionHandler
{
    return [self dataTaskWithRequest:request completionHandler:^(NSData* data, NSURLResponse* response, NSError* error) {
        
        if (data != nil)
        {
            UIImage* image = [[UIImage alloc] initWithData:data];
            completionHandler(image, (NSHTTPURLResponse*)response, error);
        }
        else
            completionHandler(nil, (NSHTTPURLResponse*)response, error);
    }];
}
#else
- (NSURLSessionDataTask* _Nonnull)imageTaskWithRequest:(NSURLRequest* _Nonnull)request completionHandler:(void (^ _Nonnull)(NSImage* _Nullable, NSHTTPURLResponse* _Nullable, NSError* _Nullable))completionHandler
{
    return [self dataTaskWithRequest:request completionHandler:^(NSData* data, NSURLResponse* response, NSError* error) {
        
        if (data != nil)
        {
            NSImage* image = [[NSImage alloc] initWithData:data];
            completionHandler(image, (NSHTTPURLResponse*)response, error);
        }
        else
            completionHandler(nil, (NSHTTPURLResponse*)response, error);
    }];
}
#endif

// TESTED
- (NSData* _Nullable)awaitDataWithRequest:(NSURLRequest* _Nonnull)request error:(NSError* _Nullable * _Null_unspecified)error
{
    dispatch_semaphore_t sem = dispatch_semaphore_create(0);
    NSData* __block resData = nil;
    NSError* __block resError = nil;
    NSInteger __block resStatusCode = -1;
    
    NSURLSessionDataTask* task = [self dataTaskWithRequest:request completionHandler:^(NSData* c_data, NSURLResponse* c_response, NSError* c_error) {
        
        NSHTTPURLResponse* response = (NSHTTPURLResponse*)c_response;
        resStatusCode = [response statusCode];
        resData = c_data;
        resError = c_error;
        
        dispatch_semaphore_signal(sem);
    }];
    
    [task resume];
    
    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    
    if (resStatusCode < 200 || resStatusCode >= 300)
    {
        *error = [NSError errorWithDomain:@"NSHTTPURLResponse" code:resStatusCode userInfo:@{NSLocalizedDescriptionKey:@"Failed HTTP status code"}];
        return nil;
    }
    
    if (resData == nil)
    {
        *error = resError;
        return nil;
    }
    
    return resData;
}

// TESTED
- (BOOL)awaitVoidWithRequest:(NSURLRequest* _Nonnull)request error:(NSError* _Nullable * _Null_unspecified)error
{
    dispatch_semaphore_t sem = dispatch_semaphore_create(0);
    NSError* __block resError = nil;
    NSInteger __block resStatusCode = -1;
    
    NSURLSessionDataTask* task = [self dataTaskWithRequest:request completionHandler:^(NSData* c_data, NSURLResponse* c_response, NSError* c_error) {
        
        NSHTTPURLResponse* response = (NSHTTPURLResponse*)c_response;
        resStatusCode = [response statusCode];
        resError = c_error;
        
        dispatch_semaphore_signal(sem);
    }];
    
    [task resume];
    
    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    
    if (resStatusCode < 200 || resStatusCode >= 300)
    {
        *error = [NSError errorWithDomain:@"NSHTTPURLResponse" code:resStatusCode userInfo:@{NSLocalizedDescriptionKey:@"Failed HTTP status code"}];
        return NO;
    }
    
    *error = resError;
    
    return *error == nil;
}

// TESTED
- (NSHTTPURLResponse* _Nullable)awaitResponseWithRequest:(NSURLRequest* _Nonnull)request
                                                   error:(NSError* _Nullable * _Null_unspecified)error
{
    dispatch_semaphore_t sem = dispatch_semaphore_create(0);
    NSError* __block resError = nil;
    NSHTTPURLResponse* __block response = nil;
    
    NSURLSessionDataTask* task = [self dataTaskWithRequest:request completionHandler:^(NSData* c_data, NSURLResponse* c_response, NSError* c_error) {
        
        response = (NSHTTPURLResponse*)c_response;
        resError = c_error;
        
        dispatch_semaphore_signal(sem);
    }];
    
    [task resume];
    
    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    
    return response;
}

// TESTED
- (NSString* _Nullable)awaitTextWithRequest:(NSURLRequest* _Nonnull)request error:(NSError* _Nullable * _Null_unspecified)error
{
    NSData* data = [self awaitDataWithRequest:request error:error];
    
    if (data == nil)
        return nil;
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (id _Nullable)awaitJsonWithRequest:(NSURLRequest* _Nonnull)request error:(NSError* _Nullable * _Null_unspecified)error
{
    NSData* data = [self awaitDataWithRequest:request error:error];
    
    if (data == nil)
        return nil;
    
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:error];
}

- (NSXMLParser* _Nullable)awaitXmlWithRequest:(NSURLRequest* _Nonnull)request error:(NSError* _Nullable * _Null_unspecified)error
{
    NSData* data = [self awaitDataWithRequest:request error:error];
    
    if (data == nil)
        return nil;
    
    return [[NSXMLParser alloc] initWithData:data];
}

#if TARGET_OS_IOS || TARGET_OS_WATCH || TARGET_OS_TV
- (UIImage* _Nullable)awaitImageWithRequest:(NSURLRequest* _Nonnull)request error:(NSError* _Nullable * _Null_unspecified)error
{
    NSData* data = [self awaitDataWithRequest:request error:error];
    
    if (data == nil)
        return nil;
    
    return [[UIImage alloc] initWithData:data];
}
#else
- (NSImage* _Nullable)awaitImageWithRequest:(NSURLRequest* _Nonnull)request error:(NSError* _Nullable * _Null_unspecified)error
{
    NSData* data = [self awaitDataWithRequest:request error:error];
    
    if (data == nil)
        return nil;
    
    return [[NSImage alloc] initWithData:data];
}
#endif

@end

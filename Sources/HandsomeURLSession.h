//
//  HandsomeURLSession.h
//  HandsomeURLSession
//
//  Created by Andy Sherwood on 7/20/16.
//  Copyright © 2016 Clean Water Services. All rights reserved.
//

#import <Foundation/Foundation.h>

#include "TargetConditionals.h"
#if TARGET_OS_IOS || TARGET_OS_WATCH || TARGET_OS_TV
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
#endif

FOUNDATION_EXPORT double HandsomeURLSession_VersionNumber;
FOUNDATION_EXPORT const unsigned char HandsomeURLSession_VersionString[];

@interface NSURLSession(Handsome)

- (NSURLSessionDataTask* _Nonnull)voidTaskWithRequest:(NSURLRequest* _Nonnull)request completionHandler:(void (^ _Nonnull)(NSHTTPURLResponse* _Nullable, NSError* _Nullable))completionHandler;
- (NSURLSessionDataTask* _Nonnull)textTaskWithRequest:(NSURLRequest* _Nonnull)request completionHandler:(void (^ _Nonnull)(NSString* _Nullable, NSHTTPURLResponse* _Nullable, NSError* _Nullable))completionHandler;
- (NSURLSessionDataTask* _Nonnull)jsonTaskWithRequest:(NSURLRequest* _Nonnull)request completionHandler:(void (^ _Nonnull)(id _Nullable, NSHTTPURLResponse* _Nullable, NSError* _Nullable))completionHandler;
- (NSURLSessionDataTask* _Nonnull)xmlTaskWithRequest:(NSURLRequest* _Nonnull)request completionHandler:(void (^ _Nonnull)(NSXMLParser* _Nullable, NSHTTPURLResponse* _Nullable, NSError* _Nullable))completionHandler;

#if TARGET_OS_IOS || TARGET_OS_WATCH || TARGET_OS_TV
- (NSURLSessionDataTask* _Nonnull)imageTaskWithRequest:(NSURLRequest* _Nonnull)request completionHandler:(void (^ _Nonnull)(UIImage* _Nullable, NSHTTPURLResponse* _Nullable, NSError* _Nullable))completionHandler;
#else
- (NSURLSessionDataTask* _Nonnull)imageTaskWithRequest:(NSURLRequest* _Nonnull)request completionHandler:(void (^ _Nonnull)(NSImage* _Nullable, NSHTTPURLResponse* _Nullable, NSError* _Nullable))completionHandler;
#endif

- (NSData* _Nullable)awaitDataWithRequest:(NSURLRequest* _Nonnull)request error:(NSError* _Nullable * _Null_unspecified)error;
- (BOOL)awaitVoidWithRequest:(NSURLRequest* _Nonnull)request error:(NSError* _Nullable * _Null_unspecified)error;
- (NSString* _Nullable)awaitTextWithRequest:(NSURLRequest* _Nonnull)request error:(NSError* _Nullable * _Null_unspecified)error;
- (id _Nullable)awaitJsonWithRequest:(NSURLRequest* _Nonnull)request error:(NSError* _Nullable * _Null_unspecified)error;
- (NSXMLParser* _Nullable)awaitXmlWithRequest:(NSURLRequest* _Nonnull)request error:(NSError* _Nullable * _Null_unspecified)error;

#if TARGET_OS_IOS || TARGET_OS_WATCH || TARGET_OS_TV
- (UIImage* _Nullable)awaitImageWithRequest:(NSURLRequest* _Nonnull)request error:(NSError* _Nullable * _Null_unspecified)error;
#else
- (NSImage* _Nullable)awaitImageWithRequest:(NSURLRequest* _Nonnull)request error:(NSError* _Nullable * _Null_unspecified)error;
#endif

@end

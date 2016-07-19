//
//  HandsomeURLSession.h
//  HandsomeURLSession
//
//  Created by Andy Sherwood on 7/19/16.
//
//
#include "TargetConditionals.h"
#if TARGET_OS_IPHONE
    #import <UIKit/UIKit.h>
#elif TARGET_OS_SIMULATOR
    #import <UIKit/UIKit.h>
#elif TARGET_OS_MAC
    #import <Cocoa/Cocoa.h>
#endif

//! Project version number for HandsomeURLSession.
FOUNDATION_EXPORT double HandsomeURLSession_VersionNumber;

//! Project version string for HandsomeURLSession.
FOUNDATION_EXPORT const unsigned char HandsomeURLSession_VersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <HandsomeURLSession_iOS/PublicHeader.h>



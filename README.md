# HandsomeURLSession v1.0

This is a Swift extension to NSURLSession giving you typed responses from HTTP requests, both asynchronous and synchronous. Exceptions are thrown if an error occurs.

The following typed responses are supported:

* UTF8 Text : `String`
* JSON : `[String:AnyObject]`
* Data : `NSData`
* Images : `UIImage` or `NSImage`
* XML : `NSXMLParser`

## CocoaPods

Install HandsomeURLSession into your project using [CocoaPods](https://cocoapods.org).

    use_frameworks!
    pod 'HandsomeURLSession'

##Usage

1. Get an NSURLSession

    let session = NSURLSession.sharedSession()

2. Create an NSURLRequest instance for the data you want load

    let textRequest = NSURLRequest(URL: NSURL(string: "http://loripsum.net/api/plaintext")!)

3. Call NSURLSession for the type you are interested in, e.g. "text"

### Asynchronously

    let task = session.textTask(textRequest) { (text:String?, response:NSURLResponse?, error:NSError?) in
        // Do something interesting with text
        NSLog("\(text)")
    }

### Or synchronously...

    let text = try session.awaitText(forRequest:textRequest)

## Thanks

Shoutout to Basem Emara whose blog post got me started: [Creating Cross-Platform Swift Frameworks for iOS, watchOS, and tvOS via Carthage and CocoaPods](http://basememara.com/creating-cross-platform-swift-frameworks-ios-watchos-tvos-via-carthage-cocoapods/)


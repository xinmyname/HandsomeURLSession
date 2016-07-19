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

```swift
let session = NSURLSession.sharedSession()
```

2. Create an NSURLRequest instance for the data you want load

```swift
let textRequest = NSURLRequest(URL: NSURL(string: "http://loripsum.net/api/plaintext")!)
```

3. Call NSURLSession for the type you are interested in, e.g. "text"

### Asynchronously

```swift
let task = session.textTask(textRequest) { (text:String?, response:NSURLResponse?, error:NSError?) in
    // Do something interesting with text
    NSLog("\(text)")
}

task.resume()
```

### Or synchronously...

```swift
let text = try session.awaitText(forRequest:textRequest)
```

## Other Examples

### Loading JSON

```swift
do {
    let jsonRequest = NSURLRequest(URL: NSURL(string: "http://date.jsontest.com/")!)
    let jsonResult = try session.awaitJson(forRequest: jsonRequest)
    let date = jsonResult["date"]
    NSLog("\(date)")
}
catch let error as NSError {
    NSLog("JSON no bueño - \(error.localizedDescription)")
}
```

### POSTing data without content in the response

```swift
do {
    var voidRequest = NSMutableURLRequest(URL: NSURL(string: "https://mega.lotto/api")!)
    voidRequest.HTTPMethod = "POST"
    voidRequest.HTTPBody = try NSJSONSerialization.dataWithJSONObject([4,8,15,16,23,42], options: [])
    try session.awaitVoid(forRequest: voidRequest)
    print("OK")
}
catch let error as NSError {
    NSLog("Void no bueño - \(error.localizedDescription)")
}
```

### Loading XML

```swift
@objc
class WxParserDelegate : NSObject, NSXMLParserDelegate {

    private var _elements:[String] = []

    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        _elements.append(elementName)
    }

    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        _elements.removeLast()
    }

    func parser(parser: NSXMLParser, foundCharacters string: String) {
        let path = _elements.joinWithSeparator("/")
        if (path == "dwml/data/moreWeatherInformation") {
            NSLog("\(string)")
        }
    }
}

do {
    var xmlRequest = NSMutableURLRequest(URL: NSURL(string: "http://graphical.weather.gov/xml/sample_products/browser_interface/ndfdXMLclient.php?whichClient=NDFDgen&lat=38.99&lon=-77.01")!)
    var xmlParser = try session.awaitXml(forRequest: xmlRequest)
    let delegate = WxParserDelegate()
    xmlParser.delegate = delegate
    xmlParser.parse()
}
catch let error as NSError {
    NSLog("XML no bueño - \(error.localizedDescription)")
}
```

## Thanks

Shoutout to Basem Emara whose blog post got me started: [Creating Cross-Platform Swift Frameworks for iOS, watchOS, and tvOS via Carthage and CocoaPods](http://basememara.com/creating-cross-platform-swift-frameworks-ios-watchos-tvos-via-carthage-cocoapods/)


//
//  Aoyama.swift
//  Aoyama
//
//  Created by Dongri Jin on 5/31/15.
//  Copyright (c) 2015 Dongri Jin. All rights reserved.
//

import Foundation

public typealias AoyamaCompletionHandler = (NSURLResponse?, NSData?, NSError?) -> Void

public enum Method: String {
    case OPTIONS = "OPTIONS"
    case GET = "GET"
    case HEAD = "HEAD"
    case POST = "POST"
    case PUT = "PUT"
    case PATCH = "PATCH"
    case DELETE = "DELETE"
    case TRACE = "TRACE"
    case CONNECT = "CONNECT"
}

public class Aoyama: NSObject {
    
    class var sharedInstance : Aoyama {
        struct Static {
            static let instance : Aoyama = Aoyama()
        }
        return Static.instance
    }
    
    public var baseURL: String?
    public var url: NSURL?
    public var method: String?
    public var headers: Dictionary<String, String> = Dictionary()
    public var parameters: Dictionary<String, String> = Dictionary()

    public var contentType: String? {
        set {
            headers["Content-Type"] = newValue
        }
        get {
            return headers["Content-Type"]
        }
    }

    override init(){

    }

    public func baseURL(baseURL: String){
        self.baseURL = baseURL
    }

    public init(string: String) {
        self.url = NSURL(string: string)!
    }

    public func request(method: Method, path: String, completionHandler: AoyamaCompletionHandler){
        self.request(method, path: path, parameters: nil, completionHandler: completionHandler)
    }

    public func request(method: Method, path: String, parameters: Dictionary<String, String>?, completionHandler: AoyamaCompletionHandler){
        self.url = NSURL(string: self.baseURL! + path)
        self.method = method.rawValue
        if (parameters != nil) {
            self.parameters = parameters!
        } else {
            self.parameters = Dictionary()
        }
        var request = buildRequest()
        self.headers = Dictionary()
        self.parameters = Dictionary()
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (res, data, error) -> Void in
            completionHandler(res, data, error)
        }
    }
    
    public func buildRequest() -> NSMutableURLRequest {
        contentType = "application/x-www-form-urlencoded"

        var body: NSData?

        if (method == Method.GET.rawValue) {
            url = queryParametersURL()
        } else {
            body = serializedRequestBody()
        }

        let request: NSMutableURLRequest = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = method!
        request.HTTPBody = body
        for (field, value) in headers {
            request.setValue(value, forHTTPHeaderField: field)
        }

        if let validBody = body {
            if (validBody.length > 0) {
                request.setValue(String(validBody.length), forHTTPHeaderField: "Content-Length")
            }
        }
        return request
    }
    
    private func queryParametersURL() -> NSURL? {
        return NSURL(string: url!.absoluteString! + buildParameters())
    }
    
    private func serializedRequestBody() -> NSData? {
        return buildParameters().dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
    }
    
    private func buildParameters() -> String {
        var result = method == Method.GET.rawValue ? "?" : ""
        var firstPass = true
        for (key, value) in parameters {
            let encodedKey: NSString = key.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
            let encodedValue: NSString = value.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
            result += firstPass ? "\(encodedKey)=\(encodedValue)" : "&\(encodedKey)=\(encodedValue)"
            firstPass = false;
        }
        return result
    }
    
}

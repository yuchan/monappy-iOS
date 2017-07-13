//
//  Client.swift
//  monappy
//
//  Created by Yusuke Ohashi on 2017/07/13.
//  Copyright © 2017 Yusuke Ohashi. All rights reserved.
//

import UIKit

class Client: NSObject {
    var requestUrl:URL
    
    init(with url: URL) {
        requestUrl = url
    }
    
    func send(_ completion:((Any?, Error?) -> Void)?) {
        let configuration:URLSessionConfiguration = URLSessionConfiguration.default
        let session:URLSession = URLSession(configuration: configuration)
        let task = session.dataTask(with: requestUrl) { (data, response, error) in
            guard let json = try? JSONSerialization.jsonObject(with: data!) else {
                completion?(nil, error)
                return
            }

            if let error = error {
                completion?(nil, error)
            } else {
                completion?(json, nil)
            }
        }
        task.resume()
    }
}

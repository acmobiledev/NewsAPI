//
//  NewsHTTPManager.swift
//  NewsAPI
//
//  Created by Amit Chaudhary on 11/28/20.
//  Copyright © 2020 Amit Chaudhary. All rights reserved.
//

import Foundation
import UIKit

protocol NewsHTTPManagerDelegate {
    func updateTableViewCellComponents(_ withDataDecorator: NewsDataDecorator)
}

class NewsHTTPManager {
    let urlString = "https://api.thenewsapi.com/v1/news/top?api_token=gRLjHwgEZSkrNAxbVIp4kmZX5vOsgfyMveEA9ZZ0"
    
    var delegate: NewsHTTPManagerDelegate?
    
    func loadNews() {
        self.performHTTPRequest(urlString)
    }
    
    func performHTTPRequest(_ withURLString: String) -> Void {
        //1. Create an URL
        let newsURL = URL(string: withURLString)
        
        //2. Create a URLSession
        let urlSession = URLSession(configuration: URLSessionConfiguration.default)
        
        //3. Assign a dataTask to the session
        let dataTask = urlSession.dataTask(with: newsURL!) { (data, response, error) in
            //print error
            if let safeError = error {
                print(safeError)
            }
            if let safeData = data {
                if let safeDecorator =  self.parseJSONData(safeData) {
                    //update UI OF TableViewCell
                    self.delegate?.updateTableViewCellComponents(safeDecorator)
                }
            }
        }
        
        //4.resume dataTask
        dataTask.resume()
    }
    
    
    func parseJSONData(_ jsonData: Data) ->NewsDataDecorator? {
        let decoder = JSONDecoder()
        do {
            // decode data
            let serializedData = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSArray
            guard let safeArray = serializedData else {
                return nil
            }
            
            // First method to parse this json Data.
            var array = [SwiftDataDelete]()
            for data in safeArray {
                print(data)
                let jsonArray = data as! [String: String]
                let id = jsonArray["id"]
                let date = jsonArray["date"]
                let data = jsonArray["data"]
                let type = jsonArray["type"]
                let swiftData = SwiftDataDelete(id: id, date: date, type: type, data: data)
                array.append(swiftData)
            }
            print("AAAAAAAAAAAAA--------\(array.last?.date)")
            
            // Second Method. Good one but not simple.
            let decodedData = try decoder.decode(FailableCodableArray<NewsSwiftData>.self, from: jsonData)
            let swiftDatas = decodedData.elements
            
            let iTunesDataDecorator = NewsDataDecorator(swiftDatasDecorator: swiftDatas)
            print("BBBBBBBBBBBBB---------\(iTunesDataDecorator.getSwiftDatas.last?.date)")
            return iTunesDataDecorator
            
        } catch {
            print(error)
            return nil
        }
    }
    
    
}

//
//  UIImageView.swift
//  NewsAPI
//
//  Created by Amit Chaudhary on 12/1/20.
//  Copyright © 2020 Amit Chaudhary. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView
{
    func downloadFrom(_ stringData:String?)
    {
        let session = URLSession(configuration: .default)
        if stringData == nil
        {
            self.image = #imageLiteral(resourceName: "NoData")
            return
        }
        
        if let url = URL(string: stringData!) {
        
        // use completionhandler so that we can return cell even before downloaded imagedata is set to cell's imageview.
        let task = session.dataTask(with: url) { (data, response, error) in
            if let safeData = data {
                let image = UIImage(data: safeData)
                if let safeImage = image {
                    DispatchQueue.main.async {
                        self.image = safeImage
                    }
                    
                }
                
            } else {
                 DispatchQueue.main.async {
                self.image = #imageLiteral(resourceName: "NoData")
                }
            }
        }
    
        task.resume()
        }
    }
    
}

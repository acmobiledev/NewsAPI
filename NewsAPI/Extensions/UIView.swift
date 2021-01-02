//
//  UIView.swift
//  NewsAPI
//
//  Created by Amit Chaudhary on 11/28/20.
//  Copyright © 2020 Amit Chaudhary. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func anchorView(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, topPadding: CGFloat, leftPadding: CGFloat, bottomPadding: CGFloat, rightPadding: CGFloat, width: CGFloat, height: CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false
        if let safeTop = top {
            self.topAnchor.constraint(equalTo: safeTop, constant: topPadding).isActive = true
        }
        
        if let safeLeft = left {
            self.leftAnchor.constraint(equalTo: safeLeft, constant: leftPadding).isActive = true
        }
        
        if let safeBottom = bottom {
            self.bottomAnchor.constraint(equalTo: safeBottom, constant: -bottomPadding).isActive = true
        }
        
        if let safeRight = right {
            self.rightAnchor.constraint(equalTo: safeRight, constant: -rightPadding).isActive = true
        }
        
        if height != 0 {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
        if width != 0 {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
    }
}

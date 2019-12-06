//
//  GradientView.swift
//  LXSCommons
//
//  Created by Alex Rote on 10/21/17.
//  Copyright © 2017 Alex Rote. All rights reserved.
//

#if os(iOS)

import UIKit

public class GradientView: UIView {
    
    private let gradientLayer = CAGradientLayer()
    
    public override init(frame: CGRect) {
        gradient = []
        
        super.init(frame: frame)
        
        layer.addSublayer(gradientLayer)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        gradient = []
        super.init(coder: aDecoder)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.frame = bounds
    }
    
    public var gradient: [(color: UIColor, location: Double)] {
        didSet {
            gradientLayer.colors = gradient.count > 0 ? gradient.map{ $0.color.cgColor } : nil
            gradientLayer.locations = gradient.count > 0 ? gradient.map { NSNumber(value: $0.location) } : nil
        }
    }
}

#endif

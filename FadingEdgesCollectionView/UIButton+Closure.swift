//
//  UIButton+Closure.swift
//  FadingEdgesCollectionView
//
//  Created by alex on 30/4/17.
//  Copyright © 2017 Alexandre GOloskok. All rights reserved.
//

import UIKit
import ObjectiveC

var ActionBlockKey: UInt8 = 0

// a type for our action block closure
typealias BlockButtonActionBlock = (_ sender: UIButton) -> Void

class ActionBlockWrapper : NSObject {
    var block : BlockButtonActionBlock
    init(block: @escaping BlockButtonActionBlock) {
        self.block = block
    }
}

extension UIButton {
    func onClick(_ block: @escaping BlockButtonActionBlock) {
        objc_setAssociatedObject(self, &ActionBlockKey, ActionBlockWrapper(block: block), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        addTarget(self, action: #selector(UIButton.block_handleAction(_:)), for: .touchUpInside)
    }
    
    func block_handleAction(_ sender: UIButton) {
        let wrapper = objc_getAssociatedObject(self, &ActionBlockKey) as! ActionBlockWrapper
        wrapper.block(sender)
    }
}

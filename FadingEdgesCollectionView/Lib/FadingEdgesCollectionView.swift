//
//  FadingEdgesCollectionView.swift
//  FadingEdgesCollectionView
//
//  Created by alex on 30/4/17.
//  Copyright © 2017 Alexandre Goloskok. All rights reserved.
//

import UIKit
import AHEasing
import HTGradientEasing_Fixed

extension UIView {
    var height: CGFloat {
        return frame.height
    }
    var width: CGFloat {
        return frame.width
    }
}

/*class FadingEdgesScrollViewPrivateDelegate: NSObject, UICollectionViewDelegate {
    weak var standardDelegate: UICollectionViewDelegate?
    var fadingEdgesCollectionView: FadingEdgesCollectionView

    required init(cv: FadingEdgesCollectionView) {
        fadingEdgesCollectionView = cv
        super.init()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("scrollViewDidScroll in priv delegate")
        fadingEdgesCollectionView.setAppropriateEdgeAlphaAndUpdateGradientBounds()
        standardDelegate?.scrollViewDidScroll?(scrollView)
    }

    override func responds(to aSelector: Selector) -> Bool {
        print("responds to selector: " + aSelector.description)
        return standardDelegate?.responds(to: aSelector) ?? super.responds(to: aSelector)
    }

    override func forwardingTarget(for aSelector: Selector) -> Any? {
        print("forwarding target: " + aSelector.description)
        return standardDelegate
    }
}*/

public class FadingEdgesCollectionView: UICollectionView {
    private let fadeTagLeft = Int(NSDate().timeIntervalSince1970 * 1000) + 7110
    private let fadeTagRight = Int(NSDate().timeIntervalSince1970 * 1000) + 7120
    private let fadeTagTop = Int(NSDate().timeIntervalSince1970 * 1000) + 7130
    private let fadeTagBottom = Int(NSDate().timeIntervalSince1970 * 1000) + 7140

    public var gradientLength: CGFloat = 75.0 {
        willSet(newValue) {
            removeComponents(.gradients)
        }
        didSet {
            addComponents(.gradients)
        }
    }

    public var edgesToFade: UIRectEdge = .all {
        willSet(newValue) {
            removeComponents()
        }
        didSet {
            addComponents(components)
        }
    }

    public var arrowLength: CGFloat = 30.0 {
        willSet(newValue) {
            removeComponents(.arrows)
        }
        didSet {
            addComponents(.arrows)
        }
    }

    public var showArrows: Bool = true {
        didSet {
            removeComponents(.arrows)
            if (showArrows) {
                components.insert(.arrows)
                addComponents(.arrows)
            } else {
                components.remove(.arrows)
            }
        }
    }

    public override var backgroundColor: UIColor? {
        willSet {
            removeComponents(.gradients)
        }
        didSet {
            addComponents(.gradients)
        }
    }

    public var showGradients: Bool = true {
        didSet {
            removeComponents(.gradients)
            if (showGradients) {
                components.insert(.gradients)
                addComponents(.gradients)
            } else {
                components.remove(.gradients)
            }
        }
    }

    struct Components: OptionSet {
        let rawValue: Int
        static let gradients = Components(rawValue: 1 << 0)
        static let arrows = Components(rawValue: 1 << 1)
        static let all: Components = [.gradients, .arrows]
    }

    private var components: Components = .all

    public var fadeDistance: CGFloat = 25.0 {
        didSet {
            superview?.layoutSubviews()
        }
    }

    func removeComponents(_ components: Components = .all) {
        if (components.contains(.arrows)) {
            superview?.viewWithTag(fadeTagLeft + 1)?.removeFromSuperview()
            superview?.viewWithTag(fadeTagRight + 1)?.removeFromSuperview()
            superview?.viewWithTag(fadeTagTop + 1)?.removeFromSuperview()
            superview?.viewWithTag(fadeTagBottom + 1)?.removeFromSuperview()
        }

        if (components.contains(.gradients)) {
            superview?.viewWithTag(fadeTagLeft)?.removeFromSuperview()
            superview?.viewWithTag(fadeTagRight)?.removeFromSuperview()
            superview?.viewWithTag(fadeTagTop)?.removeFromSuperview()
            superview?.viewWithTag(fadeTagBottom)?.removeFromSuperview()
        }
    }

    //private var wrapperDelegate: FadingEdgesScrollViewPrivateDelegate?

    /*public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initDelegate()
    }

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        //initDelegate()
    }

    private func initDelegate() {
        super.super.delegate
        //wrapperDelegate = FadingEdgesScrollViewPrivateDelegate(cv: self)
        //delegate = wrapperDelegate as UICollectionViewDelegate?
    }

    public override var delegate: UICollectionViewDelegate? {
        get {
            print("asking for delegate: " + (wrapperDelegate?.description)!)
            return wrapperDelegate
        }
        set {
            wrapperDelegate?.standardDelegate = newValue
            //super.delegate = nil // avoid caching
            //super.delegate = wrapperDelegate
        }
    }*/

    private func setAppropriateEdgeAlphaAndUpdateGradientBounds() {
        if (edgesToFade.contains(.left)) {
            if let gradient = superview?.viewWithTag(fadeTagLeft) {
                gradient.alpha = contentOffset.x / fadeDistance
                gradient.layer.mask?.frame = gradient.bounds
            }
            superview?.viewWithTag(fadeTagLeft + 1)?.alpha = contentOffset.x / fadeDistance
        }
        if (edgesToFade.contains(.right)) {
            let part1 = contentSize.width - contentOffset.x - width - fadeDistance

            if let gradient = superview?.viewWithTag(fadeTagRight) {
                gradient.alpha = CGFloat(1 - ((part1) / -fadeDistance))
                gradient.layer.mask?.frame = gradient.bounds
            }
            superview?.viewWithTag(fadeTagRight + 1)?.alpha = CGFloat(1 - ((part1) / -fadeDistance))
        }
        if (edgesToFade.contains(.top)) {
            if let gradient = superview?.viewWithTag(fadeTagTop) {
                gradient.alpha = contentOffset.y / fadeDistance
                gradient.layer.mask?.frame = gradient.bounds
            }
            superview?.viewWithTag(fadeTagTop + 1)?.alpha = contentOffset.y / fadeDistance
        }
        if (edgesToFade.contains(.bottom)) {
            let part1 = contentSize.height - contentOffset.y - height - fadeDistance

            if let gradient = superview?.viewWithTag(fadeTagBottom) {
                gradient.alpha = CGFloat(1 - ((part1) / -fadeDistance))
                gradient.layer.mask?.frame = gradient.bounds
            }
            superview?.viewWithTag(fadeTagBottom + 1)?.alpha = CGFloat(1 - ((part1) / -fadeDistance))
        }
    }

    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        addComponents(components)
    }

    private func addComponents(_ components: Components = .all) {
        if (edgesToFade.contains(.left)) {
            addComponents(side: .left, components: components)
        }
        if (edgesToFade.contains(.right)) {
            addComponents(side: .right, components: components)
        }
        if (edgesToFade.contains(.top)) {
            addComponents(side: .top, components: components)
        }
        if (edgesToFade.contains(.bottom)) {
            addComponents(side: .bottom, components: components)
        }
        setAppropriateEdgeAlphaAndUpdateGradientBounds()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        setAppropriateEdgeAlphaAndUpdateGradientBounds()
    }

    private func addComponents(side: NSLayoutAttribute, components: Components) {
        let debug = false

        let arrowsOn = components.contains(.arrows)
        let gradientsOn = components.contains(.gradients)

        // initialize views
        var vGradient = UIView()
        var btnArrow = UIButton()

        if (arrowsOn) {
            switch side {
                case .left, .right:
                    btnArrow = UIButton(frame: CGRect(x: 0, y: 0, width: Int(arrowLength), height: Int(height)))
                case .top, .bottom:
                    btnArrow = UIButton(frame: CGRect(x: 0, y: 0, width: Int(width), height: Int(arrowLength)))
                default:
                    break
            }
        }

        if (gradientsOn) {
            switch side {
                case .left, .right:
                    vGradient = UIView(frame: CGRect(x: 0, y: 0, width: Int(gradientLength), height: Int(height)))
                case .top, .bottom:
                    vGradient = UIView(frame: CGRect(x: 0, y: 0, width: Int(width), height: Int(gradientLength)))
                default:
                    break
            }
        }

        // get a view
        if (arrowsOn) {
            btnArrow.setImage(StyleKit.imageOfChevron(color: UIColor.darkGray), for: .normal)
            switch side {
                case .left:
                    btnArrow.tag = fadeTagLeft + 1
                case .right:
                    btnArrow.tag = fadeTagRight + 1
                    btnArrow.imageView?.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi))
                case .bottom:
                    btnArrow.tag = fadeTagBottom + 1
                    let img = UIImage(cgImage: btnArrow.imageView!.image!.cgImage!, scale: UIScreen.main.scale, orientation: .left)
                    btnArrow.setImage(img, for: .normal)
                case .top:
                    btnArrow.tag = fadeTagTop + 1
                    let img = UIImage(cgImage: btnArrow.imageView!.image!.cgImage!, scale: UIScreen.main.scale, orientation: .right)
                    btnArrow.setImage(img, for: .normal)
                default:
                    break
            }

            btnArrow.alpha = 0
            btnArrow.imageView!.contentMode = .scaleAspectFit

            btnArrow.onClick({ (sender) in self.setContentOffset(self.rightOffsetFor(direction: side, distance: 80), animated: true) })

            if (debug) {
                btnArrow.imageView!.alpha = 0.7
                btnArrow.imageView!.backgroundColor = UIColor.red
                btnArrow.backgroundColor = UIColor.green
            }

            superview?.addSubview(btnArrow)
        }

        if (gradientsOn) {
            switch side {
                case .left:
                    vGradient.tag = fadeTagLeft
                case .right:
                    vGradient.tag = fadeTagRight
                case .bottom:
                    vGradient.tag = fadeTagBottom
                case .top:
                    vGradient.tag = fadeTagTop
                default:
                    break
            }

            vGradient.isUserInteractionEnabled = false
            vGradient.backgroundColor = debug ? UIColor.red : backgroundColor
            vGradient.alpha = 0

            // add gradient
            let gradient = CAGradientLayer()
            gradient.frame = vGradient.frame

            switch side {
                case .left, .right:
                    gradient.startPoint = CGPoint(x: side == .left ? 0.0 : 1.0, y: 0.5)
                    gradient.endPoint = CGPoint(x: side == .left ? 1.0 : 0.0, y: 0.5)
                case .bottom, .top:
                    gradient.startPoint = CGPoint(x: CGFloat(0.5), y: CGFloat(side == .top ? 0.0 : 1.0))
                    gradient.endPoint = CGPoint(x: CGFloat(0.5), y: CGFloat(side == .top ? 1.0 : 0.0))
                default:
                    break
            }
            gradient.setEasedGradientColors([UIColor.black, UIColor.clear], locations: [0, 1], easingFunction: SineEaseIn, keyframesBetweenLocations: 6)
            vGradient.layer.mask = gradient

            if let btnArrow = superview?.viewWithTag(vGradient.tag + 1) {
                superview?.insertSubview(vGradient, belowSubview: btnArrow)
            } else {
                superview?.addSubview(vGradient)
            }
        }

        // add constraints
        func addConstraintsTo(view: UIView?, width: CGFloat) {
            if let view = view {
                switch side {
                    case .left, .right:
                        superview?.addConstraint(NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0))
                        superview?.addConstraint(NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0))
                        superview?.addConstraint(NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: width))
                    case .bottom, .top:
                        superview?.addConstraint(NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: width))
                        superview?.addConstraint(NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0))
                        superview?.addConstraint(NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0))
                    default:
                        break
                }
            }
        }

        if (arrowsOn) {
            btnArrow.translatesAutoresizingMaskIntoConstraints = false
            superview?.addConstraint(NSLayoutConstraint(item: btnArrow, attribute: side, relatedBy: .equal, toItem: self, attribute: side, multiplier: 1, constant: 0))
            addConstraintsTo(view: btnArrow, width: arrowLength)
        }

        if (gradientsOn) {
            vGradient.translatesAutoresizingMaskIntoConstraints = false
            superview?.addConstraint(NSLayoutConstraint(item: vGradient, attribute: side, relatedBy: .equal, toItem: self, attribute: side, multiplier: 1, constant: 0))
            addConstraintsTo(view: vGradient, width: gradientLength)
        }
    }

    private func rightOffsetFor(direction: NSLayoutAttribute, distance: CGFloat) -> CGPoint {
        switch direction {
            case .left:
                return CGPoint(x: max(contentOffset.x - distance, 0), y: 0)
            case .right:
                return CGPoint(x: min(contentOffset.x + distance, contentSize.width - width), y: 0)
            case .bottom:
                return CGPoint(x: 0, y: min(contentOffset.y + distance, contentSize.height - height))
            case .top:
                return CGPoint(x: 0, y: max(contentOffset.y - distance, 0))
            default:
                return CGPoint(x: 0, y: 0)
        }
    }
}

//
//  UIView.swift
//  EvaConnect
//
//  Created by usama on 13/04/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit

extension UIView {
    
    @discardableResult
    func withConstraints(_ closure: (_ view: UIView) -> [NSLayoutConstraint]) -> UIView {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(closure(self))
        return self
    }
    
    
    private func anchorView(_ view: UIView?) -> UIView? {
        return view ?? superview
    }
    
   // Layout guide
    
    func alignTop(_ layoutGuide: UILayoutGuide, constant: CGFloat = 0) -> NSLayoutConstraint {
        return topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: constant)
    }
    
    func alignLeading(_ layoutGuide: UILayoutGuide, constant: CGFloat = 0) -> NSLayoutConstraint {
        return leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: constant)
    }

    func alignTrailing(_ layoutGuide: UILayoutGuide, constant: CGFloat = 0) -> NSLayoutConstraint {
        return trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: constant)
    }

    func alignLeft(_ layoutGuide: UILayoutGuide, constant: CGFloat = 0) -> NSLayoutConstraint {
        return leftAnchor.constraint(equalTo: layoutGuide.leftAnchor, constant: constant)
    }
    
    func alignBottom(_ layoutGuide: UILayoutGuide, constant: CGFloat = 0) -> NSLayoutConstraint {
        return bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: constant)
    }
    
    
    // View
    func alignLeading(_ view: UIView? = nil, constant: CGFloat = 0) -> NSLayoutConstraint {
        return leadingAnchor.constraint(equalTo: anchorView(view)!.leadingAnchor, constant: constant)
    }

    func alignTrailing(_ view: UIView? = nil, constant: CGFloat = 0) -> NSLayoutConstraint {
        return trailingAnchor.constraint(equalTo: anchorView(view)!.trailingAnchor, constant: constant)
    }
    
    func alignLeft(_ view: UIView? = nil, constant: CGFloat = 0) -> NSLayoutConstraint {
        return leftAnchor.constraint(equalTo: anchorView(view)!.leftAnchor, constant: constant)
    }

    func alignRight(_ view: UIView? = nil, constant: CGFloat = 0) -> NSLayoutConstraint {
        return rightAnchor.constraint(equalTo: anchorView(view)!.rightAnchor, constant: constant)
    }
    
    func alignTop(_ view: UIView? = nil, constant: CGFloat = 0) -> NSLayoutConstraint {
        return topAnchor.constraint(equalTo: anchorView(view)!.topAnchor, constant: constant)
    }
    
    func alignBottom(_ view: UIView? = nil, constant: CGFloat = 0) -> NSLayoutConstraint {
        return bottomAnchor.constraint(equalTo: anchorView(view)!.bottomAnchor, constant: constant)
    }
    
    func constraintHeight(_ height: CGFloat) -> NSLayoutConstraint {
        return heightAnchor.constraint(equalToConstant: height)
    }
    
    func constraintWidth(_ width: CGFloat) -> NSLayoutConstraint {
        return widthAnchor.constraint(equalToConstant: width)
    }
    
    func fixView(_ container: UIView!) {
         self.translatesAutoresizingMaskIntoConstraints = false
         self.frame = container.frame
         container.addSubview(self)
         NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
         NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
         NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
         NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
     }
    
    func loadViewFromNib(viewString: String) -> UIView {

         let bundle = Bundle(for: type(of: self))
         let nib = UINib(nibName: viewString, bundle: bundle)
         let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
         return view
     }
    
    class func fromNib<T: UIView>() -> T {

         return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
     }
    
    func transitionView() {
        
        let transition:CATransition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: .linear)
        transition.type = .push
        transition.subtype = .fromTop
        self.layer.add(transition, forKey: kCATransition)
    }
    
    func roundOnly(radius: CGFloat? = nil) {
        if let radius = radius {
            self.layer.cornerRadius = radius
        } else {
            self.layer.cornerRadius = self.frame.size.height / 2
        }
        self.layer.masksToBounds = true
    }
    
    func roundCorners(view: UIView, corners: UIRectCorner, radius: CGFloat) {
            let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            view.layer.mask = mask
    }
    
    func setGradientBackground(colors: [CGColor]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.locations = [NSNumber(floatLiteral: 0.0), NSNumber(floatLiteral: 1.0)]
        gradientLayer.frame = self.bounds
        
        if let topLayer = self.layer.sublayers?.first, topLayer is CAGradientLayer {
            topLayer.removeFromSuperlayer()
        }
        
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func makeRoundView(backGroundColor: UIColor = .white, boderColor: UIColor = .white, boderValue: CGFloat = 2.5) {
        clipsToBounds = true
        self.layer.cornerRadius =  self.layer.frame.height / 2
        layer.borderWidth = boderValue
        layer.borderColor = boderColor.cgColor
        backgroundColor = backGroundColor
    }
    
    func applyBorderWithRadius(color: UIColor = UIColor(hex: "#837A88"), value: CGFloat = 0.25, radius: CGFloat = 10) {
        clipsToBounds = true
        layer.cornerRadius =  radius
        layer.borderWidth = value
        layer.borderColor = color.cgColor
    }
    
    func applyGradient(colors: [CGColor]) {
          let gradientLayer = CAGradientLayer()
          gradientLayer.colors = colors
          gradientLayer.startPoint = CGPoint(x: 0, y: 0)
          gradientLayer.endPoint = CGPoint(x: 1, y: 0)
          gradientLayer.frame = self.bounds
          self.layer.insertSublayer(gradientLayer, at: 0)
      }
    
    func addTopBorderWithColor(color: UIColor, width: CGFloat) {
       let border = CALayer()
       border.backgroundColor = color.cgColor
       border.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: width)
       self.layer.addSublayer(border)
   }

   func addRightBorderWithColor(color: UIColor, width: CGFloat) {
       let border = CALayer()
       border.backgroundColor = color.cgColor
       border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
       self.layer.addSublayer(border)
   }

   func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
       let border = CALayer()
       border.backgroundColor = color.cgColor
       border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
       self.layer.addSublayer(border)
   }

   func addLeftBorderWithColor(color: UIColor, width: CGFloat) {
       let border = CALayer()
       border.backgroundColor = color.cgColor
       border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
       self.layer.addSublayer(border)
    }
    
    func applyShadow(radius: CGFloat = 0, color: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2010729826), size: CGSize = .zero) {
        layer.cornerRadius = radius
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: radius).cgPath
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = size
        layer.shadowRadius = 11
        layer.bounds = bounds
        layer.position = center
        layer.masksToBounds = false
    }
    
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowRadius = 1
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
//        layer.shadowPath = UIBezierPath(rect: CGRect(x: 0, y: bounds.height - 1, width: bounds.width, height: 1)).cgPath
    }
    
    func addCornerRadiusToBottom(radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds,
                                byRoundingCorners: [.bottomLeft, .bottomRight],
                                cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        layer.mask = maskLayer
    }
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(
            roundedRect: self.bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}
extension UIView {

    enum ViewSide {
        case Left, Right, Top, Bottom
    }

    func addBorder(toSide side: ViewSide, withColor color: CGColor, andThickness thickness: CGFloat) {

        let border = CALayer()
        border.backgroundColor = color

        switch side {
        case .Left: border.frame = CGRect(x: frame.minX, y: frame.minY, width: thickness, height: frame.height); break
        case .Right: border.frame = CGRect(x: frame.maxX, y: frame.minY, width: thickness, height: frame.height); break
        case .Top: border.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: thickness); break
        case .Bottom: border.frame = CGRect(x: frame.minX, y: frame.maxY, width: frame.width, height: thickness); break
        }

        layer.addSublayer(border)
    }
}

@IBDesignable extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get { layer.cornerRadius }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = (newValue > 0)
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            guard let cgColor = layer.borderColor else { return nil }
            return UIColor(cgColor: cgColor)
        }
        set { layer.borderColor = newValue?.cgColor }
    }

    @IBInspectable var borderWidth: CGFloat {
        get { layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    
}

@available(iOS 11.0, *)
public extension UIView {
    ///superview is anchored to subview, eg superview.anchor(top: subview.topAnchor)
    func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) {
        //translate the view's autoresizing mask into Auto Layout constraints
        translatesAutoresizingMaskIntoConstraints = false

        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }

        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }

        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }

        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }

        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }

        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
}

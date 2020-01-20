//
//  UIView+Extension.swift
//  Taboola SDK Swift Sample
//
//  Created by Liad Elidan on 24/11/2019.
//  Copyright © 2019 Taboola LTD. All rights reserved.
//

import UIKit

extension UIView {
    class var reusableIdentifier: String {
        return String(describing: self)
    }
}

protocol Nibbable {
    static var nib: UINib { get }
    static var fromNib: Self? { get }
}

extension Nibbable where Self: UIView {
    static var nib: UINib {
        return UINib(
                nibName: String("\(type(of: self as Any))".split(separator: ".")[0]),
                bundle: nil
        )
    }

    static var fromNib: Self? {
        return nib.instantiate(withOwner: nil, options: nil).first as? Self
    }
}

extension UIView {
    struct Anchors: OptionSet {
        let rawValue: Int

        static let leading = Anchors(rawValue: 1)
        static let trailing = Anchors(rawValue: 2)
        static let top = Anchors(rawValue: 4)
        static let bottom = Anchors(rawValue: 8)
        static let centerX = Anchors(rawValue: 16)
        static let centerY = Anchors(rawValue: 32)
        static let none = Anchors(rawValue: 64)

        static let allSides: Anchors = [.leading, .trailing, .top, .bottom]
        static let center: Anchors = [.centerX, .centerY]
    }

    func constrainTo(view: UIView,
                     anchoredTo anchors: Anchors = .allSides,
                     toReadableGuide: Bool = false,
                     toSafeArea: Bool = false,
                     insets: UIEdgeInsets = .zero) {
        if anchors.contains(.leading) {
            let anchor: NSLayoutXAxisAnchor!
            if toReadableGuide {
                anchor = view.readableContentGuide.leadingAnchor
            } else if toSafeArea, #available(iOS 11, *) {
                anchor = view.safeAreaLayoutGuide.leadingAnchor
            } else {
                anchor = view.leadingAnchor
            }
            leadingAnchor.constraint(equalTo: anchor, constant: insets.left).isActive = true
        }
        
        if anchors.contains(.trailing) {
            let anchor: NSLayoutXAxisAnchor!
            if toReadableGuide {
                anchor = view.readableContentGuide.trailingAnchor
            } else if toSafeArea, #available(iOS 11, *) {
                anchor = view.safeAreaLayoutGuide.trailingAnchor
            } else {
                anchor = view.trailingAnchor
            }
            trailingAnchor.constraint(equalTo: anchor, constant: -insets.right).isActive = true
        }
        
        if anchors.contains(.top) {
            let anchor: NSLayoutYAxisAnchor!
            if toSafeArea, #available(iOS 11, *) {
                anchor = view.safeAreaLayoutGuide.topAnchor
            } else {
                anchor = view.topAnchor
            }
            topAnchor.constraint(equalTo: anchor, constant: insets.top).isActive = true
        }
        
        if anchors.contains(.bottom) {
            let anchor: NSLayoutYAxisAnchor!
            if toSafeArea, #available(iOS 11, *) {
                anchor = view.safeAreaLayoutGuide.bottomAnchor
            } else {
                anchor = view.bottomAnchor
            }
            bottomAnchor.constraint(equalTo: anchor, constant: -insets.bottom).isActive = true
        }
        
        if anchors.contains(.centerX) {
            centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        }
        
        if anchors.contains(.centerY) {
            centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        }
    }
    
    func constrainTo(size: CGSize) {
        heightAnchor.constraint(equalToConstant: size.height).isActive = true
        widthAnchor.constraint(equalToConstant: size.width).isActive = true
    }
    
    func addSubviewAndConstrain(_ view: UIView,
                                anchoredTo anchors: Anchors = .allSides,
                                toReadableGuide: Bool = false,
                                toSafeArea: Bool = false,
                                insets: UIEdgeInsets = .zero,
                                withSize size: CGSize? = nil) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        view.constrainTo(view: self, anchoredTo: anchors, toReadableGuide: toReadableGuide, toSafeArea: toSafeArea, insets: insets)
        
        if let size = size {
            view.constrainTo(size: size)
        }
    }
    
    func constrainToSuperview(anchoredTo anchors: Anchors = .allSides, toReadableGuide: Bool = false, insets: UIEdgeInsets = .zero) {
        guard let superview = superview else { return }
        constrainTo(view: superview, anchoredTo: anchors, toReadableGuide: toReadableGuide, insets: insets)
    }
}

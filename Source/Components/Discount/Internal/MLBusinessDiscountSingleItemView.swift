//
//  MLBusinessDiscountSingleItemView.swift
//  MLBusinessComponents
//
//  Created by Esteban Adrian Boffa on 04/09/2019.
//  Copyright © 2019 Juan Sanzone. All rights reserved.
//

import Foundation
import UIKit
import MLUI

final class MLBusinessDiscountSingleItemView: UIView {
    static let itemHeight: CGFloat = 128
    static let iconImageSize: CGFloat = 56
    private let iconCornerRadius: CGFloat = 28
    private let discountSingleItem: MLBusinessSingleItemProtocol
    private var itemIndex: Int = 0
    private var itemSection: Int = 0
    private var itemHeightMargin: CGFloat = 12
    
    weak var delegate: MLBusinessUserInteractionProtocol?

    init(discountSingleItem: MLBusinessSingleItemProtocol, itemIndex: Int, itemSection: Int) {
        self.discountSingleItem = discountSingleItem
        self.itemIndex = itemIndex
        self.itemSection = itemSection
        super.init(frame: .zero)
        render()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func getItemIndex() -> Int {
        return itemIndex
    }
}

// MARK: Privates
extension MLBusinessDiscountSingleItemView {

    private func render() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 6
        
        let icon: UIImageView = UIImageView()
        icon.prepareForAutolayout(.clear)
        icon.setRemoteImage(imageUrl: discountSingleItem.iconImageUrlForItem(), placeHolderRadius: iconCornerRadius, success: { [weak self] _ in
            if let weakSelf = self {
                icon.layer.cornerRadius = weakSelf.iconCornerRadius
                icon.layer.masksToBounds = true
            }
        })

        self.addSubview(icon)
        icon.contentMode = .scaleAspectFill
        NSLayoutConstraint.activate([
            icon.heightAnchor.constraint(equalToConstant: MLBusinessDiscountSingleItemView.iconImageSize),
            icon.widthAnchor.constraint(equalToConstant: MLBusinessDiscountSingleItemView.iconImageSize),
            icon.topAnchor.constraint(equalTo: self.topAnchor, constant: itemHeightMargin),
            icon.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])

        let itemTitle = UILabel()
        itemTitle.prepareForAutolayout(.clear)
        self.addSubview(itemTitle)
        itemTitle.font = UIFont.ml_lightSystemFont(ofSize: UI.FontSize.XXS_FONT)
        itemTitle.applyBusinessLabelStyle()
        itemTitle.text = discountSingleItem.titleForItem()
        itemTitle.textAlignment = .center
        itemTitle.numberOfLines = 1
        NSLayoutConstraint.activate([
            itemTitle.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: UI.Margin.XS_MARGIN),
            itemTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            itemTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])

        let itemSubtitle = UILabel()
        itemSubtitle.prepareForAutolayout(.clear)
        self.addSubview(itemSubtitle)
        itemSubtitle.font = UIFont.ml_semiboldSystemFont(ofSize: UI.FontSize.M_FONT)
        itemSubtitle.applyBusinessLabelStyle()
        itemSubtitle.text = discountSingleItem.subtitleForItem()
        itemSubtitle.textAlignment = .center
        itemSubtitle.numberOfLines = 1
        NSLayoutConstraint.activate([
            itemSubtitle.topAnchor.constraint(equalTo: itemTitle.bottomAnchor),
            itemSubtitle.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            itemSubtitle.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            itemSubtitle.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -itemHeightMargin)
        ])

        let iconOverlay: UIView = UIView(frame: .zero)
        iconOverlay.prepareForAutolayout(.clear)
        iconOverlay.layer.cornerRadius = iconCornerRadius
        iconOverlay.layer.backgroundColor = UIColor(white: 0, alpha: 0.04).cgColor
        iconOverlay.layer.masksToBounds = true
        self.addSubview(iconOverlay)
        NSLayoutConstraint.activate([
            iconOverlay.heightAnchor.constraint(equalToConstant: MLBusinessDiscountSingleItemView.iconImageSize),
            iconOverlay.widthAnchor.constraint(equalToConstant: MLBusinessDiscountSingleItemView.iconImageSize),
            iconOverlay.topAnchor.constraint(equalTo: self.topAnchor, constant: itemHeightMargin),
            iconOverlay.centerXAnchor.constraint(equalTo: self.centerXAnchor)
            ])

        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.didTapOnButton))
        longTapGesture.minimumPressDuration = 0.2
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.callTapAction))
        
        self.addGestureRecognizer(longTapGesture)
        self.addGestureRecognizer(tapGesture)
    }
    
    // MARK: Tap Selector
    @objc private func didTapOnButton(gesture: UITapGestureRecognizer) {
        if gesture.state == UITapGestureRecognizer.State.began {
            if self.discountSingleItem.deepLinkForItem() != nil {
                self.backgroundColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0)
            }
        } else if gesture.state == UITapGestureRecognizer.State.ended {
            self.backgroundColor = .white
            delegate?.didTap(item: discountSingleItem, index: itemIndex, section: itemSection)
        } 
    }
    
    @objc private func callTapAction(gesture: UITapGestureRecognizer) {
        delegate?.didTap(item: discountSingleItem, index: itemIndex, section: itemSection)
    }

}

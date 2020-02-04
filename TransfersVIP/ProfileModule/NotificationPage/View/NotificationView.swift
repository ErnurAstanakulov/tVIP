//
//  ProfileNotificationView.swift
//  TransfersVIP
//
//  Created by psuser on 10/18/19.
//  Copyright © 2019 psuser. All rights reserved.
//

import UIKit

class NotificationView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var delegate: EditButtonDelegate?
    let editButton = UIButton()
    let titleLabel = UILabel()
    let stackView = UIStackView()
    var collectionView: UICollectionView!
    private var channelTitles: [String] = [] {
        willSet {
            collectionView.reloadData()
        }
    }
    var collectionViewHeight: NSLayoutConstraint!
    
    func fill(_ notification: ProfileNotification) {
        channelTitles = notification.channels?.split(separator: ",").map { String($0).trim() } ?? ["Каналы отсутсвуют"]
        titleLabel.text = notification.description
        editButton.tag = notification.id
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        dump("first")
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return channelTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NotificationCollectionCell", for: indexPath) as? NotificationCollectionCell else { return UICollectionViewCell() }
        cell.setChannelTitle(channelTitles[indexPath.item].lowercased())
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text: String = channelTitles[indexPath.item]
        let width = (text as NSString).size(withAttributes: [NSAttributedString.Key.font: AppFont.regular.with(size: 14)]).width + 16 + 16
        print("width: ")
        dump(width)
        return CGSize(width: width, height: 18)
    }
    
    func prepareForReuse() {
        titleLabel.text = nil
        editButton.setImage(nil, for: .normal)
    }
    
    @objc func onPressEdit(_ sender: UIButton) {
        delegate?.onPressButton(sender)
    }
}

extension NotificationView: ViewInitalizationProtocol {
    
    func addSubviews() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 5
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        addSubview(collectionView)
        addSubview(titleLabel)
        addSubview(editButton)
    }
    
    func setupConstraints() {
        
        var layoutConstraints = [NSLayoutConstraint]()

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 18)
        ]

        editButton.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            editButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            editButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            editButton.widthAnchor.constraint(equalToConstant: 24),
            editButton.heightAnchor.constraint(equalToConstant: 24)
        ]
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: editButton.leadingAnchor, constant: -16),
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ]
        
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    func stylizeViews() {
        titleLabel.font = AppFont.regular.with(size: 10)
        titleLabel.isUserInteractionEnabled = false
        titleLabel.numberOfLines = 0
        
        editButton.setImage(AppImage.pencilEdit.uiImage, for: .normal)
        editButton.imageView?.contentMode = .scaleAspectFit
        editButton.semanticContentAttribute = .forceLeftToRight

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
//        stackView.distribution = .fill
//        stackView.alignment = .fill
//        stackView.axis = .vertical
    }
    
    func extraTasks() {
        collectionView.register(NotificationCollectionCell.self, forCellWithReuseIdentifier: "NotificationCollectionCell")
        editButton.addTarget(self, action: #selector(onPressEdit), for: .touchUpInside)
    }
}

class DynamicCollectionView: UICollectionView {
    override func layoutSubviews() {
        super.layoutSubviews()
        if !__CGSizeEqualToSize(bounds.size, self.intrinsicContentSize) {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return collectionViewLayout.collectionViewContentSize
    }
}

class NotificationCollectionCell: UICollectionViewCell {
    
    private let button = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateConstraintsIfNeeded()
    }

    public func setChannelTitle(_ title: String) {
        button.setTitle(title, for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NotificationCollectionCell: ViewInitalizationProtocol {
    
    func addSubviews() {
        addSubview(button)
    }
    
    func setupConstraints() {
        button.addConstaintsToFill()
    }
    
    func stylizeViews() {
        button.setImage(AppImage.cancel.uiImage?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = AppColor.green.uiColor
        button.setTitleColor(AppColor.green.uiColor, for: .normal)
        button.decorator.apply(Style.roundCorner())
        button.backgroundColor = AppColor.light.uiColor
        button.semanticContentAttribute = .forceRightToLeft
    }
}

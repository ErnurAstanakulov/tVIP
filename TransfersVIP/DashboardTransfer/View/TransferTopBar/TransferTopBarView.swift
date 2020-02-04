//
//  TransferTopBarView.swift
//  TransfersVIP
//
//  Created by psuser on 31/08/2019.
//  Copyright © 2019 psuser. All rights reserved.
//

import UIKit
protocol TransferTopBarDelegate {
    func setPageViewController(viewController: UIViewController, with direction: UIPageViewController.NavigationDirection)
}
class TransferTopBarView: UIView, TopBarViewProtocol {
    
    var leftSideImageView = UIImageView()
    
    var verticalStackView = UIStackView()
    var navigationTitleLabel = UILabel()
    var collectionView: UICollectionView!
    var viewControllers: [PagesDelegate] = []
    var selectedCell = IndexPath(row: 0, section: 0)
    var delegate: TransferTopBarDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        setupTopBarView()
        setupViews()
    }
}

extension TransferTopBarView: ViewInitalizationProtocol {
    func addSubviews() {
        addSubview(verticalStackView)
        
        verticalStackView.addArrangedSubview(navigationTitleLabel)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 14
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        verticalStackView.addArrangedSubview(self.collectionView)
    }
    
    func setupConstraints() {
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25).isActive = true
        verticalStackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        verticalStackView.topAnchor.constraint(equalTo: topAnchor, constant: 72).isActive = true
        verticalStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -14).isActive = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }
    
    func stylizeViews() {
        verticalStackView.axis = .vertical
        verticalStackView.alignment = .fill
        verticalStackView.distribution = .equalSpacing
        verticalStackView.spacing = 14
        
        navigationTitleLabel.textColor = AppColor.white.uiColor
        navigationTitleLabel.text = "Переводы"
        navigationTitleLabel.font = AppFont.regular.with(size: 14)
        collectionView.backgroundColor = .clear
        
    }
    func extraTasks() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(DashboardTransferHeaderCell.self, forCellWithReuseIdentifier: "DashboardTransferHeaderCell")
    }
}

extension TransferTopBarView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewControllers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DashboardTransferHeaderCell", for: indexPath) as! DashboardTransferHeaderCell
        if !cell.isSelected {
            collectionView.selectItem(at: selectedCell, animated: true, scrollPosition: .top)
        }
        cell.titleLabel.text = viewControllers[indexPath.item].page.name
        return cell
    }
}

extension TransferTopBarView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        let newIndex = indexPath.item
        let controller =  viewControllers[indexPath.item]
        let direction: UIPageViewController.NavigationDirection = newIndex < selectedCell.row ? .reverse : .forward
        guard let delegate = delegate else { return }
        delegate.setPageViewController(viewController: controller, with: direction)
        self.selectedCell = indexPath
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = viewControllers[indexPath.item].page.name

        let textWidth: CGFloat = ceil(text.boundingRect(with: CGSize(width: Double.greatestFiniteMagnitude, height: Double.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: nil, context: nil).width) + 32

        return CGSize(width: textWidth, height: 35.0)
    }
}

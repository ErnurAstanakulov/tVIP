//
//  ProfileContainerViewController.swift
//  TransfersVIP
//
//  Created by psuser on 10/11/19.
//  Copyright © 2019 psuser. All rights reserved.
//

import UIKit

protocol ProfileContainerViewInput: BaseViewControllerProtocol {
    func setProfilePages(_ pages: [ProfilePages])
}

class ProfileContainerViewController: UIViewController {
    
    var router: ProfileContainerRouterInput!
    var interactor: ProfileContainerInteractorInput!
    
    private var pageController: UIPageViewController!
    private var collectionView: UICollectionView!
    private var topBar = OperationsTableTopBar()
    private var containerView = UIView()
    
    private var selectedCell = IndexPath(row: 0, section: 0)
    private var pages: [ProfilePages] = []
    private var viewControllers: [ProfilePagesProtocol] = []

    override func loadView() {
        super.loadView()
        setupViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.setProfilePages()
    }
    
    func setProfilePages(_ pages: [ProfilePages]) {
        self.pages = pages
        initializeViewControllers()
        collectionView.reloadData()
    }
    
    private func initializeViewControllers() {
        guard let viewControllers = [router.createInformationModule(), router.createOrganizationModule(), router.createNotificationModule()] as? [ProfilePagesProtocol] else { return }
        self.viewControllers = viewControllers
    }
}

extension ProfileContainerViewController: ProfileContainerViewInput {
    var activityIndicator: UIActivityIndicatorView {
        return .init(style: .gray)
    }
}
extension ProfileContainerViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard finished, let currentVC = viewControllers.last else {
            return
        }
        selectedCell.item = currentVC.page.index
        collectionView.scrollToItem(at: selectedCell, at: .centeredHorizontally, animated: true)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentVC = viewController as? ProfilePagesProtocol else {
            return nil
        }
        
        var index = currentVC.page.index
        if index == 0 {
            return nil
        }
        index -= 1
        
        let vc = viewControllers[index]
        return vc
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentVC = viewController as? ProfilePagesProtocol else {
            return nil
        }
        
        var index = currentVC.page.index
        
        if index >= pages.count - 1 {
            return nil
        }
        
        index += 1
        
        let vc = viewControllers[index]
        return vc
    }
}

extension ProfileContainerViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewControllers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ProfileTopCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileTopCollectionCell", for: indexPath) as! ProfileTopCollectionCell
        if !cell.isSelected {
            collectionView.selectItem(at: selectedCell, animated: true, scrollPosition: .centeredHorizontally)
        }
        cell.fillTitle(viewControllers[indexPath.item].page.name)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        let newIndex = indexPath.item
        let controller = viewControllers[indexPath.item]
        let direction: UIPageViewController.NavigationDirection = newIndex < selectedCell.row ? .reverse : .forward
        
        self.selectedCell = indexPath
        pageController.setViewControllers([controller], direction: direction, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = viewControllers[indexPath.item].page.name
        
        let textWidth: CGFloat = ceil(text.boundingRect(with: CGSize(width: Double.greatestFiniteMagnitude, height: Double.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: nil, context: nil).width) + 32
        
        return CGSize(width: textWidth, height: 35.0)
    }
}

extension ProfileContainerViewController: ViewInitalizationProtocol {
    
    func addSubviews() {
        pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 14
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        addChild(viewController: pageController)
        view.addSubview(topBar)
        view.addSubview(containerView)
        view.addSubview(collectionView)
        containerView.addSubview(pageController.view)
    }
    
    func setupConstraints() {
        
        var constraints = [NSLayoutConstraint]()
        
        topBar.addConstaintsToHorizontal()
        constraints += [
            topBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topBar.heightAnchor.constraint(equalToConstant: 100)
        ]
        
        collectionView.addConstaintsToHorizontal()
        constraints += [
            collectionView.topAnchor.constraint(equalTo: topBar.bottomAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 35)
        ]
        
        containerView.addConstaintsToHorizontal()
        constraints += [
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.topAnchor.constraint(equalTo: collectionView.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func stylizeViews() {
        
        self.pageController.view.frame = containerView.frame
        self.pageController.didMove(toParent: self)
        self.pageController.view.backgroundColor = .clear
        self.pageController.dataSource = self
        self.pageController.delegate = self
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.contentInset.left = 25
        self.collectionView.backgroundColor = AppColor.lightGray.uiColor
        
        self.view.backgroundColor = .white
        self.containerView.backgroundColor = .blue
        self.topBar.titleLabel.text = "Настройки"
        self.topBar.titleLabel.font = AppFont.regular.with(size: 18)
        self.pageController.setViewControllers([router.createInformationModule()], direction: .forward, animated: true, completion: nil)
    }
    
    func extraTasks() {
        self.collectionView.register(ProfileTopCollectionCell.self, forCellWithReuseIdentifier: "ProfileTopCollectionCell")
    }
}



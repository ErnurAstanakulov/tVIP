//
//  TransferPageContainerViewController.swift
//  TransfersVIP
//
//  Created by psuser on 29/08/2019.
//  Copyright © 2019 psuser. All rights reserved.
//

import UIKit

class DashboardTransferContainerViewController: UIViewController {
    
    private var pageController: UIPageViewController!
    private var topBarView = TransferTopBarView()
    private var containerView = UIView()
    private var pages: [Pages] = []
    private var page0 = UIViewController()

    var iteractor: DashboardTransferIteractorInput?
    var router: DashboardTransferRouterInput!
    
    override func loadView() {
        super.loadView()
        initilizeTransferChildViewControllers()
        setupViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        iteractor?.setPages()
    }
    
    private func setPageController(viewControllers: [PagesDelegate]) {
        self.topBarView.viewControllers = viewControllers
    }
    
    private func initilizeTransferChildViewControllers() {
        page0 = router.createTransferNewController()
        guard let viewControllers = [
            router.createTransferNewController(),
            router.createTransferWorkController(),
            router.createTransferTemplateMenuController(),
            router.createTransferRegularController()
            ] as? [PagesDelegate] else { return }
        self.setPageController(viewControllers: viewControllers)
    }
}
extension DashboardTransferContainerViewController: TransferPageContainerViewControllerInput {

    func setPages(with pages: [Pages]) {
        self.pages = pages
        self.topBarView.collectionView.reloadData()
    }
}

extension DashboardTransferContainerViewController: ViewInitalizationProtocol {
    func addSubviews() {
        self.pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)

        self.addChild(pageController!)
        self.view.addSubview(containerView)
        self.containerView.addSubview(pageController!.view)
        self.view.addSubview(topBarView)
    }
    
    func setupConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()
        topBarView.addConstaintsToHorizontal()
        layoutConstraints += [
            topBarView.topAnchor.constraint(equalTo: view.topAnchor),
            topBarView.heightAnchor.constraint(equalToConstant: 150)
        ]
        
        containerView.addConstaintsToHorizontal()
        layoutConstraints += [
            containerView.topAnchor.constraint(equalTo: topBarView.bottomAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    func stylizeViews() {
        self.pageController.view.frame = containerView.frame
        self.pageController.setViewControllers([page0], direction: .forward, animated: true, completion: nil)
        self.pageController.didMove(toParent: self)
        self.pageController.view.backgroundColor = .clear
        self.pageController.dataSource = self
        self.pageController.delegate = self
        
        self.view.backgroundColor = .white
        self.containerView.backgroundColor = .blue
    }
    
    func extraTasks() {
        self.topBarView.delegate = self
    }
}
extension DashboardTransferContainerViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard finished, let currentPageController = pageViewController.viewControllers?.last as? PagesDelegate else {
            return
        }
        topBarView.selectedCell.item = currentPageController.page.index
        self.topBarView.collectionView.selectItem(at: topBarView.selectedCell, animated: true, scrollPosition: .centeredHorizontally)

    }
}

extension DashboardTransferContainerViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentVC = viewController as? PagesDelegate else {
            return nil
        }
        
        var index = currentVC.page.index

        if index == 0 {
            return nil
        }
        
        index -= 1
        
        let vc = topBarView.viewControllers[index]


        return vc
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentVC = viewController as? PagesDelegate else {
            return nil
        }
        
        var index = currentVC.page.index
        
        if index >= self.pages.count - 1 {
            return nil
        }
        
        index += 1
        
        let vc = topBarView.viewControllers[index]
       
        return vc
    }
}
extension DashboardTransferContainerViewController: TransferTopBarDelegate {
    func setPageViewController(viewController: UIViewController, with direction: UIPageViewController.NavigationDirection) {
        self.pageController.setViewControllers([viewController], direction: direction, animated: true, completion: nil)
    }
}

extension UIView {
    func addConstaintsToHorizontal(padding: CGFloat = 0) {
        prepareForConstraints()
        self.leadingAnchor.constraint(equalTo: superview!.leadingAnchor, constant: padding).isActive = true
        self.trailingAnchor.constraint(equalTo: superview!.trailingAnchor, constant: -padding).isActive = true
    }
    
    func addConstaintsToVertical(padding: CGFloat = 0) {
        prepareForConstraints()
        self.topAnchor.constraint(equalTo: superview!.topAnchor, constant: padding).isActive = true
        self.bottomAnchor.constraint(equalTo: superview!.bottomAnchor, constant: -padding).isActive = true
    }
    
    func addConstaintsToFill(padding: CGFloat = 0) {
        prepareForConstraints()
        addConstaintsToHorizontal(padding: padding)
        addConstaintsToVertical(padding: padding)
    }
    
    private func prepareForConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
        if superview == nil {
            assert(false, "You need to have a superview before you can add contraints")
        }
    }
}

//
//  FetchOnDemandPageViewController.swift
//  Taboola JS Swift Sample
//
//  Created by Roman Slyepko on 2/12/19.
//  Copyright © 2019 Taboola LTD. All rights reserved.
//

import UIKit

class FetchOnDemandPageViewController: UIPageViewController {
    let pageQnty = 5
    var pageViewControllers = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        if let firstViewController = viewController(at: 0) {
            self.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
        for i in 0..<pageQnty {
            guard let vc = viewController(at: i) else {
                print("Failed to populate view controllers")
                break
            }
            _ = vc.view.frame
            pageViewControllers.append(vc)
        }
    }
    
    func viewController(at index: Int) -> PageContentViewController? {
        guard index >= 0, index < pageQnty else {
            return nil 
        }
        if pageViewControllers.count > index, let existingViewController = pageViewControllers[index] as? PageContentViewController {
            return existingViewController
        }
        let pageContentViewController = storyboard?.instantiateViewController(withIdentifier: "PageContentViewController") as? PageContentViewController
        pageContentViewController?.pageIndex = index
        return pageContentViewController
    }
}

extension FetchOnDemandPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let contentViewController = viewController as? PageContentViewController, let index = contentViewController.pageIndex else {
            return nil
        }
        return self.viewController(at: index-1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let contentViewController = viewController as? PageContentViewController, let index = contentViewController.pageIndex else {
            return nil
        }
        return self.viewController(at: index+1)
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pageQnty
    }
}

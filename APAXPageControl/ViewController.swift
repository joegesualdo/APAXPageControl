//
//  ViewController.swift
//  APAXPageControl
//
//  Created by Joe Gesualdo on 4/8/17.
//  Copyright © 2017 Joe Gesualdo. All rights reserved.
//

import Foundation
import UIKit

class ViewController: UIViewController, PageControlDelegate {
  var pageControlController: APAXPageControlController!
  var currentPage: Int = 0
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    
    // SEtup the page control
    let controlCount = 4
    let controlWidth = 10
    let controlHeight = 10
    let controlSpacing = 5
    let pageControlView = UIView(frame: CGRect())
    pageControlView.frame.size.width = CGFloat(controlWidth)
    pageControlView.frame.size.height = CGFloat(controlHeight)
    pageControlView.backgroundColor = UIColor.lightGray
    
    self.pageControlController = APAXPageControlController(
      withView: pageControlView,
      count: controlCount,
      spacing: Float(controlSpacing),
      onSelectPageControl: { pageIndex in
      },
      onActivatePageControlView: { controlView in
        controlView.backgroundColor = UIColor.darkGray
        return controlView
      },
      onDeActivatePageControlView: {controlView in
        controlView.backgroundColor = UIColor.lightGray
        return controlView
      }
    )
    self.pageControlController.delegate = self
    self.pageControlController.selectAtIndex(self.currentPage)
    
    
    let nextButton = UIButton(frame: CGRect(x: 300, y: 400, width: 30, height: 30))
    nextButton.backgroundColor = .red
    nextButton.addTarget(self, action: #selector(onNext), for: UIControlEvents.touchDown)
    
    let prevButton = UIButton(frame: CGRect(x: 0, y: 400, width: 30, height: 30))
    prevButton.backgroundColor = .red
    prevButton.addTarget(self, action: #selector(onPrev), for: UIControlEvents.touchDown)
    
    self.addChildViewController(self.pageControlController)
    let controlView = self.pageControlController.view
    self.view.addSubview(controlView!)
    self.view.addSubview(nextButton)
    self.view.addSubview(prevButton)
    
    
    controlView?.translatesAutoresizingMaskIntoConstraints = false;
    controlView?.frame.size.width = CGFloat((controlCount * controlWidth) + (controlSpacing * (controlCount - 1)))
    let centerPoint = self.view.frame.size.width/2
    let xOrigin = centerPoint - ((controlView?.frame.size.width)!/2)
    controlView?.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50).isActive = true
    controlView?.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: xOrigin).isActive = true
    controlView?.heightAnchor.constraint(equalToConstant: CGFloat(controlHeight)).isActive = true
    
    self.pageControlController.didMove(toParentViewController: self)
    self.pageControlController.selectAtIndex(0)
    
//    self.walkThroughtViewController.view.removeFromSuperview()
//    self.walkThroughtViewController.removeFromParentViewController()
  }
  func onNext() {
    self.currentPage = self.currentPage + 1
    self.pageControlController.selectAtIndex(self.currentPage)
  }
  func onPrev() {
    self.currentPage = self.currentPage - 1
    self.pageControlController.selectAtIndex(self.currentPage)
  }
//  func pageControlDidSelectView(_ view: UIView) -> UIView {
//    view.backgroundColor = .orange
//    return view
//  }
//  func pageControlDidDeSelectView(_ view: UIView) -> UIView {
//    view.backgroundColor = .brown
//    view.frame.size.height = 10
//    view.frame.size.width = 10
//    return view
//  }
}


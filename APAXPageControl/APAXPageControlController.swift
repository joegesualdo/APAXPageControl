//
//  APAXPageControlController.swift
//  APAXPageControl
//
//  Created by Joe Gesualdo on 4/8/17.
//  Copyright © 2017 Joe Gesualdo. All rights reserved.
//

import Foundation
import UIKit

public class APAXPageControlController: UIViewController, PageControlDelegate {
  var control: PageControl? = nil
  var delegate: PageControlDelegate?
  var controlView: UIView?
  var controlCount: Int?
  var controlSpacing: Float?
  var onSelectPageControl: ((_ index: Int) -> Void)!
  var onActivatePageControlView: ((_ controlView: UIView) -> UIView)!
  var onDeActivatePageControlView: ((_ controlView: UIView) -> UIView)!
  
  public convenience init(
    withView view: UIView,
    count: Int,
    spacing: Float,
    onSelectPageControl: @escaping ((_ index: Int) -> Void),
    onActivatePageControlView: @escaping ((_ controlView: UIView) -> UIView),
    onDeActivatePageControlView: @escaping ((_ controlView: UIView) -> UIView)
  ){
    self.init()
    self.controlView = view
    self.controlCount = count
    self.controlSpacing = spacing
    self.onSelectPageControl = onSelectPageControl
    self.onActivatePageControlView = onActivatePageControlView
    self.onDeActivatePageControlView = onDeActivatePageControlView
    
    self.control = PageControl(withView: view, count: count, spacing: spacing)
  }
  
  override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nil, bundle: nil)
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  override public func viewDidLoad() {
    super.viewDidLoad()
    
    control?.delegate = self
    view.addSubview((control?.stack!)!)
    
    for button in (control?.stack!.arrangedSubviews)! {
      button.isUserInteractionEnabled = true
      let gr = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:)))
      button.addGestureRecognizer(gr)
    }
    
    setupContraints()
  }
  
  func handleTap(sender: UIGestureRecognizer) {
    control?.selected(sender: sender.view!)
  }
  
  public func selectAtIndex(_ index: Int){
    control?.selectIndex(index)
  }
  func setupContraints() {
    let selectedView = self.control?.stack!.arrangedSubviews[(self.control?.currentIndex)!]
    let unselectedView = controlView
    
    let w = ((unselectedView?.frame.size.width)! * CGFloat(self.controlCount!)) + CGFloat((Float((self.controlCount! - 1)) * self.controlSpacing!))
    let newWidth = w + ((selectedView?.frame.size.width)! - (unselectedView?.frame.size.width)!)
    
    print("New Width: " + String(describing: newWidth))
    
    self.view.translatesAutoresizingMaskIntoConstraints = false
    self.view.widthAnchor.constraint(equalToConstant: newWidth).isActive = true
    self.view.heightAnchor.constraint(equalToConstant: (unselectedView?.frame.size.height)!).isActive = true
    
    
    self.control?.stack!.translatesAutoresizingMaskIntoConstraints = false;
    self.control?.stack!.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
    self.control?.stack!.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
    self.control?.stack!.widthAnchor.constraint(equalToConstant: newWidth).isActive = true
    self.control?.stack!.heightAnchor.constraint(equalToConstant: (unselectedView?.frame.size.height)!).isActive = true
    self.view.layoutIfNeeded()
    self.view.setNeedsLayout()
    self.view.setNeedsDisplay()
  }
  
  // MARK; - PageControlDelegate
  func selectedIndex(_ index:Int) {
    self.onSelectPageControl(index)
//    self.delegate?.selectedIndex(index)
  }
  
  func pageControlDidSelectView(_ view: UIView) -> UIView {
//    let newView = self.delegate?.pageControlDidSelectView(view)
    let newView = self.onActivatePageControlView(view)
    setupContraints()
    return newView
  }
  
  func pageControlDidDeSelectView(_ view: UIView) -> UIView {
    let newView = self.onDeActivatePageControlView(view)
    return newView
  }
}

@objc protocol PageControlDelegate {
  @objc optional func selectedIndex(_ index:Int)
  @objc optional func pageControlDidSelectView(_ view: UIView) -> UIView
  @objc optional func pageControlDidDeSelectView(_ view: UIView) -> UIView
}

class PageControl : NSObject, UIGestureRecognizerDelegate {
  
  var stack : UIStackView? = nil
  var delegate : PageControlDelegate?
  var pageControlView : UIView?
  var currentIndex: Int = 0
  
  convenience init(withView view: UIView, count: Int, spacing: Float) {
    self.init()
    self.pageControlView = view
    
    var array: [UIView] = []
    
    var i = count
    while i > 0 {
      let newView: UIView = copyView(viewToCopy: self.pageControlView!)
      let newerView = applyStyle(newView: newView)
      array.append(newerView)
      i -= 1
    }
    
    stack = UIStackView(arrangedSubviews: array)
    stack?.translatesAutoresizingMaskIntoConstraints = false;
    stack?.spacing = CGFloat(spacing)
    stack?.distribution = .equalCentering
    
  }
  
  override init(){
    super.init()
  }
  
  func selectIndex(_ index:Int){
    print("selectIndex: " + String(index))
    print("selectIndex: " + String(currentIndex))
    let oldSelectedView = stack?.arrangedSubviews[self.currentIndex]
    let newSelectedView = stack?.arrangedSubviews[index]
    _ = delegate?.pageControlDidDeSelectView!(oldSelectedView!)
    self.currentIndex = index
    _ = delegate?.pageControlDidSelectView!(newSelectedView!)
    delegate?.selectedIndex!(index)
  }
  
  func selected(sender : UIView){
    print("selected")
    let index = (stack?.arrangedSubviews.index(of: sender))
    selectIndex(index!)
  }
}

func copyView(viewToCopy: UIView) -> UIView {
  // create an NSData object from myView
  let archive = NSKeyedArchiver.archivedData(withRootObject: viewToCopy)
  
  // create a clone by unarchiving the NSData
  let newView = NSKeyedUnarchiver.unarchiveObject(with: archive) as! UIView
  return newView
}

func applyStyle(newView: UIView) -> UIView {
  newView.isUserInteractionEnabled = true
  newView.translatesAutoresizingMaskIntoConstraints = false
  newView.heightAnchor.constraint(equalToConstant: CGFloat(newView.frame.size.height)).isActive = true;
  newView.widthAnchor.constraint(equalToConstant: CGFloat(newView.frame.size.width)).isActive = true;
  
  newView.layer.cornerRadius = CGFloat(newView.frame.size.width/2)
  newView.clipsToBounds = true
  return newView
}

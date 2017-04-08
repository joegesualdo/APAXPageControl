# APAXPageControl
> A simple to implement iOS page control

![](https://github.com/joegesualdo/APAXPageControl/raw/master/APAXPageControl_demo.gif)

# Install
```ruby
pod 'APAXPageControl', '0.1.0'
```

# Usage
```swift
class ViewController: UIViewController {
  let pageControlController: APAXPageControlController!

  override func viewDidLoad() {
    ...
    let pageControlView = UIView(frame: CGRect())
    pageControlView.frame.size.width = CGFloat(10)
    pageControlView.frame.size.height = CGFloat(10)
    pageControlView.backgroundColor = UIColor.lightGray

    self.pageControlController = APAXPageControlController(
      withView: pageControlView,
      count: 4,
      spacing: Float(5),
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

    self.addChildViewController(self.pageControlController)
    self.view.addSubview(self.pageControlController.view)
    self.pageControlController.didMove(toParentViewController: self)

    self.pageControlController.selectAtIndex(self.currentPage)
    ...
  }
}
```
> Remember to add constraints or frame information (width, height, x, y) on the page control view.

```swift
let controlView = self.pageControlController.view
controlView?.translatesAutoresizingMaskIntoConstraints = false;
controlView?.frame.size.width = CGFloat((controlCount * controlWidth) + (controlSpacing * (controlCount - 1)))
let centerPoint = self.view.frame.size.width/2
let xOrigin = centerPoint - ((controlView?.frame.size.width)!/2)
controlView?.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50).isActive = true
controlView?.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: xOrigin).isActive = true
controlView?.heightAnchor.constraint(equalToConstant: CGFloat(controlHeight)).isActive = true
```

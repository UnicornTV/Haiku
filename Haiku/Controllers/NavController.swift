import UIKit

// We need to import the FlourishUI CocoaPod so that we can call the Modal() function
import FlourishUI

class NavController: UINavigationController
{
  // We define these with let and initialize with whatever constants we can
  // Then later on in the app lifecycle, we can override any properties we want
  let navigation = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: Constants.Layout.navigationHeight))
  let navigationBorder = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 1))
  let logo = UIButton(frame: CGRect(x: Constants.Layout.padding, y: 0, width: 0, height: 0))
  let writeNavItem = UIButton()
  let entriesNavItem = UIButton()
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    
    // Call our setup method on viewDidLoad because it is when our memory is allocated 
    // but the presentation of the view has not yet begun
    setup()
  }
  
func setup()
{
  // Set our navigation view to the full screen width and set a drop shadow
  // Notice that shadows are added on the layer attribute of the UIView
  // This has to do with how the views are drawn and most custom decorative styles
  // have to be applied to this layer or within the draw() method of the UIView itself
  navigation.backgroundColor = .lightGray
  navigation.frame.size.width = view.frame.width
  navigation.layer.shadowColor = UIColor.black.cgColor
  navigation.layer.shadowOffset = CGSize(width: 0, height: 2)
  navigation.layer.shadowOpacity = 0.20
  navigation.layer.shadowRadius = 2
  
  // Create the Gradient and add it to the first (0) index of the navigation view.
  // As mentioned above, most aspects of decorating are done via CALayers, QuartzCore and 
  // appended to the UIView
  let gradient = CAGradientLayer()
  gradient.frame = navigation.frame
  gradient.startPoint = CGPoint(x: 0, y: 0)
  gradient.endPoint = CGPoint(x: 0, y: 1)
  gradient.colors = [UIColor.lightGray.cgColor, UIColor.darkGray.cgColor]
  navigation.layer.insertSublayer(gradient, at: 0)
  
  /* 
   Create and style the logo button
 
   Most of the stying and positioning should make sense since it is simple math.
   We defined the logo as a fixed width and positioned from the left by our constant padding definition
   This could be potentially be problematic, but as long as you test thoroughly, it's an okay practice
  */
  logo.frame = CGRect(
    x: Constants.Layout.padding,
    y: (navigation.frame.height - 18) / 2,
    width: 50,
    height: 18
  )
  logo.contentHorizontalAlignment = .left
  logo.setTitle("LOGO", for: .normal)
  logo.setTitleColor(.white, for: .normal)
  logo.addTarget(self, action: #selector(aboutHandler), for: .touchUpInside)
  
  /*
   Create "WRITE" navigation button

   We calculate the position of this as dynamically as possible.
   Since both WRITE and ENTRIES buttons are 90 points wide,
   we calculate x starting from the right side of the screen 
   subtracting our padding and the width of both components (180) 
   and an additional 10 points of spacing between them
  */
  writeNavItem.frame = CGRect(
    
    x: view.frame.width - Constants.Layout.padding - 190,
    y: (navigation.frame.height - 18) / 2,
    width: 90,
    height: 18
  )
  // should default to true, because our WriteController is the one that is initially loaded
  writeNavItem.isSelected = true
  writeNavItem.setTitle("WRITE", for: .normal)
  writeNavItem.contentHorizontalAlignment = .right
  // We use the UIControlState to set white or yellow for "normal" and "selected"
  // this can be abbreviated to just the .normal and .selected because the method knows it's
  // an enumerated type of UIControlState, long hand would read: UIControlState.normal
  writeNavItem.setTitleColor(.white, for: .normal)
  writeNavItem.setTitleColor(.yellow, for: .selected)
  // We give it a tag for quick lookup later
  writeNavItem.tag = 0
  // Finally we add the navHandler() function as a target and pass it the button itself as a sender
  writeNavItem.addTarget(self, action: #selector(navHandler(sender:)), for: .touchUpInside)
  
  /*
   Create "ENTRIES" navigation button

   this is almost exactly the same as our write navigation, except it's not selected by default
   the tag is set to 1, and the x positioning is 100 points more to the right.
   Notice too that both the navigation buttons are centered vertically by calculating
   the parent `navigation` view height minus the button height (18) and divided by two
  */
  entriesNavItem.frame = CGRect(
    x: view.frame.width - Constants.Layout.padding - 90,
    y: (navigation.frame.height - 18) / 2,
    width: 90,
    height: 18
  )
  entriesNavItem.setTitle("ENTRIES", for: .normal)
  entriesNavItem.contentHorizontalAlignment = .right
  entriesNavItem.setTitleColor(.white, for: .normal)
  entriesNavItem.setTitleColor(.yellow, for: .selected)
  entriesNavItem.tag = 1
  entriesNavItem.addTarget(self, action: #selector(navHandler(sender:)), for: .touchUpInside)
  
  // Create a 1px border and position it at the bottom of the navigation view
  navigationBorder.frame.size.width = navigation.frame.width
  navigationBorder.frame.origin.y = navigation.frame.height - 1
  navigationBorder.backgroundColor = .white
  
  // Add subviews to the `navigation` view
  navigation.addSubview(logo)
  navigation.addSubview(writeNavItem)
  navigation.addSubview(entriesNavItem)
  navigation.addSubview(navigationBorder)
  
  // Set our navigationBar to be dark and translucent (the bar with date/time/battery)
  navigationBar.isTranslucent = true
  navigationBar.barStyle = .blackTranslucent
  navigationBar.addSubview(navigation)
}

  func navHandler(sender: Any? = nil)
  {
    if let button = sender as? UIButton
    {
      // Return if the view is already presented
      if (writeNavItem.isSelected && button.tag == 0) || (entriesNavItem.isSelected && button.tag == 1)
      {
        return
      }
    }
    
    // Since we only have two, we can just inverse selected state values
    entriesNavItem.isSelected = !entriesNavItem.isSelected
    writeNavItem.isSelected = !writeNavItem.isSelected
    
    if writeNavItem.isSelected
    {
      // Popping the view controller removes the top most view off of the navigation stack
      // in this case, that will always be the EntriesController because our default VC
      // is the WriteController and EntriesController is always "pushed" or added on top
      popViewController(animated: true)
    }
    else
    {
      // Since our WriteController essentially is always there, we basically just
      // instantiate EntriesController and add it to the top of this NavController
      pushViewController(EntriesController(), animated: true)
    }
  }

func aboutHandler()
{
  Modal(
    title: "About the Creators",
    body: "Clay and Oscar are Unicorns in name and deed. Yes, single horned steeds",
    status: .info
  ).show()
}
}

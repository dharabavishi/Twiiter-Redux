//
//  HamburgerViewController.swift
//  Twitter
//
//  Created by Ruchit Mehta on 11/2/16.
//  Copyright © 2016 Dhara Bavishi. All rights reserved.
//

import UIKit

enum HamburgerEvent: String {
    
    case ToggleMenu = "toggleMenu"
    case CloseMenu = "closeMenuViaNotification"
   
    
}
extension NotificationCenter {
    
    func postNotification(event: HamburgerEvent) {
        post(name: NSNotification.Name(rawValue: event.rawValue), object: nil)
    }
    
}

extension UIViewController {
    
    func addObserver(observer: AnyObject, selector aSelector: Selector, event: HamburgerEvent) {
        NotificationCenter.default.addObserver(observer, selector: aSelector, name: NSNotification.Name(rawValue: event.rawValue), object: nil)
        
    }
    
    func postNotification(event: HamburgerEvent) {
        NotificationCenter.default.postNotification(event: event)
    }
}
class HamburgerViewController: UIViewController {
    
    @IBOutlet weak var menuView: UIView!

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentViewLeftConstraint: NSLayoutConstraint!
    var originalLeftMargin : CGFloat!
    
    
    
    
    var menuViewController: UIViewController!{
        didSet{
            view.layoutIfNeeded()
            menuView.addSubview(menuViewController.view)
            
        }
    }
    var contentViewController: UIViewController!{
        didSet(oldContenetViewController){
            view.layoutIfNeeded()
            
            if(oldContenetViewController != nil){
                
                oldContenetViewController.willMove(toParentViewController: nil)
                oldContenetViewController.view.removeFromSuperview()
                oldContenetViewController.didMove(toParentViewController: nil)


            }
            contentViewController.willMove(toParentViewController: self)
            contentView.addSubview(contentViewController.view)
            contentViewController.didMove(toParentViewController: self)
            UIView.animate(withDuration: 0.3) {
                self.contentViewLeftConstraint.constant = 0
                self.view.layoutIfNeeded()
            }
            
            
        }
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        addObserver(observer: self, selector: "toggleMenu", event: .ToggleMenu)
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        let tweetsViewController = storyBoard.instantiateViewController(withIdentifier: "TweetsNavigationController")
        
        contentViewController = tweetsViewController
        
       
     //   let menuViewController = storyboard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
//        menuVC.hamburgerVC = self
//        
       // self.menuVC = menuVC

      
        
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
   
    
    func toggleMenu() {
        
       

         self.contentViewLeftConstraint.constant != 0  ? closeMenu() : openMenu()
    }
    func closeMenu(animated:Bool = true) {
       
        UIView.animate(withDuration: 0.3, animations: {
            
            
            self.contentViewLeftConstraint.constant = 0
            self.view.layoutIfNeeded()
        })
        
    }
    
    // Open is the natural state of the menu because of how the storyboard is setup.
    func openMenu() {
        
        UIView.animate(withDuration: 0.3, animations: {
            
            
            self.contentViewLeftConstraint.constant = self.view.frame.size.width-50
            self.view.layoutIfNeeded()

        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onPanGesture(_ sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: view)
        let velocity = sender.translation(in: view)
        if sender.state == UIGestureRecognizerState.began{
            originalLeftMargin = contentViewLeftConstraint.constant
            
        }else if sender.state == UIGestureRecognizerState.changed{
            contentViewLeftConstraint.constant = originalLeftMargin+translation.x
        }else if sender.state == UIGestureRecognizerState.ended{
            print("velovity is \(velocity.x)")
            
            UIView.animate(withDuration: 0.3, animations: { 
                if velocity.x>0{
                    self.contentViewLeftConstraint.constant = self.view.frame.size.width-50
                }else{
                    self.contentViewLeftConstraint.constant = 0
                }
                self.view.layoutIfNeeded()
            })
           
            
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

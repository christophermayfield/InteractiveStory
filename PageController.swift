//
//  PageController.swift
//  InteractiveStory
//
//  Created by Christopher Mayfield on 7/8/16.
//  Copyright © 2016 Christopher Mayfield. All rights reserved.
//

import UIKit

class PageController: UIViewController {
    var page: Page?
    
    //properties for the UI stuff
    
    // all let means is that we can't assign a different instance to the constant, we can still mutate the underlying reference and configue the components however we need.
    
    let artwork = UIImageView()
    let storyLabel = UILabel()
    let firstChoiceButton = UIButton(type: .System)
    let secondChoiceButton = UIButton(type: .System)
    //the stored property to hold the page that we will be working with.
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    init(page: Page) { //since we are treating our init method as the designated initializer for the subclass, we need to call a designated initializer on UIViewController to initialize up the chain
        self.page = page
        super.init(nibName: nil, bundle: nil) // this is for UIViewController. 
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        
        if let page = page {
            artwork.image = page.story.artwork
           
            let attributedString = NSMutableAttributedString(string: page.story.text)
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 10
            
            //there's a specfic key in our attributes dictionary 
            attributedString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
            
            //we need to display this attributed string using the label
            
            storyLabel.attributedText = attributedString
            
            //checking to see whether or not the firstChoice and secondChoice buttons are not nil 
            
            if let firstChoice = page.firstChoice {
                firstChoiceButton.setTitle(firstChoice.title, forState: .Normal)
                firstChoiceButton.addTarget(self, action: #selector(PageController.loadFirstChoice), forControlEvents: .TouchUpInside)
            } else {
                firstChoiceButton.setTitle("Play Again", forState: .Normal)
                firstChoiceButton.addTarget(self, action: #selector(PageController.playAgain), forControlEvents: .TouchUpInside)
            }
        
            if let secondChoice = page.secondChoice {
                secondChoiceButton.setTitle(secondChoice.title, forState: .Normal)
                secondChoiceButton.addTarget(self, action: #selector(PageController.loadSecondChoice), forControlEvents: .TouchUpInside)
            } else {
                secondChoiceButton.addTarget(self, action: #selector(PageController.playAgain), forControlEvents: .TouchUpInside)
            }
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillLayoutSubviews() { //this will lay out the subView
        //this adds the image view of the subview as the viewControllers view
        
        view.addSubview(artwork)
        
        artwork.translatesAutoresizingMaskIntoConstraints = false //this turns off the autconstraints. you need to set this on every subview that you add to the mainview. if you don't do this, none of the subviews will ever be laid out correctly.
        
        storyLabel.numberOfLines = 0 //this allows the compiler to figure out the number of lines to display. 
        
        
        
        //Below it is using the //NSLayoutAnchor class in order to generate the constraints.
        
        NSLayoutConstraint.activateConstraints([ //this is an array and how you activate all the constraints.
            artwork.topAnchor.constraintEqualToAnchor(view.topAnchor), artwork.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor), artwork.leftAnchor.constraintEqualToAnchor(view.leftAnchor), artwork.rightAnchor.constraintEqualToAnchor(view.rightAnchor)
            ])
        
        
        
        view.addSubview(storyLabel)
        storyLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activateConstraints([storyLabel.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor, constant: 16.0), storyLabel.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor, constant: -16.0), storyLabel.topAnchor.constraintEqualToAnchor(view.centerYAnchor, constant: -48.0)])
        
        view.addSubview(firstChoiceButton)
        firstChoiceButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activateConstraints([ firstChoiceButton.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor), firstChoiceButton.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor, constant: -80.0)
            
            ])
    
    
        view.addSubview(secondChoiceButton)
        secondChoiceButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activateConstraints([secondChoiceButton.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor), secondChoiceButton.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor, constant: -32.0)
            
            ])
    }
    
    func loadFirstChoice() {
        //this will retrieve the page instance stored in the firstchoice property and intialize a new pageController with it.
        if let page = page, firstChoice = page.firstChoice {
            //the next step in the tree is stored by the firstChoice property 
            let nextPage = firstChoice.page
            let pageController = PageController(page: nextPage)
        
            
            //every viewController has an optional property navigationController, if your VC is part of a navigation stack, the property refers to the navigation controller, using this prop. we can ask the navigation controller to push another viewcontroller onto the stack. 
            
            navigationController?.pushViewController(pageController, animated: true) //this is the firstChoice
        }
    }
    
    func loadSecondChoice() {
        if let page = page, secondChoice = page.secondChoice {
            let nextPage = secondChoice.page
            let pageController = PageController(page: nextPage) //we are getting the page from the secondPage.
            
            navigationController?.pushViewController(pageController, animated: true)
        }
    }
    
    func playAgain() {
        navigationController?.popToRootViewControllerAnimated(true)
    }
}

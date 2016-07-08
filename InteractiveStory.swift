//
//  InteractiveStory.swift
//  InteractiveStory
//
//  Created by Christopher Mayfield on 7/5/16.
//  Copyright © 2016 Christopher Mayfield. All rights reserved.
//

import Foundation
import UIKit


enum Story: String {
    case ReturnTrip
    case TouchDown
    case Homeward
    case Rover
    case Cave
    case Crate
    case Monster
    case Droid
    case Home
}

extension Story {
    var artwork: UIImage {
        return UIImage(named: self.rawValue)!
        
        //force unwrapping is usually bad, we are using the enums rawValue, as long the enum member and image name match, we are always getting the iamge, we are also not using the rawValue as an argument to the intializer method directly we are going through the computed property.
    }
    
    var text: String {
        switch self {
        case .ReturnTrip:
            return "On your return trip from studying Saturn's rings, you hear a distress signal that seems to be coming from the surface of Mars. It's strange because there hasn't been a colony there in years. \"Help me, you're my only hope.\""
        case .TouchDown:
            return "You deftly land your ship near where the distress signal originated. You didn't notice anything strange on your fly-by, behind you is an abandoned rover from the early 21st century and a small crate."
        case .Homeward:
            return "You continue your course to Earth. Two days later, you receive a transmission from HQ saing that they have detected some sort of anomaly on the surface of Mars near an abandoned rover. They ask you to investigate, but ultimately the decision is yours because your mission has already run much longer than planned and supplies are low."
        case .Rover:
            return "The rover is covered in dust and most of the solar panels are broken. But you are quite surprised to see the on-board system booted up and running. In fact, there is a message on the screen. \"Come to 28.2342, -81.08273\". These coordinates aren't far but you don't know if your oxygen will last there and back."
        case .Cave:
            return "Your EVA suit is equipped with a headlamp which you use to navigate to a cave. After searching for a while your oxygen levels are starting to get pretty low. You know you should go refill your tank, but there's a faint light up ahead."
        case .Crate:
            return "Unlike everything else around you the crate seems new and...alien. As you examine the create you notice something glinting on the ground beside it. Aha, a key! It must be for the crate..."
        case .Monster:
            return "You pick up the key and try to unlock the crate, but the key breaks off in the keyhole.You scream out in frustration! Your scream alerts a creature that captures you and takes you away..."
        case .Droid:
            return "After a long walk slightly uphill, you end up at the top of a small crater. You look around and are overjoyed to see your robot friend, Droid-S1124. It had been lost on a previous mission to Mars. You take it back to your ship and fly back to Earth."
        case .Home:
            return "You arrive home on Earth. While your mission was a success, you forever wonder what was sending that signal. Perhaps a future mission will be able to investigate."
        }
    }
}


class Page { //they get automatic memberwise intializers
    let story: Story
    
    typealias Choice = (title: String, page: Page) //Rather than using the tuple we can refer to it using the typealias anywhere
    
    //a tuple is an anonymous struct 
    
    var firstChoice: Choice?
    var secondChoice: Choice?
    
    init(story: Story) {
        self.story = story
    }
    
}

extension Page {
    func addChoice(title: String, story: Story) -> Page {
        let page = Page(story: story)
        
        return addChoice(title, page: page)
        
        //now we can add a choice by simply indiciating what part of the story we want to go to next without worrying the details of a page.
    }
    
    func addChoice(title: String, page: Page) -> Page {
        switch (firstChoice, secondChoice) {
        case (.Some, .Some): break //regardless what happens in the switch statement, we are going to break out of it
        case (.None, .None), (.None, .Some): firstChoice = (title, page)
        case (.Some, .None): secondChoice = (title, page)
        
        }
        return page
    }
}


struct Adventure {
    //single static computed property that returns the story that we will use in an app, all this computed property is the top level that contains all the linked pages. This is called a linked list.
    
    static var story: Page {
        let returnTrip = Page(story: .ReturnTrip)
        let touchDown = returnTrip.addChoice("Stop and Investigate", story: .TouchDown) //remember that the way we designed this, the story we pass in creates a page and then this method returns that page
        let homeWord = returnTrip.addChoice("Continue Home to Earth ", story: .Homeward)
        let rover = returnTrip.addChoice("Explore the rover", story: .Rover)
        let crate = touchDown.addChoice("Open the crate", story: .Crate)
        
        homeWord.addChoice("Headed back to home", page: touchDown)
        let home = homeWord.addChoice("Continue home to earth", story: .Home)
        
        let cave = rover.addChoice("Explore the coordinates", story: .Cave)
        rover.addChoice("Return to Earth", page: home)
        
        cave.addChoice("Continue towards the faint light", story: .Droid)
        cave.addChoice("Refill the ship and explore the rover", page: rover)
        
        crate.addChoice("Explore the crate", page: crate)
        crate.addChoice("Use the Key", story: .Monster)
        
        return returnTrip
    }
}
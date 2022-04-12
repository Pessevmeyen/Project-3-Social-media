//
//  DetailViewController.swift
//  Project1
//
//  Created by Furkan Eruçar on 20.03.2022.
//

import UIKit

// We can break this task down into three smaller tasks, two of which are new:

// 1. Load the detailViewController layout from our storyboard.
// 2. Set its selectedImage property to be the correct item from the pictures array.
// 3. Show the new view controller.

// The first of those is done by calling instantiateViewController, but it has two small complexities. First, we call it on the storyboard property that we get from Apple’s UIViewController type, but it’s optional because Swift doesn’t know we came from a storyboard. So, we need to use ? just like when we were setting the text label of our cell: “try doing this, but do nothing if there was a problem.”

// Second, even though instantiateViewController() will send us back a DetailViewController if everything worked correctly, Swift thinks it will return back a UIViewController because it can’t see inside the storyboard to know what’s what.

// This will seem confusing if you’re new to programming, so let me try to explain using an analogy. Let’s say you want to go out on a date tonight, so you ask me to arrange a couple of tickets to an event. I go off, find tickets, then hand them to you in an envelope. I fulfilled my part of the deal: you asked for tickets, I got you tickets. But what tickets are they – tickets for a sporting event? Tickets for an opera? Train tickets? The only way for you to find out is to open the envelope and look.

class DetailViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView! // @IBOutlet: This attribute is used to tell Xcode that there's a connection between this line of code and Interface Builder. 
    // var: This declares a new variable or variable property.
    // imageView: This was the property name assigned to the UIImageView. Note the way capital letters are used: variables and constants should start with a lowercase letter, then use a capital letter at the start of any subsequent words. For example, myAwesomeVariable. This is sometimes called camel case.
    // UIImageView!: This declares the property to be of type UIImageView, and again we see the implicitly unwrapped optional symbol: !. This means that that UIImageView may be there or it may not be there, but we're certain it definitely will be there by the time we want to use it.
    var selectedImage: String? // 1. We need to create a property in DetailViewController that will hold the name of the image to load.
                               // 2.We’ll implement the didSelectRowAt method so that it loads a DetailViewController from the storyboard.
                               // 3. Finally, we’ll fill in viewDidLoad() inside DetailViewController so that it loads an image into its image view based on the name we set earlier.
                                // Let’s solve each of those in order, starting with the first one: creating a property in DetailViewController that will hold the name of the image to load.

                                //  This property will be a string – the name of the image to load – but it needs to be an optional string because when the view controller is first created it won’t exist. We’ll be setting it straight away, but it still starts off life empty.
      
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = selectedImage // title = "Storm Viewer" This title is also automatically used for the “Back” button, so that users know what they are going back to. In DetailViewController we could add something like this to viewDidLoad(): title = "View Picture" That would work fine, but instead we’re going to use some dynamic text: we’re going to display the name of the selected picture instead. Add this to viewDidLoad() in DetailViewController: title = selectedImage We don’t need to unwrap selectedImage here because both selectedImage and title are optional strings – we’re assigning one optional string to another. title is optional because it’s nil by default: view controllers have no title, thus showing no text in the navigation bar.
        navigationItem.largeTitleDisplayMode = .never // In this app we want “Storm Viewer” to appear big, but the detail screen to look normal. To make that happen we need to add a line of code to viewDidLoad() in DetailViewController.swift:
    
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped)) // Share buttonunu ekledik.
        //This is easily split into two parts: on the left we're assigning to the "rightBarButtonItem" of our view controller's "navigationItem". This navigation item is used by the navigation bar so that it can show relevant information. In this case, we're setting the right bar button item, which is a button that appears on the right of the navigation bar when this view controller is visible. On the right we create a new instance of the UIBarButtonItem data type, setting it up with three parameters: a system item, a target, and an action. The system item we specify is .action, but you can type . to have code completion tell you the many other options available. The .action system item displays an arrow coming out of a box, signaling the user can do something when it's tapped. The target and action parameters go hand in hand, because combined they tell the UIBarButtonItem what method should be called. The action parameter is saying "when you're tapped, call the shareTapped() method," and the target parameter tells the button that the method belongs to the current view controller – self.
        
        // Do any additional setup after loading the view.
        if let imageToLoad = selectedImage { // That ? means it might have a value or it might not, and Swift doesn’t let you use these “maybes” without checking them first. This is another opportunity for if let: we can check that selectedImage has a value, and if so pull it out for usage; otherwise, do nothing.
            // The first line is what checks and unwraps the optional in selectedImage. If for some reason selectedImage is nil (which it should never be, in theory) then the imageView.image line will never be executed. If it has a value, it will be placed into imageToLoad, then passed to UIImage and loaded.
            imageView.image = UIImage(named: imageToLoad)
        }
        
    }
    
    
    // We're using override for each of these methods, because they already have defaults defined in UIViewController and we're asking it to use ours instead. Don't worry if you aren't sure when to use override and when not, because if you don't use it and it's required Xcode will tell you.
    // Both methods have a single parameter: whether the action is animated or not. We don't really care in this instance, so we ignore it.
    // Both methods use the super prefix again: super.viewWillAppear() and super.viewWillDisappear(). This means "tell my parent data type that these methods were called." In this instance, it means that it passes the method on to UIViewController, which may do its own processing.
    // We’re using the navigationController property again, which will work fine because we were pushed onto the navigation controller stack from ViewController. We’re accessing the property using ?, so if somehow we weren’t inside a navigation controller the hidesBarsOnTap lines will do nothing.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    @objc func shareTapped() { // We start with the method name, marked with @objc because this method will get called by the underlying Objective-C operating system (the UIBarButtonItem) so we need to mark it as being available to Objective-C code. When you call a method using #selector you’ll always need to use @objc too.
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else { // Our image view may or may not have an image inside, so we’ll read it out safely and convert it to JPEG data. This has a compressionQuality parameter where you can specify a value between 1.0 (maximum quality) and 0.0 (minimum quality_.
            print("No image found")
            return
        }
        
        let vc = UIActivityViewController(activityItems: [image], applicationActivities: []) // UIActivityViewController: you tell it what kind of data you want to share, and it figures out how best to share and save it. Next we create a UIActivityViewController, which is the iOS method of sharing content with other apps and services.
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true) // butonu ekranda göstericek
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

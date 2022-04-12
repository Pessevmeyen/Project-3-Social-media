//
//  ViewController.swift
//  Project1
//
//  Created by Furkan Eruçar on 18.03.2022.
//

import UIKit

 class ViewController: UITableViewController {
    var pictures = [String]() // We also need to tell Swift exactly what kind of data it will hold – in our case that’s an array of strings, where each item will be the name of an “nssl” picture.

    
    override func viewDidLoad() { // As you know, the override keyword is needed because it means “we want to change Apple’s default behavior from UIViewController.” viewDidLoad() is called by UIKit when the screen has loaded, and is ready for you to customize.
        super.viewDidLoad() // This super call means “tell Apple’s UIViewController to run its own code before I run mine,” and you’ll see this used a lot.
        
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
    
        
        let fm = FileManager.default // This line declares a constant called fm and assigns it the value returned by FileManager.default. This is a data type that lets us work with the filesystem, and in our case we'll be using it to look for files. loading those NSSL JPEGs was done by scanning the app bundle using the FileManager class, which lets you read and write to the iOS filesystem. We used it to scan directories, but it can also check if a file exists, delete things, copy things, and more.
        let path = Bundle.main.resourcePath! // This line declares a constant called path that is set to the resource path of our app's bundle. Remember, a bundle is a directory containing our compiled program and all our assets. Bu satırda "Uygulamama eklediğim tüm bu resimleri nerede bulabileceğimi söyle" yazıyor."
        let items = try! fm.contentsOfDirectory(atPath: path) // This line declares a third constant called items that is set to the contents of the directory at a path. Which path? Well, the one that was returned by the line before. The items constant will be an array of strings containing filenames. the items array will be a constant collection of the names of all the files found in the resource directory of our app.
        
        for item in items { // By this point, we'll have the first filename ready to work with, and it'll be called item.
            if item.hasPrefix("nssl") { // To decide whether it's one we care about or not, we use the hasPrefix() method: it takes one parameter (the prefix to search for) and returns either true or false. Eğer item "nssl" ön ekine sahipse altına yazacağımız kod çalışır. hasPrefix() true olduğu müddetçe executed edilir.
                
            
                // this is a picture to load! Buraya ulaştıysak, item bundle'ından yüklenecek bir resmin adını içermeli, bu yüzden onu bir yerde saklamamız gerekiyor.
                pictures.append(item)
            }
        }
        
        print(pictures) // That tells Swift to print the contents of pictures to the Xcode debug console. When you run the program now, you should see this text appear at the bottom of your Xcode window: “["nssl0033.jpg", "nssl0034.jpg", "nssl0041.jpg", "nssl0042.jpg", "nssl0043.jpg", "nssl0045.jpg", "nssl0046.jpg", "nssl0049.jpg", "nssl0051.jpg", "nssl0091.jpg”]”
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // override: The override keyword means the method has been defined already, and we want to override the existing behavior with this new behavior. If you didn't override it, then the previously defined method would execute, and in this instance it would say there are no rows.
        // func: The func keyword starts a new function or a new method; Swift uses the same keyword for both. Technically speaking a method is a function that appears inside a class, just like our ViewController, but otherwise there’s no difference.
        //  tableView: The method’s name comes next: tableView. That doesn't sound very useful, but the way Apple defines methods is to ensure that the information that gets passed into them – the parameters – are named usefully, and in this case the very first thing that gets passed in is the table view that triggered the code. A table view, as you might have gathered, is the scrolling thing that will contain all our image names, and is a core component in iOS.
        // UITableView: As promised, the next thing to come is tableView: UITableView, which is the table view that triggered the code. But this contains two pieces of information at once: tableView is the name that we can use to reference the table view inside the method, and UITableView is the data type – the bit that describes what it is.
        // numberOfRowsInSection: The most important part of the method comes next: numberOfRowsInSection section: Int. This describes what the method actually does. We know it involves a table view because that's the name of the method, but the numberOfRowsInSection part is the actual action: this code will be triggered when iOS wants to know how many rows are in the table view. The section part is there because table views can be split into sections, like the way the Contacts app separates names by first letter. We only have one section, so we can ignore this number. The Int part means “this will be an integer,” which means a whole number like 3, 30, or 35678 number.”
        // Finally, -> Int means “this method must return an integer”, which ought to be the number of rows to show in the table.

        return pictures.count // That means “send back the number of pictures in our array,” so we’re asking that there be as many table rows as there are pictures.
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // First, override func tableView(_ tableView: UITableView is identical to the previous method: the method name is just tableView(), and it will pass in a table view as its first parameter. The _ means it doesn’t need to have a name sent externally, because it’s the same as the method name.
        // Second, cellForRowAt indexPath: IndexPath is the important part of the method name. The method is called cellForRowAt, and will be called when you need to provide a row. The row to show is specified in the parameter: indexPath, which is of type IndexPath. This is a data type that contains both a section number and a row number. We only have one section, so we can ignore that and just use the row number.
        // Third, -> UITableViewCell means this method must return a table view cell. If you remember, we created one inside Interface Builder and gave it the identifier “Picture”, so we want to use that.
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath) //That creates a new constant called cell by dequeuing a recycled cell from the table. We have to give it the identifier of the cell type we want to recycle, so we enter the same name we gave Interface Builder: “Picture”. We also pass along the index path that was requested; this gets used internally by the table view.
        cell.textLabel?.text = pictures[indexPath.row] //The cell has a property called textLabel, but it’s optional: there might be a text label, or there might not be – if you had designed your own, for example. Rather than write checks to see if there is a text label or not, Swift lets us use a question mark – textLabel? – to mean “do this only if there is an actual text label there, or do nothing otherwise.” We want to set the label text to be the name of the correct picture from our pictures array, and that’s exactly what the code does. indexPath.row will contain the row number we’re being asked to load, so we’re going to use that to read the corresponding picture from pictures, and place it into the cell’s text label.
        return cell //The last line in the method is return cell. Remember, this method expects a table view cell to be returned, so we need to send back the one we created – that’s what the return cell does.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { //Let’s look at the if let line a bit more closely for a moment. There are three parts of it that might fail: the storyboard property might be nil (in which case the ? will stop the rest of the line from executing), the instantiateViewController() call might fail if we had requested “Fzzzzz” or some other invalid storyboard ID, and the typecast – the as? part – also might fail, because we might have received back a view controller of a different type.
        
        // So, three things in that one line have the potential to fail. If you’ve followed all my steps correctly they won’t fail, but they have the potential to fail. That’s where if let is clever: if any of those things return nil (i.e., they fail), then the code inside the if let braces won’t execute. This guarantees your program is in a safe state before any action is taken.
        
        
            // 1: try loading the "Detail" view controller and typecasting it to be DetailViewController
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController { // swift deatilViewController'ı okuyamadığı için typecasting "as?" kullanarak swifte neyin ne olduğunu gösteriyoruz
            
            // 2: success! Set its selectedImage property
            vc.selectedImage = pictures[indexPath.row]
            
            // 3: now push it onto the navigation controller
            navigationController?.pushViewController(vc, animated: true)
            
            //if let satırındaki bi şey yanlış olursa programın çökmemesi için if let { içinde hiçbir kod çalıştırılmayacak. bu yüzden if let kullandık
            
        }
        
    }
}


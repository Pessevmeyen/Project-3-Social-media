//
//  MyTableViewController.swift
//  Project1
//
//  Created by Furkan Eruçar on 26.03.2022.
//

import UIKit

class MyTableViewController: UITableViewController {
    var pictures: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setPicturesArray()
        
    }
    
    private func setPicturesArray() {
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(item)
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard !pictures.isEmpty else { return }
        if let controller = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            controller.selectedImage = pictures[indexPath.row]
            navigationController?.pushViewController(controller, animated: true)
        }
    }

}

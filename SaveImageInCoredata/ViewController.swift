//
//  ViewController.swift
//  SaveImageInCoredata
//
//  Created by Techno on 10/30/15.
//  Copyright © 2015 Techno. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource ,NSFetchedResultsControllerDelegate{
    
    @IBOutlet weak var mytableview: UITableView!
    var people = [NSManagedObject]()
    


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        title = "List Of Photos"
        
        self.navigationController!.navigationBar.barTintColor = UIColor(red: (91/255.0), green: (158/255.0), blue: (201/255.0), alpha: 1.0)
              let navigationBarAppearace = UINavigationBar.appearance()
        
         navigationBarAppearace.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        

    }

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //1
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest(entityName: "Photo")
        
        //3
        do {
            let results =
            try managedContext.executeFetchRequest(fetchRequest)
            people = results as! [NSManagedObject]
            self.mytableview.reloadData()
           
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITableViewDataSource
    func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            
        print("count === %@",people.count)
            return people.count
    }
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath
        indexPath: NSIndexPath) -> UITableViewCell {
            
            let cell =
            tableView.dequeueReusableCellWithIdentifier("Cell")
            
            

            let label: UILabel = cell!.viewWithTag(2) as! UILabel
            
            let cellImage = cell!.viewWithTag(3) as! UIImageView
            
            let person = people[indexPath.row]
            
           label.text = person.valueForKey("name") as? String
            
            
            if let dataImage : NSData = person.valueForKey("image") as? NSData{
            
                cellImage.contentMode = UIViewContentMode.ScaleToFill
                
                cellImage.image = UIImage(data: dataImage)
                
            }
            
            return cell!
    }


}


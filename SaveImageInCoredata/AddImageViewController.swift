//
//  AddImageViewController.swift
//  Save Images Core Data Swift
//
//  Created by Techno on 10/29/15.
//  Copyright © 2015 Techno. All rights reserved.
//

import UIKit
import CoreData
import Photos

class AddImageViewController: UIViewController,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverControllerDelegate
    
{
    
    @IBOutlet weak var imagenameText: UITextField!
    
    @IBOutlet weak var nameDisplaylab: UILabel!
    @IBOutlet weak var btnClickMe: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    var picker:UIImagePickerController?=UIImagePickerController()
    var popover:UIPopoverController?=nil
    var imageData: NSData?

    
    let managedObjectContext =
    (UIApplication.sharedApplication().delegate
        as! AppDelegate).managedObjectContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        picker!.delegate=self
        
        let navigationBarAppearace = UINavigationBar.appearance()
        
               navigationBarAppearace.barTintColor = UIColor.whiteColor()  // Bar's background color
        
        navigationBarAppearace.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        
        title = "Add Image And Name"
          self.navigationController!.navigationBar.barTintColor = UIColor(red: (91/255.0), green: (158/255.0), blue: (201/255.0), alpha: 1.0)
        
        
        
        imagenameText.attributedPlaceholder = NSAttributedString(string:"Please Add Name To Image here",
            attributes:[NSForegroundColorAttributeName: UIColor.redColor()])
        
        imageView.layer.borderWidth = 1.0
        imageView.layer.masksToBounds = false
        imageView.layer.borderColor = UIColor.blackColor().CGColor
        
        imageView.clipsToBounds = true
        
        imagenameText.layer.borderWidth = 1.0
        imagenameText.layer.cornerRadius = 10;
        imagenameText.layer.masksToBounds = false
        imagenameText.layer.borderColor = UIColor.blackColor().CGColor
        imagenameText.clipsToBounds = true

        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("imageTapped:"))
        imageView.userInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    func imageTapped(img: AnyObject)
    {
       
        self.AddImagesToLibrary(img)
        
    }
    
 
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    @IBAction func DownPressed(sender: AnyObject) {
        
        
        if imagenameText.text == "" {
            
            let alert = UIAlertController(title: "Alert", message: "Please Enter the name of Image", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)

            
        }else {
            
           // Adding Data to Core data
            
let entityDescription = NSEntityDescription.entityForName("Photo",
                inManagedObjectContext: managedObjectContext)
            
            let photo = Photo(entity: entityDescription!,
                insertIntoManagedObjectContext: managedObjectContext)
            
            // add our data
            photo.setValue(imagenameText.text, forKey: "name")
            photo.setValue(imageData, forKey: "image")
            
            // save it
            do {
                // this was the problem ///////////////
                try managedObjectContext.save()
                NSLog("Photo Saved...%@",photo)
                
            } catch {
                fatalError("Failure to save context: \(error)")
            }
            
            // Dismiss the viewcontroller
            self.dismissViewControllerAnimated(true, completion: {});
        }
        
    }
    
    @IBAction func canclealTheView(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: {});
        
    }
    
    @IBAction func AddImagesToLibrary(sender: AnyObject) {
        
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default)
            {
                UIAlertAction in
                self.openCamera()
                
        }
        let gallaryAction = UIAlertAction(title: "Gallary", style: UIAlertActionStyle.Default)
            {
                UIAlertAction in
                self.openGallary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel)
            {
                UIAlertAction in
                
        }
        
        // Add the actions
        picker?.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        // Present the controller
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone
        {
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else
        {
            popover=UIPopoverController(contentViewController: alert)
            popover!.presentPopoverFromRect(btnClickMe.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }
        
        
    }
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera))
        {
            picker!.sourceType = UIImagePickerControllerSourceType.Camera
            self .presentViewController(picker!, animated: true, completion: nil)
        }
        else
        {
            openGallary()
        }
    }
    func openGallary()
    {
        picker!.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone
        {
            self.presentViewController(picker!, animated: true, completion: nil)
        }
        else
        {
            popover=UIPopoverController(contentViewController: picker!)
            popover!.presentPopoverFromRect(btnClickMe.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
            
        }
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        picker .dismissViewControllerAnimated(true, completion: nil)
        imageView.image=info[UIImagePickerControllerOriginalImage] as? UIImage
        nameDisplaylab.text = imagenameText.text
      
        imageData = NSData(data: UIImageJPEGRepresentation(imageView.image!, 1.0)!)
     
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        print("picker cancel.")
    }
    
    
}

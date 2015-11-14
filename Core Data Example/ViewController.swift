//
//  ViewController.swift
//  Core Data Example
//
//  Created by Aaqib Hussain on 14/11/2015.
//  Copyright (c) 2015 Aaqib Hussain. All rights reserved.
//

import UIKit
import CoreData
class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var showToAdd: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var watchList = [NSManagedObject]()
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let managedContext = appDelegate.managedObjectContext!
        let fetchRequest = NSFetchRequest(entityName:"Shows") 
        var error: NSError?
        let fetchedResults = managedContext.executeFetchRequest(fetchRequest, error: &error) as! [NSManagedObject]?
        if let results = fetchedResults {
            watchList = results
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        } }


    @IBAction func add(sender: AnyObject) {
        self.addShow(showToAdd.text)
        self.tableView.reloadData()
        showToAdd.text = ""
        
    }
    func addShow(showName: String){
        let managedContext = appDelegate.managedObjectContext!
        let entity = NSEntityDescription.entityForName("Shows", inManagedObjectContext:
            managedContext)
        let show = NSManagedObject(entity: entity!, insertIntoManagedObjectContext:managedContext)
        
        show.setValue(showName, forKey: "watchList")
        
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)") }
        
        watchList.append(show)
    }
    func updateAlertView(cellIndex: Int){
        
        var alert = UIAlertController(title: "Show", message: "Update show name",
            preferredStyle: .Alert)
        let saveAction = UIAlertAction(title: "Update",
            style: .Default) { (action: UIAlertAction!) -> Void in
                let textField = alert.textFields![0] as! UITextField;
                
                self.updateCoreData(textField.text,index: cellIndex)
                self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel",
            style: .Default) { (action: UIAlertAction!) -> Void in
        }
        alert.addTextFieldWithConfigurationHandler { (textField: UITextField!) -> Void in
        };
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        presentViewController(alert, animated: true,
            completion: nil)
        
    }
    func updateCoreData(value: String, index: Int){
        
        var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        var context: NSManagedObjectContext = appDel.managedObjectContext!
        
        var fetchRequest = NSFetchRequest(entityName: "Shows")
       
        
        if let fetchResults = appDel.managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [NSManagedObject] {
            if fetchResults.count != 0{
                
                var managedObject = fetchResults[index]
                managedObject.setValue(value, forKey: "watchList")
                
                context.save(nil)
            }
        }
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        updateAlertView(indexPath.row)
        
        
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        
        return watchList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        let shows = watchList[indexPath.row]
        cell.textLabel!.text = shows.valueForKey("watchList") as! String?
        return cell
        
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            
            let managedContext:NSManagedObjectContext = appDelegate.managedObjectContext!
            managedContext.deleteObject(watchList[indexPath.row] as NSManagedObject)
            watchList.removeAtIndex(indexPath.row)
            managedContext.save(nil)
            
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
            
            
            
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}


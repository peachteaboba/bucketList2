//
//  ViewController.swift
//  bucketList2
//
//  Created by Andy Feng on 8/4/16.
//  Copyright © 2016 Andy Feng. All rights reserved.
//

import UIKit
import CoreData

class BucketListViewController: UITableViewController, CancelButtonDelegate, MissionDetailsViewControllerDelegate {

    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
//    var missions = ["Become Pokemon Master", "Build Ironman Suit", "Hack Evil Corp."]
    var missions = [Mission]()
    
    
    func fetchAllMissions() {
        let userRequest = NSFetchRequest(entityName: "Mission")
        do {
            let results = try managedObjectContext.executeFetchRequest(userRequest)
            missions = results as! [Mission]
        } catch {
            print("\(error)")
        }
    }
    
    
    
    override func viewDidLoad() {
       
        // *This will set the left bar button to toggle "Edit Mode"
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
        fetchAllMissions()
        
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // dequeue the cell from our storyboard
        let cell = tableView.dequeueReusableCellWithIdentifier("MyCell")!
        // All UITableViewCell objects have a build in textLabel so set it to the model that is corresponding to the row in array
        cell.textLabel?.text = missions[indexPath.row].details
        // return cell so that Table View knows what to draw in each row
        return cell
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return missions.count
    }
    
    func cancelButtonPressedFrom(controller: UIViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AddNewMission" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! MissionDetailsViewController
            controller.cancelButtonDelegate = self
            controller.delegate = self
        } else if segue.identifier == "EditMission" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! MissionDetailsViewController
            controller.cancelButtonDelegate = self
            controller.delegate = self
            // Here we set the missionToEdit so that we can have the mission text on the MissionDetailsViewController
            if let indexPath = tableView.indexPathForCell(sender as! UITableViewCell) {
                controller.missionToEdit = missions[indexPath.row]
                controller.missionToEditIndexPath = indexPath.row
            }
        }
    }
    
    
    
    
    
    func missionDetailsViewController(controller: MissionDetailsViewController, didFinishAddingMission mission: String) {
        dismissViewControllerAnimated(true, completion: nil)
//        missions.append(mission)
//        let newMission = Mission()
//        newMission.details = mission
//        missions.append(newMission)
        
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let newMission = NSEntityDescription.insertNewObjectForEntityForName("Mission", inManagedObjectContext: managedObjectContext) as! Mission
        newMission.details = mission
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
                print("Success")
            } catch {
                print("\(error)")
            }
        }
        
        
        
        fetchAllMissions()
        
        
        tableView.reloadData()
    }
    
    
    
    
    
    
    func missionDetailsViewController(controller: MissionDetailsViewController, didFinishEditingMission mission: Mission) {
        dismissViewControllerAnimated(true, completion: nil)
        
//        missions[indexPath] = mission
        
        
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
//        var newMission = NSEntityDescription.insertNewObjectForEntityForName("Mission", inManagedObjectContext: managedObjectContext) as! Mission
//        newMission = mission
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
                print("Success")
            } catch {
                print("\(error)")
            }
        }
        
        fetchAllMissions()
        
    
        tableView.reloadData()
    }
    
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // remove the mission at indexPath
        
//        missions.removeAtIndex(indexPath.row)
        
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        managedObjectContext.deleteObject(missions[indexPath.row] )
        
        
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
                print("Success")
            } catch {
                print("\(error)")
            }
        }
        
        
        fetchAllMissions()
        // reload the table view
        tableView.reloadData()
        
        self.editing = false
       
    }
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("EditMission", sender: tableView.cellForRowAtIndexPath(indexPath))
    }
    
    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        let movedObject = self.missions[sourceIndexPath.row]
        missions.removeAtIndex(sourceIndexPath.row)
        missions.insert(movedObject, atIndex: destinationIndexPath.row)
        NSLog("%@", "\(sourceIndexPath.row) => \(destinationIndexPath.row) \(missions)")
        
        self.tableView.reloadData()
        
    }
    


}


//
//  MissionDetailsViewController.swift
//  bucketList2
//
//  Created by Andy Feng on 8/4/16.
//  Copyright © 2016 Andy Feng. All rights reserved.
//

import UIKit

class MissionDetailsViewController: UITableViewController {
    weak var cancelButtonDelegate: CancelButtonDelegate?
    weak var delegate: MissionDetailsViewControllerDelegate?
    
    
    var missionToEdit: Mission?
    var missionToEditIndexPath: Int?
    
    @IBOutlet weak var newMissionTextField: UITextField!
    @IBAction func cancelBarButtonPressed(sender: UIBarButtonItem) {
        cancelButtonDelegate?.cancelButtonPressedFrom(self)
    }
    
    @IBAction func doneBarButtonPressed(sender: UIBarButtonItem) {
        
        if (newMissionTextField.text != "") {
            // if we are editing then run the "didFinishEditingMission" method
            if let mission = missionToEdit {
            
                mission.details = newMissionTextField.text!
                delegate?.missionDetailsViewController(self, didFinishEditingMission: mission)
            } else { // we are adding so run the "didFinishAddingMission" method
                let mission = newMissionTextField.text!
                delegate?.missionDetailsViewController(self, didFinishAddingMission: mission)
            }
        
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.newMissionTextField.becomeFirstResponder()
        
        if (missionToEdit != nil){
            newMissionTextField.text = missionToEdit?.details
        }
    }
    
    
    
    
}

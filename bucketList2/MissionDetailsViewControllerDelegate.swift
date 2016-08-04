//
//  MissionDetailsViewControllerDelegate.swift
//  bucketList2
//
//  Created by Andy Feng on 8/4/16.
//  Copyright © 2016 Andy Feng. All rights reserved.
//

import Foundation

protocol MissionDetailsViewControllerDelegate: class {
    func missionDetailsViewController(controller: MissionDetailsViewController, didFinishAddingMission mission: String)
    func missionDetailsViewController(controller: MissionDetailsViewController, didFinishEditingMission mission: String, atIndexPath indexPath: Int)
}

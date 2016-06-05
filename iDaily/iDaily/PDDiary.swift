//
//  PDDiary.swift
//  iDaily
//
//  Created by P. Chu on 6/1/16.
//  Copyright © 2016 Poodar. All rights reserved.
//

import Foundation
import CoreData

@objc(PDDiary)

class PDDiary: NSManagedObject {
    
    @NSManaged var title: String?
    @NSManaged var content: String
    
    @NSManaged var location: String?

    @NSManaged var create_date: NSDate
    @NSManaged var month: NSNumber
    @NSManaged var year: NSNumber
}

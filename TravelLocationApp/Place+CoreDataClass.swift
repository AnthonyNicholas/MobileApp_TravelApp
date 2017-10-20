//
//  Place+CoreDataClass.swift
//  TravelLocationApp
//
//  Created by Anthony Nicholas on 13/10/17.
//  Copyright © 2017 Anthony Nicholas. All rights reserved.
//

import Foundation
import CoreData


public class Place: NSManagedObject {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Place> {
        return NSFetchRequest<Place>(entityName: "Places")
    }
    
    @NSManaged public var desc: String?
    @NSManaged public var id: Int32
    @NSManaged public var name: String?
    @NSManaged public var image: NSData?

    
    
    
}

//
//  Car.swift
//  PowerupiOS
//
//  Created by Diamonique Danner on 4/14/19.
//  Copyright © 2019 Danner Op., LLC. All rights reserved.
//

import Foundation

class Car {
    var charge: Float?
    var defrosting: Bool?
    var location: Float?
    var charging: Bool?
    var nickname: String?
    
    
    init(nickname: String, currentCharge: Float, defrostingState: Bool, currentLocation: Float, chargingState: Bool){
        self.nickname = nickname
        self.charge = currentCharge
        self.defrosting = defrostingState
        self.location = currentLocation
        self.charging = chargingState
        
    }
    
    
    
}

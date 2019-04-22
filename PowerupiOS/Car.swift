//
//  Car.swift
//  PowerupiOS
//
//  Created by Diamonique Danner on 4/14/19.
//  Copyright © 2019 Danner Op., LLC. All rights reserved.
//

import Foundation
import AutoAPI

class Car {
    var charge: AAPercentage!
    var defrosting: AAActiveState!
    var location: AACoordinates!
    var charging: AAChargingState!
    var nickname: String?
    
    
    init(nickname: String, currentCharge: AAPercentage, defrostingState: AAActiveState, currentLocation: AACoordinates, chargingState: AAChargingState){
        self.nickname = nickname
        self.charge = currentCharge
        self.defrosting = defrostingState
        self.location = currentLocation
        self.charging = chargingState
    }
    
    
    
}

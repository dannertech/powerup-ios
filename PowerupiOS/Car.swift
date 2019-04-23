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
    
    var chargingValue : String!
    var chargeValue : Double!
    var latitudeValue : Double!
    var longitudeValue : Double!
    var defrostingValue : String!
    
    
    init(nickname: String, currentCharge: AAPercentage, defrostingState: AAActiveState, currentLocation: AACoordinates, chargingState: AAChargingState){
        self.nickname = nickname
        self.charge = currentCharge
        self.defrosting = defrostingState
        self.location = currentLocation
        self.charging = chargingState
    }
    
    func checkAndConvertAAValues(defrostingAA: AAActiveState, chargingAA: AAChargingState, currentLocationAA: AACoordinates, currentChargeAA: AAPercentage){
        if(defrostingAA == .active){
            self.defrostingValue = "true"
        } else {
            self.defrostingValue = "false"
        }
        if(chargingAA == .charging){
            self.chargingValue = "true"
        } else {
            self.chargingValue = "false"
        }
        self.latitudeValue = currentLocationAA.latitude as Double
        self.longitudeValue = currentLocationAA.longitude as Double
        self.chargeValue = currentChargeAA as Double
        
    }
    
    
    
}

//
//  MainViewController.swift
//  PowerupiOS
//
//  Created by Diamonique Danner on 4/1/19.
//  Copyright © 2019 Danner Opp., LLC. All rights reserved.
//
import UIKit
import FirebaseAuth
import FirebaseDatabase
import AutoAPI
import HMKit




class MainViewController: UIViewController {
    @IBOutlet var nicknameLabel: UILabel!
    @IBOutlet var carChargingLabel: UILabel!
    
    @IBOutlet var defrostingLabel: UILabel!
    var currentLocation : AACoordinates!
    var nickname : String!
    var charging : AAChargingState!
    var currentCharge : AAPercentage!
    var defrostingState : AAActiveState!
    
    var newCar : Car!
  
    @IBOutlet var chargeButtonIcon: UIButton!
    @IBOutlet var defrostButtonIcon: UIButton!
    @IBOutlet var carImage: UIImageView!
    @IBOutlet var createCarButton: UIButton!
    @IBOutlet var getVehicleDataButton: UIButton!
    @IBOutlet var updateCarStatsButton: UIButton!
    
    var ref: DatabaseReference!
    
    let userID = Auth.auth().currentUser?.displayName
    
    @IBOutlet var createCarView: CardDesign!
    
    @IBOutlet var nicknameView: CardDesign!
    @IBOutlet var carNicknameField: UITextField!
    @IBOutlet var carChargingField: UILabel!
    
    @IBOutlet var defrostingField: UILabel!

    
    @IBOutlet var carChargingView: CardDesign!
    @IBOutlet var defrostingView: CardDesign!
    
    
    @IBAction func logOut(_ sender: Any) {
        try! Auth.auth().signOut()
        self.dismiss(animated: false, completion: nil)
    }
    
    
    @IBAction func createCarButton(_ sender: Any) {
        if(self.carNicknameField.text != nil){
            let carNickname = self.carNicknameField.text
            self.nickname = carNickname
            self.getVehicleDataButton.isHidden = false
        }
        
        self.getLocation()
        self.getDefrosting()
      //  self.chargeCar()
        self.chargeEngine()
        
        
   
    }
    @IBAction func getNewVehicleDataButton(_ sender: Any) {
        self.newCar = Car(nickname: self.nickname, currentCharge: self.currentCharge, defrostingState: self.defrostingState, currentLocation: self.currentLocation, chargingState: self.charging)
        
        newCar.checkAndConvertAAValues(defrostingAA: self.newCar.defrosting, chargingAA: self.newCar.charging, currentLocationAA: self.newCar.location, currentChargeAA: self.newCar.charge)
        
        self.ref.child("users").child(self.userID! as String).child("defrosting").setValue(newCar.defrostingValue)
      /*  self.ref.child("users").child(self.userID! as String).child(newCar.nickname!).child("charging").setValue(newCar.chargingValue)
        self.ref.child("users").child(self.userID! as String).child(newCar.nickname!).child("charge").setValue(newCar.chargeValue)
        self.ref.child("users").child(self.userID! as String).child(newCar.nickname!).child("vehicle location latitude").setValue(newCar.latitudeValue)
        self.ref.child("users").child(self.userID! as String).child(newCar.nickname!).child("vehicle location longitude").setValue(newCar.longitudeValue)
 */
 }
    
    @IBAction func updateCarStats(_ sender: Any) {

        
self.newCar = Car(nickname: "PP", currentCharge: self.currentCharge, defrostingState: self.defrostingState, currentLocation: self.currentLocation, chargingState: self.charging)
     //add user here or is this even necessary
  
       
      self.newCar.checkAndConvertAAValues(defrostingAA: self.newCar.defrosting, chargingAA: self.newCar.charging, currentLocationAA: self.newCar.location, currentChargeAA: self.newCar.charge)
        
        self.carChargingField.text = self.newCar.chargingValue
        self.defrostingField.text = self.newCar.defrostingValue
     
        
       self.ref.child("users").child(self.userID! as String).child(newCar.nickname!).child("charging").setValue(newCar.chargingValue)
        self.ref.child("users").child(self.userID! as String).child(newCar.nickname!).child("charge").setValue(newCar.chargeValue)
        self.ref.child("users").child(self.userID! as String).child(newCar.nickname!).child("vehicle location latitude").setValue(newCar.latitudeValue)
        self.ref.child("users").child(self.userID! as String).child(newCar.nickname!).child("vehicle location logitude").setValue(newCar.longitudeValue)
        self.ref.child("users").child(self.userID! as String).child(newCar.nickname!).child("defrosting").setValue(newCar.defrostingValue)
        
    }
    
    @IBAction func chargeCar(_ sender: Any) {
        //definitely have to get car data and set this value or else it will be nil and cause a crash
        if(self.newCar.chargingValue == "false"){
        self.chargeCar()
            //change value
            self.newCar.chargingValue = "true"
            self.chargeButtonIcon.setImage(UIImage(named: "charging-on"), for: .normal)
            //save it to database
            self.ref.child("users").child(self.userID! as String).child("charging").setValue(self.newCar.chargingValue)
        } else {
               self.newCar.chargingValue = "false"
            self.chargeButtonIcon.setImage(UIImage(named: "charging-off"), for: .normal)
            self.chargeEngineOff()
              self.ref.child("users").child(self.userID! as String).child("charging").setValue(self.newCar.chargingValue)
            
            
         
            
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        ref = Database.database().reference()
        initialiseLocalDevice()
        
        self.getDefrosting()
        self.getLocation()
        self.chargeEngine()
        
        //attempt to read data belonging to the user
        ref.child("users").child(self.userID! as String).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            if let defrostingValue = value?["defrosting"] {
          
                
                self.defrostingField.text = defrostingValue as? String
                self.carChargingField.text = value?["charging"] as? String
                    
                //hide create car button and form
                self.createCarButton.isHidden = true
             
                self.getVehicleDataButton.isHidden = true
                self.createCarView.isHidden = true
                self.carChargingView.isHidden = false
                self.defrostingView.isHidden = false
             
                //show car and data
                self.carImage.isHidden = false
                
            } else {
                print("unsuccessful")
                self.chargeButtonIcon.isHidden = true
                self.defrostButtonIcon.isHidden = true
                self.carImage.isHidden = true
                //show create car button and corresponding form
                self.createCarButton.isHidden = false
             
                self.getVehicleDataButton.isHidden = true
                self.updateCarStatsButton.isHidden = true
                self.createCarView.isHidden = false
            }
            
        })
     
 

    //   self.ref.child(self.userID!).child(self.nickname).setValue(newCar)
        // Do any additional setup after loading the view.
    }
    @IBAction func defrost(_ sender: Any) {
        if(self.newCar.defrostingValue == "false"){
               self.defrostCar()
            //change button image
            self.defrostButtonIcon.setImage(UIImage(named: "defrost-on"), for: .normal)
            //change value before saving it to database
            self.newCar.defrostingValue = "true"
            //save to database
            self.ref.child("users").child(self.userID! as String).child("defrosting").setValue(self.newCar.defrostingValue)
        } else {
            self.defrostButtonIcon.setImage(UIImage(named: "defrost-off"), for: .normal)
            self.newCar.defrostingValue = "false"
            self.ref.child("users").child(self.userID! as String).child("defrosting").setValue(self.newCar.defrostingValue)
            
        }
    
    }
    
    func initialiseLocalDevice(){
        do {
                try HMKit.shared.initialise(
                    deviceCertificate: "dGVzdFtQKwFhjHevAyoj6vBBRDvWKZG/zdWFyVym4nlmaHrBV/ApHWjwlBpckucKcbnXcQcG4G1Hp1pvAB4+Seb++epENYLxCOlWKN5OsdOjBTLt2NiYCw7mDiMCkPWgHWmrqdM0Xtfp5UwTJT2foqJU/aKVR+htz1swq5cUAoYt0SU16SQnT1PYXJaiNXENYrlgwX4rx3VZ",
                    devicePrivateKey: "XBosI7J7RAWbPPYBI+f5tRxJOD6lthUkC7wTK92LfhI=",
                    issuerPublicKey: "EUdVj6PpTCdo4Nc5FQBfenJ7f3X9tNjZHedgFHw4dwjHCYlJQU/YkdBHWLgsXPLpinKD7wedAPlG+MnzTOmloQ=="
            )
        }
        catch {
            // Handle the error
            print("Invalid initialisation parameters, please double-check the snippet: \(error)")
        }
    }
    
    
    func chargeEngine(){
        do {
            let accessToken: String = "4bed3ceb-8113-4250-a34b-fd6d3dee371f"
            
            
            guard accessToken != "4bed3ceb-8113-4250-a34b-fd6d3dee371f " else {
                fatalError("Please get the ACCESS TOKEN with the instructions above, thanks")
            }
            try HMTelematics.downloadAccessCertificate(accessToken: accessToken){
                result in
                if case HMTelematicsRequestResult.success(let serial) = result {
                    print("certificate downloaded, sending command through telematics")
                    do{
                        try HMTelematics.sendCommand(AACharging.getChargingState.bytes, serial: serial) {
                            response in
                            if case HMTelematicsRequestResult.success(let data) = response {
                                guard let data = data else {
                                    return print("missing response data")
                                }
                                guard let chargingInformation = AutoAPI.parseBinary(data) as? AACharging
                                    else {
                                        return print("failed to parse Auto API")
                                }
                                self.currentCharge = chargingInformation.batteryLevel?.value!
                               self.charging = chargingInformation.state?.value!
                                print(self.currentCharge!)
                                print(self.charging!)
                            } else {
                                print("unable to get charging data")
                            }
                        }
                    } catch {
                        print("failed to send command")
                    }
                } else {
                    print("failed to download certificate")
                }
            }
            
        } catch {
            print("Download cert error: \(error)")
        }
    }
    
    func chargeEngineOff(){
        do {
            let accessToken: String = "4bed3ceb-8113-4250-a34b-fd6d3dee371f"
            
            
            guard accessToken != "4bed3ceb-8113-4250-a34b-fd6d3dee371f " else {
                fatalError("Please get the ACCESS TOKEN with the instructions above, thanks")
            }
            try HMTelematics.downloadAccessCertificate(accessToken: accessToken){
                result in
                if case HMTelematicsRequestResult.success(let serial) = result {
                    print("certificate downloaded, sending command through telematics")
                    do{
                        try HMTelematics.sendCommand(AACharging.startStopCharging(AAActiveState.inactive).bytes, serial: serial) {
                            response in
                            if case HMTelematicsRequestResult.success(let data) = response {
                                guard let data = data else {
                                    return print("missing response data")
                                }
                                guard let chargingInformation = AutoAPI.parseBinary(data) as? AACharging
                                    else {
                                        return print("failed to parse Auto API")
                                }
                                
                                print(chargingInformation)
                            } else {
                                print("unable to get charging data")
                            }
                        }
                    } catch {
                        print("failed to send command")
                    }
                } else {
                    print("failed to download certificate")
                }
            }
            
        } catch {
            print("Download cert error: \(error)")
        }
    }
    
    
    func getLocation(){
        do {
            let accessToken: String = "4bed3ceb-8113-4250-a34b-fd6d3dee371f"
            
            
            guard accessToken != "4bed3ceb-8113-4250-a34b-fd6d3dee371f " else {
                fatalError("Please get the ACCESS TOKEN with the instructions above, thanks")
            }
            try HMTelematics.downloadAccessCertificate(accessToken: accessToken){
                result in
                if case HMTelematicsRequestResult.success(let serial) = result {
                    print("certificate downloaded, sending command through telematics")
                    do{
                        try HMTelematics.sendCommand(AAVehicleLocation.getLocation.bytes, serial: serial) {
                            response in
                            if case HMTelematicsRequestResult.success(let data) = response {
                                guard let data = data else {
                                    return print("missing response data")
                                }
                                guard let locationInformation = AutoAPI.parseBinary(data) as? AAVehicleLocation
                                    else {
                                        return print("failed to parse Auto API")
                                }
                                self.currentLocation = locationInformation.coordinates?.value!
                                print(self.currentLocation.latitude)
                                
                            } else {
                                print("unable to get charging data")
                            }
                        }
                    } catch {
                        print("failed to send command")
                    }
                } else {
                    print("failed to download certificate")
                }
            }
            
        } catch {
            print("Download cert error: \(error)")
        }
    }
    
    
    func getDefrosting(){
        do {
            let accessToken: String = "4bed3ceb-8113-4250-a34b-fd6d3dee371f"
            
            
            guard accessToken != "4bed3ceb-8113-4250-a34b-fd6d3dee371f " else {
                fatalError("Please get the ACCESS TOKEN with the instructions above, thanks")
            }
            try HMTelematics.downloadAccessCertificate(accessToken: accessToken){
                result in
                if case HMTelematicsRequestResult.success(let serial) = result {
                    print("certificate downloaded, sending command through telematics")
                    do{
                        try HMTelematics.sendCommand(AAClimate.getClimateState.bytes, serial: serial) {
                            response in
                            if case HMTelematicsRequestResult.success(let data) = response {
                                guard let data = data else {
                                    return print("missing response data")
                                }
                                guard let climateInformation = AutoAPI.parseBinary(data) as? AAClimate
                                    else {
                                        return print("failed to parse Auto API")
                                }
                               
                                self.defrostingState = climateInformation.defrostingState?.value!
                                print(self.defrostingState!)
                            } else {
                                print("unable to get charging data")
                            }
                        }
                    } catch {
                        print("failed to send command")
                    }
                } else {
                    print("failed to download certificate")
                }
            }
            
        } catch {
            print("Download cert error: \(error)")
        }
    }

    func defrostCar(){
        do {
            let accessToken: String = "4bed3ceb-8113-4250-a34b-fd6d3dee371f"
            
            
            guard accessToken != "4bed3ceb-8113-4250-a34b-fd6d3dee371f " else {
                fatalError("Please get the ACCESS TOKEN with the instructions above, thanks")
            }
            try HMTelematics.downloadAccessCertificate(accessToken: accessToken){
                result in
                if case HMTelematicsRequestResult.success(let serial) = result {
                    print("certificate downloaded, sending command through telematics")
                    do{
                        try HMTelematics.sendCommand(AAClimate.startStopDefrosting(AAActiveState.active).bytes, serial: serial) {
                            response in
                            if case HMTelematicsRequestResult.success(let data) = response {
                                guard let data = data else {
                                    return print("missing response data")
                                }
                                guard let climateInformation = AutoAPI.parseBinary(data) as? AAClimate
                                    else {
                                        return print("failed to parse Auto API")
                                }
                                
                                self.defrostingState = climateInformation.defrostingState?.value!
                                
                                if(self.newCar.defrostingValue == "false"){
                                    self.newCar.defrostingValue = "true"
                                } else {
                                    self.newCar.defrostingValue = "false"
                                }
                                self.ref.child("users").child(self.userID! as String).child("defrosting").setValue(self.newCar.defrostingValue)
                                print(self.defrostingState!)
                            } else {
                                print("unable to get charging data")
                            }
                        }
                    } catch {
                        print("failed to send command")
                    }
                } else {
                    print("failed to download certificate")
                }
            }
            
        } catch {
            print("Download cert error: \(error)")
        }
    }
    
    func defrostCarOff(){
        if(self.newCar.defrostingValue == "true"){
            do {
                let accessToken: String = "4bed3ceb-8113-4250-a34b-fd6d3dee371f"
                
                
                guard accessToken != "4bed3ceb-8113-4250-a34b-fd6d3dee371f " else {
                    fatalError("Please get the ACCESS TOKEN with the instructions above, thanks")
                }
                try HMTelematics.downloadAccessCertificate(accessToken: accessToken){
                    result in
                    if case HMTelematicsRequestResult.success(let serial) = result {
                        print("certificate downloaded, sending command through telematics")
                        do{
                            try HMTelematics.sendCommand(AAClimate.startStopDefrosting(AAActiveState.inactive).bytes, serial: serial) {
                                response in
                                if case HMTelematicsRequestResult.success(let data) = response {
                                    guard let data = data else {
                                        return print("missing response data")
                                    }
                                    guard let climateInformation = AutoAPI.parseBinary(data) as? AAClimate
                                        else {
                                            return print("failed to parse Auto API")
                                    }
                                    
                                    self.defrostingState = climateInformation.defrostingState?.value!
                                    self.newCar.defrostingValue = "false"
                                    self.ref.child("users").child(self.userID! as String).child("defrosting").setValue(self.newCar.defrostingValue)
                                    print(self.defrostingState!)
                                } else {
                                    print("unable to get defrost AAClimate data")
                                }
                            }
                        } catch {
                            print("failed to send command")
                        }
                    } else {
                        print("failed to download certificate")
                    }
                }
                
            } catch {
                print("Download cert error: \(error)")
            }
        }
    }

    
    func chargeCar(){
        do {
            let accessToken: String = "4bed3ceb-8113-4250-a34b-fd6d3dee371f"
            
            
            guard accessToken != "4bed3ceb-8113-4250-a34b-fd6d3dee371f " else {
                fatalError("Please get the ACCESS TOKEN with the instructions above, thanks")
            }
            try HMTelematics.downloadAccessCertificate(accessToken: accessToken){
                result in
                if case HMTelematicsRequestResult.success(let serial) = result {
                    print("certificate downloaded, sending command through telematics")
                    do{
                        try HMTelematics.sendCommand(AACharging.startStopCharging(AAActiveState.active).bytes, serial: serial) {
                            response in
                            if case HMTelematicsRequestResult.success(let data) = response {
                                guard let data = data else {
                                    return print("missing response data")
                                }
                                guard let chargingInformation = AutoAPI.parseBinary(data) as? AACharging
                                    else {
                                        return print("failed to parse Auto API")
                                }
                                
                                print(chargingInformation)
                            } else {
                                print("unable to get charging data")
                            }
                        }
                    } catch {
                        print("failed to send command")
                    }
                } else {
                    print("failed to download certificate")
                }
            }
            
        } catch {
            print("Download cert error: \(error)")
        }
    }
    
    
}


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
    var ref: DatabaseReference!
    
    var newCar = Car(nickname: "PP", currentCharge: 85.6, defrostingState: false, currentLocation: 1000.0, chargingState: false)
    
    
    
    
    @IBAction func logOut(_ sender: Any) {
        try! Auth.auth().signOut()
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func addUser(_ sender: Any) {
        let userID = Auth.auth().currentUser?.displayName
        self.ref.child("users").child(userID!).child(self.newCar.nickname!).child("charge").setValue(self.newCar.charge)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialiseLocalDevice()
        
        ref = Database.database().reference()
        
        // Do any additional setup after loading the view.
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
                                guard let chargingInformation = AutoAPI.parseBinary(data) as? AACharging else {
                                    return print("failed to parse Auto API")
                                }
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

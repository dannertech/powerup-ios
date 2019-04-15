//
//  ViewController.swift
//  PowerupiOS
//
//  Created by Diamonique Danner on 3/26/19.
//  Copyright © 2019 Danner Opp., LLC. All rights reserved.
//
import UIKit
import HMKit
import AutoAPI


class ViewController: UIViewController{
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialiseLocalDevice();
        downloadCertificate();
        
        
        
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
    
    func downloadCertificate(){
        
        do {
            let accessToken: String = "4bed3ceb-8113-4250-a34b-fd6d3dee371f"
            
            
            guard accessToken != "4bed3ceb-8113-4250-a34b-fd6d3dee371f " else {
                fatalError("Please get the ACCESS TOKEN with the instructions above, thanks")
            }
            
            
            // Send a command to the car through Telematics.
            // Make sure that the emulator is OPENED for this to work,
            // otherwise "Vehicle asleep" could be returned.
            try HMTelematics.downloadAccessCertificate(accessToken: accessToken) { result in
                if case HMTelematicsRequestResult.success(let serial) = result {
                    print("Certificate downloaded, sending command through telematics.")
                    print(serial)
                    do {
                        try HMTelematics.sendCommand(AADoorLocks.lockUnlock(.unlocked).bytes, serial: serial) { response in
                            if case HMTelematicsRequestResult.success(let data) = response {
                                guard let data = data else {
                                    return print("Missing response data")
                                }
                                
                                guard let locks = AutoAPI.parseBinary(data) as? AADoorLocks else {
                                    return print("Failed to parse Auto API")
                                }
                                
                                print("Got the new lock state \(locks).")
                            }
                            else {
                                print("Failed to lock the doors \(response).")
                            }
                        }
                    }
                    catch {
                        print("Failed to send command:", error)
                    }
                }
                else {
                    print("Failed to download certificate \(result).")
                }
            }
        }
        catch {
            print("Download cert error: \(error)")
        }
    }
    
    
}

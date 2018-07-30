//  Created by Jonathan Silva Figueroa on 28/07/18.
//  Copyright © 2018 Jonathan Silva Figueroa. All rights reserved.
//

import UIKit

public struct RemoteDeviceInfo {
    
    let identifier: String
    let model: String
    let deviceName: String
    let deviceSystem: String
    let deviceSystemVersion: String
    let deviceType: String
    
    public init(device: UIDevice, screen: UIScreen) {
        identifier = device.identifierForVendor?.uuidString ?? "UnknownId"
        model = device.localizedModel
        deviceName = device.name
        deviceSystem = device.systemName
        deviceSystemVersion = device.systemVersion
        
        switch screen.nativeBounds.height {
        case 1136:
            deviceType = "iPhone 5 or 5S or 5C or SE"
        case 1334:
            deviceType = "iPhone 6/6S/7/8"
        case 1920, 2208:
            deviceType = "iPhone 6+/6S+/7+/8+"
        case 2436:
            deviceType = "iPhone X"
        default:
            deviceType = "Unknown"
        }
    }
    
}

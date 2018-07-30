//  Created by Jonathan Silva Figueroa on 28/07/18.
//  Copyright © 2018 Jonathan Silva Figueroa. All rights reserved.
//

import UIKit

public class RemoteLogger {
    
    public static var shared: RemoteLogger! {
        return instance
    }
    
    private static var instance: RemoteLogger!
    
    public enum LogLevel: Int {
        case verbose
        case informative
        case warnings
        case error
    }
    
    public typealias LogTypeSet = Set<LogLevel>
    var activeLogTypes: LogTypeSet
    var baseUrl: String!
    var device: RemoteDeviceInfo
    var logInternal: Set<LogLevel>?
    
    public init(baseUrl: String, logs: LogTypeSet, device: UIDevice, screen: UIScreen, internalLog: LogTypeSet? = nil) {
        self.baseUrl = baseUrl
        self.activeLogTypes = logs
        self.device = RemoteDeviceInfo(device: device, screen: screen)
        logInternal = internalLog
        
        RemoteLogger.instance = self
    }
    
    private func internalLog(_ type: LogLevel, _ log: String) {
        guard let logTypes = logInternal, logTypes.contains(type) else {
            return
        }
        print(log)
    }
    
    private func formatMessage(_ type: LogLevel, message: String) -> String {
        let emoticon: String
        switch type {
        case .informative:
            emoticon = "Informative"
        case .verbose:
            emoticon = "Verbose"
        case .warnings:
            emoticon = "Warning"
        case .error:
            emoticon = "Error"
        }
        let logFormat = String(format: "[%@] - %@", emoticon, message)
        internalLog(.verbose, logFormat)
        return logFormat
    }
    
    private func formatBody(_ message: String) -> Data? {
        let json: [String: Any] = [
            "deviceIdentifier": device.identifier,
            "deviceModel": device.model,
            "deviceType": device.deviceType,
            "deviceName": device.deviceName,
            "deviceSystem": device.deviceSystem,
            "deviceSystemVersion": device.deviceSystemVersion,
            "message": message
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            return jsonData
        } catch {
            internalLog(.error, "Error: \(error)")
            return nil
        }
    }
    
    public func log(type: LogLevel, message: String) {
        let logMessage = formatMessage(type, message: message)
        remoteLog(message: logMessage)
    }
    
    private func remoteLog(message: String) {
        guard let url = URL(string: baseUrl) else {
            internalLog(.error, "[❌❌❌] - The BaseUrl is not a valid url")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = formatBody(message)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            if let data = data, let dataString = String(data: data, encoding: String.Encoding.utf8) {
                print(dataString)
            }
            if error != nil {
                self?.internalLog(.error, "[❌❌❌] - Error logging remotetly: \(error!)")
            }
        }
        task.resume()
    }
    
}

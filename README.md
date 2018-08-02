# swiftyremotelogger
A simple remote logger to get logs from 

###Features

- Get remote logs from all devices
- Get them directly in your own server
- You only need one line of code to configure it

**Table of Contents**

[TOC]

# Installation
##Cocoapods
Add this to your Podfile:

`pod SwiftyRemoteLogger`

and run this in your terminal

`pod install`

# Usage

In the AppDelegate import it with:

`import SwiftyRemoteLogger`

And configure it with

`RemoteLogger(baseUrl: "your server url", logs: [.verbose, .informative, .warnings, .error], device: UIDevice.current, screen: UIScreen.main)`

And thats it, now you only need to call the module functions in order to trigger the logs. For example:

```swift
RemoteLogger.shared.log(type: .informative, message: "An informative log")
RemoteLogger.shared.log(type: .verbose, message: "A verbose log")
RemoteLogger.shared.log(type: .warnings, message: "A warning log")
RemoteLogger.shared.log(type: .error, message: "An error log")
```

# Extension

In order to have a single file with all the functions, my recomendation is to have them in a LogExtension.swift file with the following:

```swift
import Foundation
import SwiftyRemoteLogger

func inform(_ message: String) {
    RemoteLogger.shared.log(type: .informative, message: message)
}

func verbose(_ message: String) {
    RemoteLogger.shared.log(type: .verbose, message: message)
}

func warn(_ message: String) {
    RemoteLogger.shared.log(type: .warnings, message: message)
}

func error(_ message: String) {
    RemoteLogger.shared.log(type: .error, message: message)
}
```

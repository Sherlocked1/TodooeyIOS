//Copyright © 2023 Mohammed

import SystemConfiguration
import Foundation

enum APIError : Error {
    case Connection
}

extension APIError:LocalizedError {
    public var errorDescription: String?{
        switch self{
        case .Connection:
            return "Please check your internet connection and try again"
        }
    }
}

// Function to check if device is connected to internet
func isOnline() -> Bool {
    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
    zeroAddress.sin_family = sa_family_t(AF_INET)
    
    // Guard statement to check if creating a pointer to zeroAddress was successful
    guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
            SCNetworkReachabilityCreateWithAddress(nil, $0)
        }
    }) else {
        // Return false if pointer creation was not successful
        return false
    }
    
    var flags = SCNetworkReachabilityFlags()
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
        // Return false if unable to get flags
        return false
    }
    
    // Check if the reachable flag is set
    let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
    // Check if the connection required flag is set
    let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
    // Return true if both flags are not set, indicating device is connected to internet
    return (isReachable && !needsConnection)
}

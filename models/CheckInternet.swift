//
//  CheckInternet.swift
//  MassagesApp
//
//  Created by raz cohen on 19/06/2020.
//  Copyright © 2020 raz cohen. All rights reserved.
//

import SystemConfiguration

struct CheckInternet{
    
     func isConnected(with flags: SCNetworkReachabilityFlags)->Bool{
        let isReachable = flags.contains(.reachable)

        return isReachable
    }
    
    func isOnline() -> Bool{
          
          let reachability = SCNetworkReachabilityCreateWithName(nil, "www.google.com")
          var flags = SCNetworkReachabilityFlags()
          SCNetworkReachabilityGetFlags(reachability!, &flags)
          
          return isConnected(with: flags)
      }
}

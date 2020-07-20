//
//  SendEmail.swift
//  MassagesApp
//
//  Created by raz cohen on 01/07/2020.
//  Copyright © 2020 raz cohen. All rights reserved.
//

import Foundation

struct SendEmail{
    
    func sendEmail(htmlBody:String , subject:String , from:String , to:String ,
                   custumerEmail:String , mailToCustomer:Bool){
        
        let ownerEmail = ""
        let claientEmail = ""
        let smtpSession = MCOSMTPSession()
        smtpSession.hostname = "smtp.gmail.com"
        smtpSession.username = ownerEmail
        smtpSession.password = "*******"
        smtpSession.port = 465
        smtpSession.authType = MCOAuthType.saslPlain
        smtpSession.connectionType = MCOConnectionType.TLS
        smtpSession.connectionLogger = {(connectionID, type, data) in
            if data != nil {
                if let string = NSString(data: data!, encoding: String.Encoding.utf8.rawValue){
                    NSLog("Connectionlogger: \(string)")
                }
            }
        }
        let builder = MCOMessageBuilder()
        
        if mailToCustomer{
            
           builder.header.to = [MCOAddress(displayName: from, mailbox: claientEmail)!]
            
        }else{
            
           builder.header.to = [MCOAddress(displayName: to, mailbox: ownerEmail)!]
            
        }
        
        builder.header.from = MCOAddress(displayName: from, mailbox: ownerEmail)
        builder.header.subject = subject
        builder.htmlBody = htmlBody
        
        let rfc822Data = builder.data()
        let sendOperation = smtpSession.sendOperation(with: rfc822Data)
        sendOperation?.start { (error) -> Void in
            if (error != nil) {
                NSLog("Error sending email: \(error!)")
                
                
            } else {
                NSLog("Successfully sent email!")
            }
        }
    }
    
}

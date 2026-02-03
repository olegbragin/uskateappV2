//
//  WatchConnectivityProvider.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 07.12.2025.
//
import Combine
import WatchConnectivity

struct NotificationMessage: Identifiable {
    let id = UUID()
    let text: String
}

final class WatchConnectivityProvider: NSObject {
    
    @Published var notification: NotificationMessage? = nil
    
    private let session: WCSession
    
    init(session: WCSession = WCSession.default) {
        self.session = session
        super.init()
        self.session.delegate = self
    }
    
    func connect() {
        guard WCSession.isSupported() else {
            print("WCSession is not supported")
            return
        }
       
        session.activate()
    }
    
    func send(message: [String:Any]) -> Void {
        guard
            session.activationState == .activated
        else { return }
        #if os(iOS)
        guard
            session.isWatchAppInstalled,
            session.isPaired
        else { return }
        #endif
        session.sendMessage(message, replyHandler: nil) { error in
            print(error)
        }
    }
}

extension WatchConnectivityProvider: WCSessionDelegate {
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let notificationText = message["auth"] as? String {
            DispatchQueue.main.async { [weak self] in
                self?.notification = NotificationMessage(text: notificationText)
            }
        }
        print("received")
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {

    }

    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) { }
    
    func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }
    
    #endif
}

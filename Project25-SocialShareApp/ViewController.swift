//
//  ViewController.swift
//  Project25-SocialShareApp
//
//  Created by Ishaq Amin on 04/05/2020.
//  Copyright © 2020 Ishaq Amin. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ViewController: UICollectionViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, MCSessionDelegate, MCBrowserViewControllerDelegate {
    
    
    var images = [UIImage]()
    var peerID = MCPeerID(displayName: UIDevice.current.name)
    var mcSession:MCSession?
    var mcAdvertisersAssistant: MCAdvertiserAssistant
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Selfie Share"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(importPicture))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showConnectionPrompt))
        
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession?.delegate = self
    }
    
    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
        
    }
    @objc func showConnectionPrompt() {
        let ac = UIAlertController(title: "Connect to others", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Host a session", style: .default, handler: startHosting))
        ac.addAction(UIAlertAction(title: "Join a session", style: .default, handler: joinSession))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    }
    
    func imagePIckerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any ]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        
        dismiss(animated: true)
        
        images.insert(image, at: 0)
        collectionView.reloadData()
    }
    
    func startHosting(action: UIAlertAction) {
        guard let mcSession = mcSession else {return}
       var mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "hws-project25", discoveryInfo: nil, session: mcSession)
        mcAdvertiserAssistant.start()
    }
    func joinSession(action: UIAlertAction) {
        guard let mcSession = mcSession else {return}
        let mcBrowser = MCBrowserViewController(serviceType: "hws-project25", session: mcSession)
        mcBrowser.delegate = self
        present(mcBrowser,animated: true)
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            print("Connected: \(peerID.displayName)")
            
        case .connecting:
            print("Not connected: \(peerID.displayName)")
            
        case .notConnected:
            print("Not connected: \(peerID.displayName)")
            
        @unknown default:
            print("Unknown state received: \(peerID.displayName)")
        }
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageView", for: indexPath)
        
        if let imageView = cell.viewWithTag(1000) as? UIImageView {
            imageView.image = images[indexPath.item]
        }
        
        return cell
    }
    
    
}


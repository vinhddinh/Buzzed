//
//  HomeViewController.swift
//  buzzed
//
//  Created by Danielle Alota on 11/5/22.
//

import UIKit
import MultipeerConnectivity
import CoreData


class HomeViewController: UIViewController, MCBrowserViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("\(mpcHandler.session.connectedPeers)")

    }
    
    @IBAction func joinButtonPressed(_ sender: Any) {
        mpcHandler.setupBrowser()
        mpcHandler.browser.delegate = self
        self.present(mpcHandler.browser, animated: true, completion: nil)
    }
    
    
    @IBAction func hostButtonPressed(_ sender: Any) {
        let request = PlayerMO.fetchRequest() as NSFetchRequest<PlayerMO>
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do{
            if let result = try? context.fetch(request){
                for player in result {
                    context.delete(player)
                }
            }
            try context.save()
        } catch {
            
        }
        mpcHandler.advertiseSelf(advertise: true)
    }
    
    /*** Lots of MultipeerConnectivity functions **/
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
        let gameVC = self.storyboard?.instantiateViewController(withIdentifier: "GamePlayer") as! GamePlayerViewController
        gameVC.modalPresentationStyle = .fullScreen
        self.present(gameVC, animated: true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //         Get the new view controller using segue.destination.
        //         Pass the selected object to the new view controller.
        if segue.destination is GamePlayerViewController {
            _ = segue.destination as? GamePlayerViewController
            
        }
    }
}

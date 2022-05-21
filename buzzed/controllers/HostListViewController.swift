//
//  HostListViewController.swift
//  buzzed
//
//  Created by Danielle Alota on 11/5/22.
//

import UIKit

class HostListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        mpcHandler.setupPeerWithDisplayName(displayName: UIDevice.current.name)
        mpcHandler.setupBrowser()
        self.present(mpcHandler.browser, animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

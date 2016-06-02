//
//  PDLoginVC.swift
//  iDaily
//
//  Created by P. Chu on 6/2/16.
//  Copyright © 2016 Poodar. All rights reserved.
//

import UIKit

class PDLoginVC: UIViewController {

    @IBOutlet weak var PDUserName: UITextField!
    @IBOutlet weak var PDPassWord: UITextField!
    @IBOutlet weak var PDCancelBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    @IBAction func login(sender: UIButton) {
        let dvc  = self.storyboard?.instantiateViewControllerWithIdentifier("PDNavController") as! PDNavController
        self.presentViewController(dvc, animated: true, completion: nil)
    }
}

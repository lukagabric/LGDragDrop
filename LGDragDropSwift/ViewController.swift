//
//  ViewController.swift
//  LGDragDropSwift
//
//  Created by Luka Gabric on 04/09/15.
//  Copyright © 2015 Luka Gabric. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func showDragDropView() {
        let dragDropViewController = LGDragDropViewController();
        dragDropViewController.completion = { [weak self] in
            self?.dismissViewControllerAnimated(true, completion: nil)
        }
        self.presentViewController(dragDropViewController, animated: true, completion: nil)
    }

}


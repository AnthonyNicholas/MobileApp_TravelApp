//
//  InterviewViewController.swift
//  OpenDayApp
//
//  Created by Anthony Nicholas on 19/11/17.
//  Copyright © 2017 Anthony Nicholas. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import AVFoundation
import WebKit

class InterviewViewController: UIViewController, UINavigationControllerDelegate, UITextFieldDelegate, WKNavigationDelegate {

    let userDAO: UserDAO = UserDAO()
    weak var person: User?
    @IBOutlet weak var InterviewVideoView: WKWebView!
    @IBOutlet weak var personNameLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    let vidQueue = DispatchQueue(label: "videoQueue")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        personNameLabel.text = (person?.firstName)! + " " + (person?.lastName)!

        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        InterviewVideoView.center = self.view.center
        InterviewVideoView.navigationDelegate = self
//        let url = URL(string: "https://youtu.be/CUvZJ-DoeL0?t=59s")
        let url = URL(string: (person?.getVideo())!)
        let request = URLRequest(url: url!)
        print("starting")
        InterviewVideoView.load(request)
    }
    
    func webView(_ InterviewVideoView: WKWebView, didFinish navigation: WKNavigation!) {
        print("stopping")
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

    


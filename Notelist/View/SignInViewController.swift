//
//  SignInViewController.swift
//  Notelist
//
//  Created by cao duc tin  on 31/12/24.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var UserNametxt: UILabel!
    
    @IBOutlet weak var UserNameLable: UILabel!
    @IBOutlet weak var PasswrodLabel: UILabel!
    @IBOutlet weak var guildLabel: UILabel!
    @IBOutlet weak var ForgetLabel: UILabel!
    @IBOutlet weak var LoginLabel: UILabel!
    @IBOutlet weak var languageUISwitch: UISwitch!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
             if let selectedLanguage = UserDefaults.standard.string(forKey: "selectedLanguage") {
                 languageUISwitch.isOn = selectedLanguage == "vi"
             }
             // Update language when the view is loaded
             updateLanguage()
    }

    @IBAction func languageSwitchChanged(_ sender: Any) {
        updateLanguage()
        print("\(languageUISwitch.isOn)")
        //  reloadRootViewController()
        updateLabel()
    }
  
    
    @IBAction func btnLoginAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
              
        if let mainVC = storyboard.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController {
            let navController = UINavigationController(rootViewController: mainVC)
            navController.modalPresentationStyle = .fullScreen
            self.present(navController, animated: true, completion: nil)
        } else {
            print("Error: MainViewController không tìm thấy trong Storyboard")
        }
        

    }
    
    // Update the language based on switch status
    func updateLanguage() {
        if languageUISwitch.isOn {
            // Set language to Vietnamese
            UserDefaults.standard.set("vi", forKey: "selectedLanguage")
            Bundle.setLanguage("vi")
        } else {
            // Set language to English
            UserDefaults.standard.set("en", forKey: "selectedLanguage")
            Bundle.setLanguage("en")
        }
  
    }
    
    private func updateLabel(){
        passwordTextField.placeholder = NSLocalizedString("5sn-mt-VNL.placeholder", comment: "Greeting message")
        ForgetLabel.text = NSLocalizedString("K93-X4-heS.text", comment: "Greeting message")
        guildLabel.text = NSLocalizedString("P0B-xn-0zK.text", comment: "Greeting message")
        LoginLabel.text = NSLocalizedString("qrq-0N-ZGs.text", comment: "Greeting message")
        PasswrodLabel.text = NSLocalizedString("jVH-ZQ-aZj.text", comment: "Greeting message")
        UserNameLable.text = NSLocalizedString("username_label", comment: "Greeting message")
    }
    
}
import Foundation

extension Bundle {
     static var bundle: Bundle!

    class func setLanguage(_ language: String) {
        guard let path = Bundle.main.path(forResource: language, ofType: "lproj") else { return }
        bundle = Bundle(path: path)
        object_setClass(Bundle.main, MyBundle.self)
    }

    class func localizedString(forKey key: String, value: String?, table: String?) -> String {
        return bundle.localizedString(forKey: key, value: value, table: table)
    }
}

// Override Bundle.main to use the custom language bundle
class MyBundle: Bundle {
    override func localizedString(forKey key: String, value: String?, table: String?) -> String {
        return Bundle.bundle.localizedString(forKey: key, value: value, table: table)
    }
}

//func reloadRootViewController() {
//    let storyboard = UIStoryboard(name: "Main", bundle: nil)
//    
//    // Assuming your initial view controller is named "SignInViewController"
//    let rootViewController = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
//    
//    // Set new root view controller
//    if let window = UIApplication.shared.windows.first {
//        window.rootViewController = rootViewController
//        window.makeKeyAndVisible()
//        
//        // Optional: Add a transition for a smoother experience
//        let transition = CATransition()
//        transition.type = .fade
//        transition.duration = 0.5
//        window.layer.add(transition, forKey: kCATransition)
//    }
//}

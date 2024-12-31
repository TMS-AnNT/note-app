//
//  SignInViewController.swift
//  Notelist
//
//  Created by cao duc tin  on 31/12/24.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var UserNametxt: UILabel!
    
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        //UserNametxt.text = NSLocalizedString("username_label", comment: "Username field label")

        // Do any additional setup after loading the view.

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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

















// Localize các UILabel
//            recomendLabel.text = NSLocalizedString("recommend_text", comment: "Recommended text for the user")
//                TextLabel.text = NSLocalizedString("text_label", comment: "Text label description")
//                LoginLable.text = NSLocalizedString("login_label", comment: "Login button text")
//                PasswordLabel.text = NSLocalizedString("password_label", comment: "Password field label")

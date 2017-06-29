

import UIKit
import Parse

class ViewController: UIViewController{
    
    
    
    

    var signupMode = true
    
    var activityIndicator = UIActivityIndicatorView()
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    func createAlert(title: String, message: String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func signupOrLogin(_ sender: Any) {
        
        if emailTextField.text == "" || passwordTextField.text == "" {
            
            createAlert(title: "Error in form", message: "Please enter an email and password")
            
        } else{
            
            
            activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            if signupMode{
                
                //Sign up
                
                let user = PFUser()
                
                user.username = emailTextField.text
                user.email = emailTextField.text
                user.password = passwordTextField.text
                
                user.signUpInBackground(block: { (success, error) in
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    if error != nil {
                        
                        var displayErrorMessage = "Please try again later"
                        
                        if let errorMessage = error?.localizedDescription{
                            
                            displayErrorMessage = errorMessage
                            
                            
                        }
                        
                        self.createAlert(title: "Signup Error", message: displayErrorMessage)
                        
                    }else{
                        
                        print("User Signed Up")
                        
                        self.performSegue(withIdentifier: "showUserTable", sender: self)
                    }
                })
            }else{
                
                //Login Mode
                PFUser.logInWithUsername(inBackground: emailTextField.text!, password: passwordTextField.text!, block: { (user, error) in
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    if error != nil {
                            
                        var displayErrorMessage = "Please try again later"
                            
                        if let errorMessage = error?.localizedDescription{
                                
                            displayErrorMessage = errorMessage
                                
                                
                        }
                            
                        self.createAlert(title: "Login Error", message: displayErrorMessage)
                            
                    }else{
                            
                        print("Logged In")
                        
                        self.performSegue(withIdentifier: "showUserTable", sender: self)
                        
                    }
                        
                })
                
                
            }
            
            
            
        }
    }
    
    
    @IBOutlet weak var signupOrLogin: UIButton!
    
    @IBAction func changeSignupMode(_ sender: Any) {
        
        if signupMode {
            
            //Change to login mode
            
            signupOrLogin.setTitle("Log In", for: [])
            
            changeSignupModeButton.setTitle("Sign Up", for: [])
            
            messageLabel.text = "Don't have an account?"
            
            signupMode = false
        } else{
            
            //Change to signup mode
            
            signupOrLogin.setTitle("Sign up", for: [])
            
            changeSignupModeButton.setTitle("Log In", for: [])
            
            messageLabel.text = "Already have an account?"
            
            signupMode = true
            
        }
    }
    
    @IBOutlet weak var changeSignupModeButton: UIButton!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        
        if PFUser.current() != nil{
            
            performSegue(withIdentifier: "showUserTable", sender: self)
        }
        
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
     
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

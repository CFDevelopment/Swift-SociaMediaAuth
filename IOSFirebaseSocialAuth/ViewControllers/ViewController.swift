import UIKit
import FBSDKLoginKit
import Firebase
import GoogleSignIn

class ViewController: UIViewController, FBSDKLoginButtonDelegate, GIDSignInUIDelegate {

    @IBOutlet var fbButton : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpFacebookButtons()
        setUpGoogleButtons()
    }
    
    fileprivate func setUpGoogleButtons() {
        //google signin
        let btnGoogle = GIDSignInButton()
        btnGoogle.frame = CGRect(x: 16, y: 116 + 66, width: view.frame.width - 32, height: 50)
        view.addSubview(btnGoogle)
        //custom google btn
        let btnGoogleCustom = UIButton(type: .system)
        btnGoogleCustom.frame = CGRect(x: 16, y: 116 + 66 + 66, width: view.frame.width - 32, height: 50)
        btnGoogleCustom.backgroundColor = .orange
        btnGoogleCustom.setTitle("Custom Google Sign In", for: .normal)
        btnGoogleCustom.addTarget(self, action: #selector(handleCustomGoogleLogin), for: .touchUpInside)
        view.addSubview(btnGoogleCustom)
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    fileprivate func setUpFacebookButtons() {
        let btnLogin = FBSDKLoginButton()
        view.addSubview(btnLogin)
        btnLogin.frame = CGRect(x: 16, y: 50, width: view.frame.width - 32, height: 50)
        btnLogin.delegate = self
        btnLogin.readPermissions = ["email", "public_profile"]
        //custom facebook button
        let customBtn = UIButton(type: .system)
        customBtn.backgroundColor = .blue
        customBtn.frame = CGRect(x: 16, y: 116, width: view.frame.width - 32, height: 50)
        customBtn.setTitle("Custom FB Login", for: .normal)
        customBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        view.addSubview(customBtn)
        //attach behaviour to custom button
        customBtn.addTarget(self, action: #selector(handleCustomFBLogin), for: .touchUpInside)
    }
    
    @objc func handleCustomGoogleLogin() {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @objc func handleCustomFBLogin() {
        FBSDKLoginManager().logIn(withReadPermissions : ["email", "public_profile"], from: self) {
            (result, err) in
            if err != nil {
                print("FB LOGIN Failed")
                return
            }
            self.showEmailAddress()
            //print(result?.token.tokenString)
        }
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }
        showEmailAddress()
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out of Facebook")
    }
    
    func showEmailAddress() {
        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)

        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                print("Something went wrong", error)
                return
            }
            print("Successfully logged in with our user: " , user)
        }
    
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields" : "id, name, email"]).start{ (connection, result, err) in
            if err != nil {
                print("Failed to start graph request:", err)
                return
            }
            print(result)
        }
    }
   
}


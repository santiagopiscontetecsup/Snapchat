//
//  ViewController.swift
//  PisconteSnapchat
//
//  Created by Santiago Pisconte  on 16/10/24.
//

import UIKit
import FirebaseAuth

class iniciarSesionViewController: UIViewController {
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func iniciarSesionTapped(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in print("Intentando Iniciar Sesion")
            if error != nil {
                print("Se presento el siguiente error: \(error)")
            } else{
                print("Inicio de sesion exitoso")
            }
        }
    }
    @IBAction func iniciarSesionAnonimaTapped(_ sender: Any) {
        Auth.auth().signInAnonymously { (authResult, error) in
            if let error = error {
                print("Se presentó un error al iniciar sesión de manera anónima: \(error.localizedDescription)")
            } else {
                print("Inicio de sesión anónimo exitoso")
            }
        }
    }
    
}


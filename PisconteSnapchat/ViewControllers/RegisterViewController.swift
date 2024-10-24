//
//  RegisterViewController.swift
//  PisconteSnapchat
//
//  Created by Santiago Pisconte  on 24/10/24.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func createAccount(_ sender: Any) {
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            print("Intentando crear un usuario")
            if let error = error {
                print("Se presentó el siguiente error al crear el usuario: \(error)")
            } else {
                print("El usuario fue creado exitosamente")
                Database.database().reference().child("usuarios").child(user!.user.uid).child("email").setValue(user!.user.email)
                
                let alerta = UIAlertController(title: "Creación del Usuario", message: "Usuario: \(self.emailTextField.text!) se creó correctamente.", preferredStyle: .alert)
                let btnOK = UIAlertAction(title: "Aceptar", style: .default) { _ in
                    self.performSegue(withIdentifier: "iniciarsegue", sender: nil)
                }
                alerta.addAction(btnOK)
                self.present(alerta, animated: true, completion: nil)
            }
        }
    }
}

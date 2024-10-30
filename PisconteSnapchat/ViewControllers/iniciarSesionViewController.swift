//
//  ViewController.swift
//  PisconteSnapchat
//
//  Created by Santiago Pisconte  on 16/10/24.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class iniciarSesionViewController: UIViewController {
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func iniciarSesionTapped(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            print("Intentando Iniciar Sesion")
            if let error = error {
                print("Se presentó el siguiente error: \(error)")
                let alerta = UIAlertController(title: "Error", message: "El usuario no existe. ¿Desea crear una cuenta?", preferredStyle: .alert)
                let crearAction = UIAlertAction(title: "Crear", style: .default) { _ in
                    self.performSegue(withIdentifier: "registrarsegue", sender: nil)
                }
                let cancelarAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
                
                alerta.addAction(crearAction)
                alerta.addAction(cancelarAction)
                self.present(alerta, animated: true, completion: nil)
            } else {
                print("Inicio de Sesion Exitoso")
                self.performSegue(withIdentifier: "iniciarsesionsegue", sender: nil)
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


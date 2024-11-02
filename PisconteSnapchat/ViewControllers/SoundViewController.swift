//
//  SoundViewController.swift
//  PisconteSnapchat
//
//  Created by Santiago Pisconte  on 31/10/24.
//

import UIKit
import AVFoundation
import FirebaseStorage

class SoundViewController: UIViewController {

    @IBOutlet weak var elegirContactoButton: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var grabarButton: UIButton!
    var grabarAudio:AVAudioRecorder?
    var audioURL:URL?
    var grabacionID = NSUUID().uuidString
    
    @IBAction func grabarTapped(_ sender: Any) {
        if grabarAudio!.isRecording{
            grabarAudio?.stop()
            grabarButton.setTitle("Grabar", for: .normal)
            elegirContactoButton.isEnabled = true
        } else  {
            grabarAudio?.record()
            grabarButton.setTitle("Detener", for: .normal)
        }
    }
    
    func mostrarAlerta(titulo: String, mensaje: String, accion: String){
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        let btnCANCELOK = UIAlertAction(title: accion, style: .default, handler: nil)
        alerta.addAction(btnCANCELOK)
        present(alerta, animated: true, completion: nil    )
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "elegirContactoGrabacionSegue" {
            if let siguienteVC = segue.destination as? ElegirUsuarioViewController {
                if let grabacionURL = sender as? String {
                    siguienteVC.grabacionURL = grabacionURL
                } else {
                    print("El sender no es una URL de grabación válida.")
                }
                siguienteVC.titulo = titleTextField.text ?? ""
                siguienteVC.grabacionID = grabacionID
            }
        }
    }
    
    
    @IBAction func elegirContactoTapped(_ sender: Any) {
        elegirContactoButton.isEnabled = false

            guard let audioURL = audioURL else {
                mostrarAlerta(titulo: "Error", mensaje: "No se pudo encontrar la URL de la grabación.", accion: "Aceptar")
                elegirContactoButton.isEnabled = true
                return
            }

            let grabacionesFolder = Storage.storage().reference().child("grabaciones")
            
            if let audioData = try? Data(contentsOf: audioURL) {
                let cargarAudio = grabacionesFolder.child("\(grabacionID).m4a")
                
                cargarAudio.putData(audioData, metadata: nil) { (metadata, error) in
                    if let error = error {
                        self.mostrarAlerta(titulo: "Error", mensaje: "Se produjo un error al subir la grabación. Verifique su conexión a internet y vuelva a intentarlo.", accion: "Aceptar")
                        self.elegirContactoButton.isEnabled = true
                        print("Ocurrió un error al subir la grabación: \(error)")
                        return
                    }
                    cargarAudio.downloadURL { (url, error) in
                        guard let enlaceURL = url else {
                            self.mostrarAlerta(titulo: "Error", mensaje: "Se produjo un error al obtener información de la grabación.", accion: "Cancelar")
                            self.elegirContactoButton.isEnabled = true
                            print("Ocurrió un error al obtener la información de la grabación \(error?.localizedDescription ?? "desconocido")")
                            return
                        }
                        
                        // Aquí se llama al segue pasando la URL
                        self.performSegue(withIdentifier: "elegirContactoGrabacionSegue", sender: enlaceURL.absoluteString)
                    }
                }
            } else {
                mostrarAlerta(titulo: "Error", mensaje: "No se pudo obtener los datos de audio.", accion: "Aceptar")
                elegirContactoButton.isEnabled = true
            }
    }
    
    func configurarGrabacion() {
        do {
            let session = AVAudioSession.sharedInstance()
            
            try session.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
            try session.setActive(true)

            guard let basePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
                mostrarAlerta(titulo: "Error", mensaje: "No se pudo configurar la ruta de grabación", accion: "Aceptar")
                return
            }
            
            let pathComponents = [basePath, "audio.m4a"]
            guard let audioURL = NSURL.fileURL(withPathComponents: pathComponents) else {
                mostrarAlerta(titulo: "Error", mensaje: "No se pudo crear la URL de grabación", accion: "Aceptar")
                return
            }
            
            self.audioURL = audioURL
            
            let settings: [String: Any] = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100.0,
                AVNumberOfChannelsKey: 2
            ]
            
            grabarAudio = try AVAudioRecorder(url: audioURL, settings: settings)
            grabarAudio?.prepareToRecord()
            
        } catch {
            print("Error al configurar la grabación: \(error)")
            mostrarAlerta(titulo: "Error", mensaje: "Hubo un problema al configurar la grabación de audio.", accion: "Aceptar")
        }
    }

    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurarGrabacion()
        elegirContactoButton.isEnabled = false
        // Do any additional setup after loading the view.
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

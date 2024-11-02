

import UIKit
import Firebase
import AVFoundation

class EscucharAudioViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var grabaciones:[Grabacion] = []
    var audioPlayer: AVAudioPlayer?

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Número de grabaciones: \(grabaciones.count)")
        return grabaciones.isEmpty ? 1 : grabaciones.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AudioCell", for: indexPath) as? CustomAudioCellTableViewCell else {
                return UITableViewCell()
            }
            
            if grabaciones.isEmpty {
                cell.tableViewTitulo.text = "No tienes Grabaciones 😪"
                cell.tableViewFrom.text = ""
                cell.playButton.isHidden = true
            } else {
                let grabacion = grabaciones[indexPath.row]
                print("Título: \(grabacion.titulo), From: \(grabacion.from)")
                cell.tableViewTitulo.text = grabacion.titulo // Verifica que aquí esté correcto
                cell.tableViewFrom.text = grabacion.from
                cell.playButton.isHidden = false
                cell.playButton.tag = indexPath.row
                cell.playButton.addTarget(self, action: #selector(playTapped(_:)), for: .touchUpInside)
            }
            
            return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let grabacion = grabaciones[indexPath.row]
//        if let url = URL(string: grabacion.grabacionURL) {
//            reproducirAudioDesde(url: url)
//        }
//    }
    
    // Acción para reproducir audio al presionar el botón Play
    @objc func playTapped(_ sender: UIButton) {
        let grabacion = grabaciones[sender.tag]
        if let url = URL(string: grabacion.grabacionURL) {
            reproducirAudioDesde(url: url)
        }
    }

    // Función para reproducir audio desde una URL
    func reproducirAudioDesde(url: URL) {
        do {
            let audioData = try Data(contentsOf: url)
            print("Datos de audio cargados con éxito. Tamaño: \(audioData.count) bytes")
            
            audioPlayer = try AVAudioPlayer(data: audioData)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("Error al reproducir el audio: \(error.localizedDescription)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        obtenerGrabaciones()

    }
    
    func obtenerGrabaciones() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        print("User id ------------------------------ \(userID)")
        
        // Accedemos a la referencia de Firebase para las grabaciones del usuario actual
        Database.database().reference().child("usuarios").child(userID).child("grabaciones").observe(.childAdded, with: { (snapshot) in
            if let grabacionData = snapshot.value as? [String: AnyObject] {
                print("Datos de grabación: \(grabacionData)")
                // Suponiendo que `Grabacion` tiene propiedades como `titulo`, `from` y `url`
                let titulo = grabacionData["titulo"] as? String ?? "Sin título"
                let from = grabacionData["from"] as? String ?? "Desconocido"
                let url = grabacionData["grabacionURL"] as? String ?? ""
                
                // Crear la grabación y añadirla al arreglo
                let nuevaGrabacion = Grabacion(id: snapshot.key, titulo: titulo, from: from, url: url)
                self.grabaciones.append(nuevaGrabacion)
                print("todas las grabaciones dentro ---------  \(self.grabaciones)")
                // Recargamos la tabla para mostrar la nueva grabación
                self.tableView.reloadData()
            }
        })
    }
    

}

//
//  Grabacion.swift
//  PisconteSnapchat
//
//  Created by Santiago Pisconte  on 31/10/24.
//

import Foundation

class Grabacion{
    var grabacionURL = ""
    var titulo = ""
    var from = ""
    var id = ""
    var grabacionID = ""
    
    // Inicializador personalizado
    init(id: String, titulo: String, from: String, url: String) {
        self.id = id
        self.titulo = titulo
        self.from = from
        self.grabacionURL = url
        self.grabacionID = ""
    }
}

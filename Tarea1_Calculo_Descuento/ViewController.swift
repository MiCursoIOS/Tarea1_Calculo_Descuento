//
//  ViewController.swift
//  Tarea1_Calculo_Descuento
//
//  Created by Erikson Murrugarra on 12/26/17.
//  Copyright © 2017 DigitalPark. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var txtMontoRH: UITextField!
    @IBOutlet weak var txtNombres: UITextField!
    @IBOutlet weak var txtEdad: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var swEsAfiliado: UISwitch!
    @IBOutlet weak var txtResultado: UITextView!
    
    @IBOutlet weak var panelResultados: UIView!
    @IBOutlet weak var btnLimpiar: UIButton!
    
    @IBAction func calcularDescuentoRecibido(_ sender: Any) {
        
        // validando datos
        if let montoRH = Double(txtMontoRH.text!), montoRH > 0,
           let nombres = txtNombres.text, !nombres.isEmpty,
           let edad = Int(txtEdad.text!), edad >= 18,
           let email = txtEmail.text, !email.isEmpty, email.isValidEmail() {
            
            var montoRetencion: Double = 0.0
            var montoDescuentoAFP: Double = 0.0
            var montoDescuentoRenta: Double = 0.0
            var totalARecibir: Double = 0.0
            
            // calculando
            if edad < 40 {
                
                // retencion AFP solo aplica si es afiliado
                if swEsAfiliado.isOn {
                    if montoRH > 700 {
                        montoDescuentoAFP = montoRH * 0.07
                    }
                }
                
                // retencion Renta aplica a todos
                if montoRH > 1500 {
                    montoDescuentoRenta = montoRH * 0.1
                }
            }
            
            montoRetencion = montoDescuentoAFP + montoDescuentoRenta
            totalARecibir = montoRH - montoRetencion
            
            // mostrar resultado
            let resultado = " Nombre: \(nombres)\n Edad: \(edad)\n Sueldo RRHH: \(montoRH)\n\n Descuento AFP: \(montoDescuentoAFP)\n Descuento Renta: \(montoDescuentoRenta)\n Total a Recibir: \(totalARecibir)"
            
            txtResultado.text = resultado
            mostrarControlesDeResultados(mostrar: true)
            
        } else {
            mostrarAlertaError()
        }
        
    }
    
    func mostrarAlertaError() -> Void {
        // creando objeto alerta
        let alert = UIAlertController(title: "Datos Invalidos", message: "Verifique los datos ingresados. Se encontraron errores en alguno de los campos.", preferredStyle: .alert)
        let botonOk = UIAlertAction(title: "Entendido", style: .default, handler: nil)
        
        alert.addAction(botonOk)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func limpiarTextFields(_ sender: Any) {
        txtMontoRH.text = ""
        txtNombres.text = ""
        txtEdad.text = ""
        txtEmail.text = ""
        swEsAfiliado.setOn(true, animated: true)
        txtResultado.text = ""
        // devolver el foco
        txtMontoRH.becomeFirstResponder()
        // ocultar controles
        mostrarControlesDeResultados(mostrar: false)
        
    }
    
    func mostrarControlesDeResultados(mostrar: Bool) -> Void {
        panelResultados.isHidden = !mostrar
        btnLimpiar.isHidden = !mostrar
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ocultar controles al iniciar
        mostrarControlesDeResultados(mostrar: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension String {
    func isValidEmail() -> Bool {
        // aplicando expresion regular
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex)
            .evaluate(with: self)
    }
}

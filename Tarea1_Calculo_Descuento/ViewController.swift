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
    
    @IBOutlet weak var tpFechaNacimiento: UIDatePicker!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var swEsAfiliado: UISwitch!
    @IBOutlet weak var txtResultado: UITextView!
    
    @IBOutlet weak var panelResultados: UIView!
    @IBOutlet weak var btnLimpiar: UIButton!
    
    var calculoEnProceso: Bool = false
    
    @IBAction func calcularDescuentoRecibido(_ sender: Any) {
        
        // validando datos
        if let montoRH = Double(txtMontoRH.text!), montoRH > 0,
           let nombres = txtNombres.text, !nombres.isEmpty,
           let email = txtEmail.text, !email.isEmpty, email.isValidEmail() {
            
            var montoRetencion: Double = 0.0
            var montoDescuentoAFP: Double = 0.0
            var montoDescuentoRenta: Double = 0.0
            var totalARecibir: Double = 0.0
            let edad = calcularEdad()
            
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
            ocultarTeclado()
            mostrarControlesDeResultados(mostrar: true)
            
            calculoEnProceso = true
            
        } else {
            mostrarAlertaError()
        }
        
    }
    
    func calcularEdad() -> Int {
        let fechaHoy = Date()
        let fechaNacimiento = tpFechaNacimiento.date
        let calendar = Calendar.current
        
        let anioActual = calendar.component(.year, from: fechaHoy)
        let anioNacimiento = calendar.component(.year, from: fechaNacimiento)
        
        return anioActual - anioNacimiento
    }
    
    @IBAction func eventoCambioSwitchAfiliacion(_ sender: Any) {
        if calculoEnProceso {
            calcularDescuentoRecibido(swEsAfiliado)
        }
    }
    
    func ocultarTeclado() -> Void {
        self.view.endEditing(true)
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
        txtEmail.text = "@domain.com"
        swEsAfiliado.setOn(true, animated: true)
        txtResultado.text = ""
        // devolver el foco
        txtMontoRH.becomeFirstResponder()
        // ocultar controles
        mostrarControlesDeResultados(mostrar: false)
        calculoEnProceso = false
        
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

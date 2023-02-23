//
//  ContentView.swift
//  SchrodingerDifferential
//
//  Created by IIT PHYS 440 on 2/23/23.
//

import Foundation

struct Contentview {
    var real: Double
    var imaginary: Double
    
    init(real: Double, imaginary: Double) {
        self.real = real
        self.imaginary = imaginary
    }
    
    static func +(lhs: Complex, rhs: Complex) -> Complex {
        return Complex(real: lhs.real + rhs.real, imaginary: lhs.imaginary + rhs.imaginary)
    }
    
    static func *(lhs: Complex, rhs: Complex) -> Complex {
        return Complex(real: lhs.real * rhs.real - lhs.imaginary * rhs.imaginary,
                       imaginary: lhs.real * rhs.imaginary + lhs.imaginary * rhs.real)
    }
}

func schrodingerEquation(potential: [Double], x: [Double], dx: Double, psi0: [Complex], t: Double) -> [Complex] {
    let hbar = 1.0
    let m = 1.0
    
    let k1 = Complex(real: 0, imaginary: -hbar / (2 * m * dx * dx))
    let k2 = Complex(real: 0, imaginary: hbar / (m * dx * dx))
    
    let dt = t / Double(psi0.count - 1)
    
    var psi = psi0
    
    for i in 0..<psi0.count-1 {
        let t1 = Complex(real: 0, imaginary: -dt / (2 * hbar))
        let t2 = Complex(real: 0, imaginary: dt / (2 * hbar))
        
        let k1psi = k1 * (psi[i+1] - 2 * psi[i] + (i > 0 ? psi[i-1] : psi[i]))
        let k2psi = k2 * (potential[i] * psi[i])
        
        let k1psi_t = t1 * k1psi
        let k2psi_t = t1 * k2psi
        
        let k3psi = k1 * (psi[i+1] - 2 * (psi[i] + k1psi_t / 2) + (i > 0 ? psi[i-1] : psi[i])) + k2psi
        let k4psi = k1 * (psi[i+1] - 2 * (psi[i] + k1psi_t) + (i > 0 ? psi[i-1] : psi[i])) + 2 * k2psi
        
        psi[i+1] = psi[i] + t2 * (k1psi + 2 * k3psi + k4psi)
    }
    
    return psi
}

// Example usage:
let potential = [0, 0, 0, 1, 0, 0, 0]
let x = [-3, -2, -1, 0, 1, 2, 3]
let dx = 1.0
let psi0 = [Complex(real: 0, imaginary: 0), Complex(real: 0, imaginary: 0), Complex(real: 0, imaginary: 0),
            Complex(real: 1, imaginary: 0), Complex(real: 0, imaginary: 0), Complex(real: 0, imaginary: 0),
            Complex(real: 0, imaginary: 0)]
let t = 10.0

let psi = schrodingerEquation(potential: Double(potential), x: Double(x), dx: dx, psi0: psi0, t: t)
//print(psi)

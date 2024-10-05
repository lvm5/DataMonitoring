//
//  ContentView.swift
//  DataMonitoring
//
//  Created by Leandro Morais on 05-10-2024.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

//MARK: -- DATA COLECTED
struct MachineData: Identifiable {
    var id: String
    var name: String
    var status: String // "Rodando" ou "Parada"
    var packetsPerMinute: Int
    var temperature: Double
}

//MARK: -- AUTH VIEW
struct ContentView: View {
    @State private var user: User? = nil
    @State private var machines: [MachineData] = []
    
    var body: some View {
        if let user = user {
            // Se o usuário estiver autenticado, exibe os dados das máquinas
            MachineListView(machines: machines, user: user)
        } else {
            // Senão, exibe a tela de login
            LoginView(user: $user)
        }
    }
}

//MARK: -- LOGIN SCREEN
struct LoginView: View {
    @Binding var user: User?
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String = ""
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.teal.opacity(0.7), Color.indigo.opacity(0.7)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack {
                
                TextField("Email", text: $email)
                //.textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .background(Color.white.opacity(0.5))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .autocapitalization(.none)
                SecureField("Senha", text: $password)
                //.textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .background(Color.white.opacity(0.5))
                    .cornerRadius(10)
                    .padding(.horizontal)
                
                Button("Entrar") {
                    loginUser()
                }
                .foregroundColor(.white)
                .font(.title2)
                .bold()
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .cornerRadius(10)
                .padding(.horizontal)
                .padding(.top, 30)
                
                //MARK: -- CREATE ACCOUNT (New version)
                //                HStack(spacing: 3) {
                //                    Text("Não tem uma conta?")
                //                    Text("Criar conta")
                //                        .fontWeight(.bold)
                //                }
                //                .padding(5.0)
                //                .font(.system(size: 14))
                //                .foregroundColor(.white.opacity(0.8))
                
                
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
            }
            .padding()
        }
    }
    
    //MARK: -- LOGIN VEW
    func loginUser() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                errorMessage = error.localizedDescription
            } else {
                user = result?.user
            }
        }
    }
}

//MARK: -- MACHINE VIEW
struct MachineListView: View {
    var machines: [MachineData]
    var user: User
    
    var body: some View {
        NavigationView {
            List(machines) { machine in
                NavigationLink(destination: MachineDetailView(machine: machine)) {
                    VStack(alignment: .leading) {
                        Text(machine.name)
                        Text("Status: \(machine.status)")
                            .font(.subheadline)
                            .foregroundColor(machine.status == "Rodando" ? .green : .red)
                    }
                }
            }
            .navigationTitle("Máquinas")
        }
    }
}

//MARK: -- MACHINE DETAIL VIEW
struct MachineDetailView: View {
    var machine: MachineData
    
    var body: some View {
        VStack {
            Text("Nome: \(machine.name)")
            Text("Status: \(machine.status)")
            Text("Pacotes por Minuto: \(machine.packetsPerMinute)")
            Text("Temperatura: \(machine.temperature)°C")
        }
        .padding()
    }
}


//MARK: -- PREVIEW
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        
    }
}

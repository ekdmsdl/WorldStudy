//
//  AuthViewModel.swift
//  Login
//
//  Created by 이다은 on 5/27/25.
//

import Foundation
import Combine

class AuthViewModel: ObservableObject {
    @Published var token: String?
    @Published var name: String? = nil
    @Published var isLoggedIn = false
    @Published var loginError: String?
    @Published var signupError: String?
    @Published var role: String?

    private let tokenKey = "jwt_token"

    init() {
        // 앱 실행 시 토큰 불러오기
        if let savedToken = UserDefaults.standard.string(forKey: tokenKey) {
            self.token = savedToken
            self.isLoggedIn = true
            self.role = UserDefaults.standard.string(forKey: "role")
        }
    }

    // 로그인 요청 보내고 토큰 저장 (UserDefaults)
    func login(email: String, password: String) async {
        Task{
            do {
                print("viewModel login : \(email) \(password)")
                if let result = try await APIService.shared.login(email: email, password: password) {
                    await MainActor.run {
                        print(result.token)
                        self.token = result.token
                        self.role = result.role
                        self.name = result.name
                        self.isLoggedIn = true
                        UserDefaults.standard.set(result.token, forKey: self.tokenKey)
                        UserDefaults.standard.set(result.role, forKey: "role")
                        UserDefaults.standard.set(result.name, forKey: "name")
                    }
                }else{
                    await MainActor.run {
                        self.loginError = "로그인 실패"
                    }
                }
            }catch{
                await MainActor.run {
                    self.loginError = "로그인 실패"
                }
            }
        }
    }
    
    //회원가입 요청 후 성공 여부만 확인
    func signup(email: String, password: String, name: String, role: String) async {
        Task {
            do {
                let success = try await APIService.shared.signup(email: email, password: password, name: name, role: role)
                print("viewModel signup : \(success)")
                if success {
                    await MainActor.run {
                        self.role = role
                        UserDefaults.standard.set(role, forKey: "role")
                    }
                }else {
                    await MainActor.run {
                        self.signupError = "회원가입실패"
                    }
                }
                
            }catch{
                await MainActor.run {
                    self.signupError = "회원가입실패"
                }
            }
        }
    }

    //토큰 삭제 및 상태 초기화
    func logout() {
        self.token = nil
        self.isLoggedIn = false
        UserDefaults.standard.removeObject(forKey: tokenKey)
    }
}

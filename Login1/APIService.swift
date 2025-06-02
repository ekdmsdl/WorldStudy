//
//  APIService.swift
//  Login
//
//  Created by 이다은 on 5/27/25.
//

import Foundation
import Alamofire

class APIService {
    static let shared = APIService()
    let baseURL = "http://localhost:3000" // 실제 서버 주소로 변경
    enum APIError: Error {
          case missingToken
      }
    // 토큰 가져오기
    func getToken() -> String? {
        return UserDefaults.standard.string(forKey: "jwt_token")
    }
    // 토큰이 필요한 API 호출을 위한 헤더 생성
    private func getAuthHeaders() throws -> HTTPHeaders {
        guard let token = getToken() else {
            throw APIError.missingToken
        }
        return ["Authorization": "Bearer \(token)"]
    }
    
    // 회원가입
    func signup(email: String, password: String, name: String, role: String) async throws -> Bool {
        let params = ["email": email, "name": name, "password": password, "role": role]
        
        let response = try await AF.request("\(baseURL)/auth/signup", method: .post, parameters: params, encoding: JSONEncoding.default)
            .validate()
            .serializingData()
            .response
        
        if let error = response.error {
            print("Signup error: \(error.localizedDescription)")
            return false
        }
        return true
    }

    // 로그인
    func login(email: String, password: String) async throws -> (token: String, role: String, name: String)? {
        let params = ["email": email, "password": password]
        
        let response = try await AF.request("\(baseURL)/auth/login", method: .post, parameters: params, encoding: JSONEncoding.default)
            .validate()
            .serializingDecodable(LoginResponse.self)
            .value
        
        return (response.access_token, response.role, response.name)
    }
    
    // 랭킹
    func fetchMentorRankings() async throws -> [MentorRanking] {
        let response = try await AF.request("\(baseURL)/ranking/mentors", method: .get) // api 파라미터 수정
            .validate()
            .serializingDecodable([MentorRanking].self)
            .value
        return response
    }
    
    // 질문
    func fetchUserQuestions() async throws -> [Question] {
        let response = try await AF.request("\(baseURL)/questions/my", method: .get, headers: try getAuthHeaders()) // api 파라미터 수정
            .validate()
            .serializingDecodable([Question].self)
            .value
        return response
    }
}

struct LoginResponse: Codable {
    let access_token: String
    let role: String
    let name: String
}

struct MentorRanking: Identifiable, Codable {
    var id: Int { UUID().hashValue } // 고유 ID
    let name: String
    let count: Int
}

struct Question: Identifiable, Codable {
    let id: Int
    let title: String // 제목으로 할지, 내용으로 할지 상의
}

//
//  AuthViewTest.swift
//  Login1
//
//  Created by 이다은 on 5/28/25.
//

import SwiftUI

struct AuthViewTest: View {
    let backgroundColor2 = Color("BackgroundColor2")
    @ObservedObject var viewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var name = ""
    @State private var role = ""
    @State private var isSignup = false
    @State private var selectedRole: String? = nil

    var body: some View {
        ZStack {
            backgroundColor2.ignoresSafeArea()

            VStack(spacing: 200) {
                Spacer().frame(height: 60)

                if isSignup {
                    signupSection
                } else {
                    loginSection
                }

                if let error = isSignup ? viewModel.signupError : viewModel.loginError {
                    Text(error).foregroundColor(.red)
                }

                Spacer()
            }
            .padding(.horizontal, 30)
        }
    }

    var loginSection: some View {
        VStack(spacing: 16) {
            Text("로그인 하기")
                .font(.title2)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)

            TextField("이메일 주소", text: $email)
                .customAuthField()

            SecureField("비밀번호", text: $password)
                .customAuthField()

            Button("로그인") {
                Task {
                    await viewModel.login(email: email, password: password)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(red: 0.4627, green: 0.6902, blue: 0.9686))
            .foregroundColor(.white)
            .cornerRadius(10)

            Button("회원가입하기") {
                isSignup = true
            }
            .foregroundColor(.gray)
            .font(.footnote)
        }
    }

    var signupSection: some View {
        VStack(spacing: 16) {
            Text("회원가입 하기")
                .font(.title2)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            Group {
                TextField("이메일을 입력해주세요.", text: $email)
                    .customAuthField()
                SecureField("비밀번호를 입력해주세요.", text: $password)
                    .customAuthField()
                TextField("이름을 입력해주세요.", text: $name)
                    .customAuthField()
            }

            Text("누구의 계정인가요?")
                .font(.system(size: 20))
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.black)

            HStack(spacing: 20) {
                roleCard(role: "멘토", image: "mentorUser", isSelected: selectedRole == "멘토")
                    .onTapGesture { selectedRole = "멘토" }

                roleCard(role: "멘티", image: "menteeUser", isSelected: selectedRole == "멘티")
                    .onTapGesture { selectedRole = "멘티" }
            }

            Button("회원가입") {
                Task {
                    print("회원가입: \(email), \(password), \(name), 역할: \(selectedRole ?? "")")
                    let success: () = await viewModel.signup(email: email, password: password, name: name, role: role)
                    isSignup = false
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(red: 0.4627, green: 0.6902, blue: 0.9686))
            .foregroundColor(.white)
            .cornerRadius(10)

            Button("로그인하기") {
                isSignup = false
            }
            .foregroundColor(.gray)
            .font(.footnote)
        }
    }

    func roleCard(role: String, image: String, isSelected: Bool) -> some View {
        VStack {
            Image(image)
                .resizable()
                .frame(width: 50, height: 50)
            Text(role)
                .font(.footnote)
                .foregroundColor(isSelected ? Color.blue : Color.black)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? Color.blue : Color.gray.opacity(0.3), lineWidth: 2)
                .background(Color.white.cornerRadius(12))
        )
    }
}

#Preview {
    AuthViewTest(viewModel: AuthViewModel())
}

//
//  ContentView.swift
//  Login1
//
//  Created by 이다은 on 5/28/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var authViewModel = AuthViewModel()

    var body: some View {
        Group {
            if authViewModel.isLoggedIn {
                if authViewModel.role == "멘토" {
                    TabView{
                        MentorView(authViewModel: authViewModel)
                            .tabItem {
                                Image(systemName: "globe.asia.australia.fill")
                                Text("홈")
                            }
                        Text("커뮤니티")
                            .tabItem {
                                Image(systemName: "bubble.left.and.bubble.right.fill")
                                Text("커뮤니티")
                            }
                        Text("마이페이지")
                            .tabItem {
                                Image(systemName: "person.crop.circle")
                                Text("마이페이지")
                            }
                    }
                } else {
                    TabView{
                        MenteeView(authViewModel: authViewModel)
                            .tabItem {
                                Image(systemName: "globe.asia.australia.fill")
                                Text("홈")
                            }
                        Text("커뮤니티")
                            .tabItem {
                                Image(systemName: "bubble.left.and.bubble.right.fill")
                                Text("커뮤니티")
                            }
                        Text("마이페이지")
                            .tabItem {
                                Image(systemName: "person.crop.circle")
                                Text("마이페이지")
                            }
                    }
                }
            } else {
                AuthView(viewModel: authViewModel) // 로그인/회원가입 화면
            }
        }
    }
}

#Preview {
    AuthView(viewModel: AuthViewModel())
}

//
//  ProfileView.swift
//  ProfileFeature
//
//  Created by Kyeongmo Yang on 6/24/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import SettingsFeature
import SwiftUI

public struct ProfileView: View {
    @Bindable private var store: StoreOf<ProfileFeature>
    
    public init(store: StoreOf<ProfileFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack {
            HStack {
                Text(store.profile.nickname)
                    .font(.system(size: 16))
                    .bold()
                
                Button {
                    store.send(.showNicknameChangeAlert)
                } label: {
                    Image(systemName: "pencil.line")
                        .foregroundStyle(.black)
                }
            }
            .padding(.vertical, 25)
            
            HStack {
                VStack {
                    Text("\(store.profile.totalFootstepCount)")
                        .font(.system(size: 22))
                        .bold()
                        .italic()
                    
                    Text("발자취 개수")
                }
                
                Spacer()
                    .frame(width: 50)
                
                VStack {
                    Text("\(store.profile.footstepStreakDays)")
                        .font(.system(size: 22))
                        .bold()
                        .italic()
                    
                    Text("연속 발자취")
                }
            }
            
            Spacer()
        }
        .navigationTitle("프로필")
        .onAppear {
            store.send(.onAppear)
        }
        .alert("닉네임 변경", isPresented: $store.isShowingNicknameAlert) {
            TextField("새 닉네임 (최대 8자)", text: $store.nicknameInput)
                .onChange(of: store.nicknameInput) { _, newValue in
                    if newValue.count > 8 {
                        store.nicknameInput = String(newValue.prefix(8))
                    }
                }

            Button("취소", role: .cancel) {
                store.send(.cancelNicknameChange)
            }

            Button("확인") {
                store.send(.confirmNicknameChange)
            }
            .disabled(store.nicknameInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        } message: {
            Text("새로운 닉네임을 입력하세요 (최대 8자)")
        }
    }
}

//#Preview {
//    ProfileView(store: .init(initialState: ProfileFeature.State()) {
//        ProfileFeature()
//    })
//}

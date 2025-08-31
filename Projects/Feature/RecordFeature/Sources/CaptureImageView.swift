//
//  CaptureImageView.swift
//  RecordFeature
//
//  Created by Kyeongmo Yang on 8/3/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import CameraInterface
import ComposableArchitecture
import DesignSystem
import SwiftUI

public struct CaptureImageView: View {
    typealias CameraFeatureViewStore = ViewStore<CaptureImageFeature.State, CaptureImageFeature.Action>
    
    private let store: StoreOf<CaptureImageFeature>
    private let flipAnimationDuration: Double = 0.5
    
    public init(store: StoreOf<CaptureImageFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Button(
                    action: {
                        store.send(.dismissButtonTapped)
                    },
                    label: {
                        Image(systemName: "xmark")
                            .font(.title)
                            .tint(.white)
                    }
                )
                
            }
            .padding(.top, 30)
            .padding(.trailing, 30)
            .padding(.bottom, 50)
            
            viewFinder
            
            buttonsView
        }
        .background(Color.black)
        .onAppear {
            store.send(.viewWillAppear)
        }
        .fullScreenCover(
            store: self.store.scope(
                state: \.$cameraResult,
                action: \.cameraResult
            )
        ) { postFootstepFeature in
            NavigationStack {
                PostFootstepView(store: postFootstepFeature)
            }
        }
        .transaction { transaction in
            transaction.disablesAnimations = store.disableDismissAnimation
        }
    }
    
    private var viewFinder: some View {
        GeometryReader { geometry in
            ZStack {
                if let image = store.state.viewFinderImage {
                    image
                        .resizable()
                        .scaledToFit()
                }
                
                if let flipImage = store.state.flipImage {
                    flipImage
                        .resizable()
                        .scaledToFit()
                        .blur(radius: 8, opaque: true)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.width * CameraSetting.ratio)
            .background(Color.clear)
            .rotation3DEffect(.degrees(store.state.flipDegree), axis: (x: 0, y: 1, z: 0))
        }
    }
    
    private var buttonsView: some View {
        HStack {
            Spacer()
            
            Button {
                store.send(.shutterTapped)
            } label: {
                ZStack {
                    Circle()
                        .strokeBorder(.white, lineWidth: 3)
                        .frame(width: 62, height: 62)
                    Circle()
                        .fill(.white)
                        .frame(width: 50, height: 50)
                }
            }
            
            Spacer()
        }
        .padding()
    }
}

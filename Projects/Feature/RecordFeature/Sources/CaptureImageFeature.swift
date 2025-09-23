//
//  CameraFeature.swift
//  RecordFeature
//
//  Created by Kyeongmo Yang on 8/3/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import CameraService
import CameraServiceInterface
import Combine
import ComposableArchitecture
import SwiftUI

@Reducer
public struct CaptureImageFeature {
    @ObservableState
    public struct State: Equatable {
        @Presents var cameraResult: PostFootstepFeature.State?
        var viewFinderImage: Image?
        
        var isFlipped: Bool = false
        var flipDegree: Double = 0.0 {
            didSet(oldValue) {
                print(oldValue)
            }
        }
        var flipImage: Image?
        
        public init() {}
    }
    
    public enum Action: Equatable {
        case viewWillAppear
        
        case viewFinderUpdate(Image?)
        case flipImageRemove
        case moveToCameraResult(Image)
        
        case shutterTapped
        case dismissButtonTapped
        
        case flipDegreeUpdate
        
        case cameraResult(PresentationAction<PostFootstepFeature.Action>)
        case delegate(Delegate)
        
        public enum Delegate: Equatable {
            case savePhoto(Image)
        }
    }
    
    @Dependency(\.dismiss) var dismiss
    @Dependency(\.cameraClient) var cameraClient
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            // MARK: View Life Cycle
            case .viewWillAppear:
                return .run { send in
                    await cameraClient.start()
                    
                    let imageStream = cameraClient.previewStream()
                        .map { $0.image }
                    
                    for await image in imageStream {
                        print(image)
                        await send(.viewFinderUpdate(image))
                    }
                }
                
            // MARK: - Image
            case let .viewFinderUpdate(image):
                state.viewFinderImage = image
                return .none
                
            case .flipImageRemove:
                state.flipImage = nil
                return .none
                
            case let .moveToCameraResult(image):
                state.cameraResult = PostFootstepFeature.State(resultImage: image)
                return .none
                
                // MARK: - Button Tapped
                
            case .shutterTapped:
                return .run { send in
                    let resultImage = await cameraClient.takePhoto()
                    await send(.moveToCameraResult(resultImage))
                }
                
            case .dismissButtonTapped:
                cameraClient.stop()
                return .run { _ in await self.dismiss() }
                
            case .flipDegreeUpdate:
                state.flipDegree += 180
                return .none
                
                // MARK: - Delegate
            case .delegate:
                return .none
                
            case let .cameraResult(.presented(.delegate(.savePhotos(image)))):
                return .send(.delegate(.savePhoto(image)))
                
            case .cameraResult(.presented(.delegate(.dismiss))):
                return .run { _ in await self.dismiss() }
                
            case .cameraResult:
                return .none
            }
        }
        .ifLet(\.$cameraResult, action: \.cameraResult) {
            PostFootstepFeature()
        }
        
    }
}

private extension CIImage {
    var image: Image? {
        let ciContext = CIContext()
        guard let cgImage = ciContext.createCGImage(self, from: self.extent) else { return nil }
        return Image(decorative: cgImage, scale: 1, orientation: .up)
    }
}

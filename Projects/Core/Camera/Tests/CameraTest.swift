import CameraInterface
@testable import Camera
import XCTest

final class CameraTests: XCTestCase {
    func testCameraSettingRatioIsOneByOne() {
        XCTAssertEqual(CameraSetting.ratio, 1.0, accuracy: 0.0001)
    }

    func testCameraSettingBackZoomFactorUsesExpectedValue() {
        XCTAssertEqual(CameraSetting.zoomFactorBackDevice, 2.0, accuracy: 0.0001)
        XCTAssertGreaterThan(CameraSetting.zoomFactorBackDevice, 0)
    }

    func testCameraSettingDropFrameUsesExpectedValue() {
        XCTAssertEqual(CameraSetting.dropFrame, 6)
        XCTAssertGreaterThan(CameraSetting.dropFrame, 0)
    }
}

import Foundation
import MetalKit

extension CGPoint {
	func rotate(byRadians: CGFloat) -> CGPoint {
		//x′=xcosθ−ysinθ
		//y′=ycosθ+xsinθ
		return CGPoint(
			x: self.x * cos(byRadians) - self.y * sin(byRadians),
			y: self.y * cos(byRadians) + self.x * sin(byRadians))
	}

	func toFloat2() -> float2 {
		return float2(Float(self.x), Float(self.y))
	}
}

extension CGSize {
	func toFloat2() -> float2 {
		return float2(Float(self.width), Float(self.height))
	}
}

//
//  CustomShapeView.swift
//  AnotherTestOfShit
//
//  Created by Nigel Krajewski on 9/6/24.
//

import SwiftUI

struct CustomShapeView: View {
    // Place custom shape inside Geometry reader for framing
    var body: some View {
        // Initialize shape
        let inverseRounds = InverseCornersRect()
            .fill(.clear)
            .stroke(.blue, style: StrokeStyle(lineWidth: 10, lineCap: .butt, lineJoin: .round))

        GeometryReader() { proxy in
            // Check device screen ratio
            if proxy.size.width < proxy.size.height {
                inverseRounds
                    .padding()
                    .frame(width: proxy.size.width, height: proxy.size.width)
            } else {
                inverseRounds
                    .padding()
                    .frame(width: proxy.size.height, height: proxy.size.height)
            }
        }
    }
}

#Preview {
    CustomShapeView()
}



// Custom View- rectangle with inverse rounded corners
struct InverseCornersRect: Shape {

    // Corner parameters
    var topRidgeWidth: CGFloat
    var topRadius: CGFloat
    var bottomRidgeWidth: CGFloat
    var bottomRadius: CGFloat

    init(topRidgeWidth: CGFloat = 0, topRadius: CGFloat = 0, bottomRidgeWidth: CGFloat = 0, bottomRadius: CGFloat = 1) {
        // Keep all parameters from extending beyond 1/2 rect width
        self.topRidgeWidth = topRidgeWidth<=4 ? topRidgeWidth : 4
        self.topRadius = topRadius<=5 ? topRadius : 5
        self.bottomRidgeWidth = bottomRidgeWidth<=4 ? bottomRidgeWidth : 4
        self.bottomRadius = bottomRadius<=5 ? bottomRadius : 5
    }

    // Create the Shape using path
    func path(in rect: CGRect) -> Path {

        // Divide max width to calculate values
        let tenthOfWidth = rect.maxX/10

        // Top values
        let tlRidge = (1+topRidgeWidth)*tenthOfWidth
        let ttRidge = (9-topRidgeWidth)*tenthOfWidth
        let tlRadius = topRadius*tenthOfWidth
        let ttRadius = topRadius*tenthOfWidth

        // Bottom values
        let btRidge = (9-bottomRidgeWidth)*tenthOfWidth
        let blRidge = (1+bottomRidgeWidth)*tenthOfWidth
        let btRadius = bottomRadius*tenthOfWidth
        let blRadius = bottomRadius*tenthOfWidth

        // Create path
        var path = Path()
        // Set path start point at bottom leading
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        // Draw path from start point to top leading
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        // Top Lead corner
        path.addArc(center: CGPoint(x: tlRidge, y: rect.minY),
                    radius: tlRadius,
                    startAngle: Angle(degrees: 180),
                    endAngle: Angle(degrees: 90), clockwise: true)
        // Top connecting line
        path.addLine(to: CGPoint(x: ttRidge, y: rect.minY+tlRadius))
        // Top trailing corner
        path.addArc(center: CGPoint(x: ttRidge, y: rect.minY),
                    radius: ttRadius,
                    startAngle: Angle(degrees:90),
                    endAngle: Angle(degrees: 0), clockwise: true)
        // Top trailing ridge
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        // Path from top trailing to bottom trailing
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        // Draw inverse arc from bottom trailing
        path.addArc(center: CGPoint(x: btRidge, y: rect.maxY),
                    radius: btRadius,
                    startAngle: Angle(degrees: 0),
                    endAngle: Angle(degrees: 270), clockwise: true)
        // Draw line to connect inside arcs
        path.addLine(to: CGPoint(x: blRidge, y: rect.maxY-blRadius))
        // Draw arc from bottom trailing corner top to corner bottom
        path.addArc(center: CGPoint(x: blRidge, y: rect.maxY),
                    radius: blRadius,
                    startAngle: Angle(degrees:270),
                    endAngle: Angle(degrees: 180), clockwise: true)
        // Connect the path to itself to keep smooth corner
        path.closeSubpath()
        // Return custom shape view
        return path
    }
}

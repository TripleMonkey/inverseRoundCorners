//
//  CustomShapeView.swift
//  AnotherTestOfShit
//
//  Created by Nigel Krajewski on 9/6/24.
//

import SwiftUI

// Rectangle with inverse rounded corners
struct InverseBottomCornersRectangle: Shape {
    // Create the Shape using path
    func path(in rect: CGRect) -> Path {
        /* To avoid hard coded values,
         Shape rect width divided by 10 for
         easily computing corner values
         in 1/10 increments of total width
         */
        let tenthOfWidth = rect.maxX/10

        var path = Path()
        // Set path start point at bottom leading
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        // Draw path from start point to top leading
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        // Draw path from top leading to top trailing
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        // Draw path from top trailing to bottom trailing
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        // Draw inverse arc from bottom trailing
        path.addArc(center: CGPoint(x: 9*tenthOfWidth, y: rect.maxY),
                    radius: tenthOfWidth,
                    startAngle: Angle(degrees: 0),
                    endAngle: Angle(degrees: 270), clockwise: true)
        // draw line to connect inside arcs
        path.addLine(to: CGPoint(x: tenthOfWidth, y: rect.maxY-tenthOfWidth))
        // Draw arc from bottom trailing corner top to corner bottom
        path.addArc(center: CGPoint(x: (tenthOfWidth), y: rect.maxY),
                    radius: tenthOfWidth,
                    startAngle: Angle(degrees:270),
                    endAngle: Angle(degrees: 180), clockwise: true)
        // Connect the path to itself to keep smooth corner
        path.closeSubpath()
        // Return custom shape view
        return path
    }
}

struct CustomShapeView: View {
    // Place custom shape inside Geometry reader for framing
    var body: some View {
        // Create shape as let for reuse
        let inverseRounds = InverseBottomCornersRectangle()
            .fill(.clear)
            .stroke(.blue, style: StrokeStyle(lineWidth: 10,
                                              lineCap: .butt,
                                              lineJoin: .round))

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


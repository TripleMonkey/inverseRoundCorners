//
//  ContentView.swift
//  AnotherTestOfShit
//
//  Created by Nigel Krajewski on 9/6/24.
//

import SwiftUI

    // Rectangle with inverse rounded corners
    struct InverseBottomCornersRectangle: Shape {

        /*  Avoid hard coded px value in favor
            percentage values. Below the Shape
            rect width is divided by 10 so
            corner values can be applied easily
            in 1/10 increments of total width
         */

        func path(in rect: CGRect) -> Path {
            var path = Path()
            // Set path start point at bottom leading
            path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
            // Draw path from start point to top leading
            path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
            // Draw path from top leading to top trailing
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            // Draw path from top trailing to bottom trailing
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            // Draw arch from bottom trailing corner bottom to corner top
            path.addArc(center: CGPoint(x: (rect.maxX/10)*9, y: rect.maxY), 
                        radius: rect.width/10, 
                        startAngle: Angle(degrees: 0),
                        endAngle: Angle(degrees: 270), clockwise: true)
            // Connect inside corners
            path.addLine(to: CGPoint(x: rect.maxX/10, y: rect.maxY-rect.maxX/10))
            // Draw arch from bottom trailing corner top to corner bottom
            path.addArc(center: CGPoint(x: (rect.maxX/10), y: rect.maxY), 
                        radius: rect.width/10,
                        startAngle: Angle(degrees:270),
                        endAngle: Angle(degrees: 180), clockwise: true)
            // Connect the pathe to itself to keep smooth corner
            path.closeSubpath()

            return path
        }
    }

    struct AnotherView: View {
        // Place custom shape inside Geometry reader for framing
        var body: some View {
            GeometryReader() { proxy in
                // Check device screen ratio
                if proxy.size.width < proxy.size.height {
                    InverseBottomCornersRectangle()
                        .fill(.clear)
                        .stroke(.blue, 
                                style: StrokeStyle(lineWidth: 10,
                                                   lineCap: .butt,
                                                   lineJoin: .round)
                        )
                        .padding()
                        .frame(width: proxy.size.width, height: proxy.size.width)
                } else {
                    InverseBottomCornersRectangle()
                        .fill(.clear)
                        .stroke(.blue, style: StrokeStyle(lineWidth: 10, 
                                                          lineCap: .butt,
                                                          lineJoin: .round))
                        .padding()
                        .frame(width: proxy.size.height, height: proxy.size.height)
                }
            }
        }
    }

    // Add Geometry reader framed shape in your desired view
    struct ContentView: View {

        var body: some View {
            AnotherView()
        }
    }


#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}


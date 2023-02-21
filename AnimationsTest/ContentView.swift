//
//  ContentView.swift
//  AnimationsTest
//
//  Created by Natko Biscan on 13.02.2023..
//

import SwiftUI

struct ContentView: View {
    @State var exampleNumber = 6
    
    @State private var isPressed: Bool = false
    @State private var amount: Double = 1.0
    @State private var isRotating: Bool = false
    @State private var isHidden: Bool = false
    @State private var progressValue: CGFloat = 0.0
    @State private var shouldExplode: Bool = false
    
    var body: some View {
        switch exampleNumber {
        case 0:
            ZStack {
                Color(.darkGray)
                    .ignoresSafeArea()
                Circle()
                    .frame(width: 150)
                    .foregroundColor(isPressed ? .green : .red)
                    .onTapGesture {
                        withAnimation(.easeIn(duration: 0.5)) {
                            isPressed.toggle()
                        }
                    }
            }
        case 1:
            ZStack {
                Color(.darkGray)
                    .ignoresSafeArea()
                Circle()
                    .frame(width: 150)
                    .foregroundColor(.red)
                    .scaleEffect(amount)
                    .onTapGesture {
                        withAnimation(.easeIn){
                            amount += 1
                        }
                    }
            }
        case 2:
            ZStack {
                Color(.darkGray)
                    .ignoresSafeArea()
                Capsule()
                    .foregroundColor(.gray)
                    .frame(height: 200)
                    .padding()
                Circle()
                    .frame(width: 150)
                    .foregroundColor(isPressed ? .green : .red)
                    .offset(x: isPressed ? 80 : -80)
                    .onTapGesture {
                        withAnimation(.easeIn){
                            isPressed.toggle()
                        }
                    }
            }
        case 3:
            ZStack {
                Color(.darkGray)
                    .ignoresSafeArea()
                Circle()
                    .frame(width: 150)
                    .foregroundColor(.red)
                    .scaleEffect(isPressed ? 2.5 : 1.0)
                    .onTapGesture {
                        withAnimation(.timingCurve(0.865, -0.295, 0.325, 1.275, duration: 0.7)){
                            isPressed.toggle()
                        }
                    }
                
            }
        case 4:
            ZStack {
                Color(.darkGray)
                    .ignoresSafeArea()
                Circle()
                    .frame(width: 150)
                    .foregroundColor(.red)
                    .offset(y: isPressed ? 250 : 1)
                    .onTapGesture {
                        withAnimation(
                            .interpolatingSpring(mass: 0.8, stiffness: 200, damping: 10)
                        ){
                            isPressed.toggle()
                        }
                    }
            }
        case 5:
            ZStack {
                Color(.darkGray)
                    .ignoresSafeArea()
                VStack(spacing: 14){
                    rect
                        .rotationEffect(.degrees(isRotating ? 48 : 0), anchor: .leading)
                    
                    rect
                        .scaleEffect(isHidden ? 0 : 1, anchor: isHidden ? .trailing: .leading)
                        .opacity(isHidden ? 0 : 1)
                    
                    rect
                        .rotationEffect(.degrees(isRotating ? -48 : 0), anchor: .leading)
                }
                .onTapGesture {
                    withAnimation(.interpolatingSpring(stiffness: 300, damping: 15)){
                        isRotating.toggle()
                        isHidden.toggle()
                    }
                }
            }
        case 6:
            ZStack {
                Color(.darkGray)
                    .ignoresSafeArea()
                ZStack {
                    Circle() // red one
                        .scale(progressValue * 2.6 + 1.0)
//                        .scale(shouldExplode ? 100.0 : 1.0) // add explosion
                        .foregroundColor(progressValue == 1 ? .white : .red)
                        .frame(width: 100, height: 100, alignment: .center)
                    
                    Circle() // white one
                        .scale(progressValue * 2.6 + 1.0)
                        .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                        .foregroundColor(.white)
                        .frame(width: 100, height: 100, alignment: .center)
                    
                    if progressValue == 1, isPressed {
                        Image(systemName: "checkmark")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(isPressed ? .green : .clear)
                            .animation(.easeIn, value: isPressed)
                    } else if progressValue == 0 {
                        Image(systemName: "touchid")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.white)
                    }
                    
                }
                .animation(.interpolatingSpring(stiffness: 100, damping: 15), value: progressValue)
                
                Circle()
                    .trim(from: 0.0, to: progressValue)
                    .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                    .foregroundColor(isPressed ? .green : .blue)
                    .animation(progressValue == 1 ? .linear(duration: 0.5).delay(0.5) : .none, value: progressValue)
                    .frame(width: 360, height: 360, alignment: .center)
                
            }
            .onLongPressGesture(minimumDuration: 10, perform: {}, onPressingChanged: { isPressing in
                if isPressing {
                    // start the animation
                    progressValue = 1
                    withAnimation(.linear.delay(1)) {
                        isPressed = true
                    }
                    withAnimation(.linear.delay(1.5)) {
                        shouldExplode = true
                    }

                } else {
                    // stop the animation
                    progressValue = 0
                    isPressed = false
                    shouldExplode = false
                }
            })
        default:
            EmptyView()
        }
    }
    
    @ViewBuilder
    var rect: some View {
        Rectangle()
            .frame(width: 64, height: 10)
            .cornerRadius(4)
            .foregroundColor(.red)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(exampleNumber: 0)
            .previewDisplayName("Toggle + Color Effect")
        ContentView(exampleNumber: 1)
            .previewDisplayName("Increment + Scale effect")
        ContentView(exampleNumber: 2)
            .previewDisplayName("Offset + Color")
        ContentView(exampleNumber: 3)
            .previewDisplayName("Toggle + Cubic Bezier effect")
        ContentView(exampleNumber: 4)
            .previewDisplayName("Spring effect")
        ContentView(exampleNumber: 5)
            .previewDisplayName("Spring + Rotation")
        ContentView(exampleNumber: 6)
            .previewDisplayName("Combination")
    }
}

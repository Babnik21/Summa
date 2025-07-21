//
//  TempView.swift
//  Summa
//
//  Created by Jure Babnik on 18. 7. 25.
//

import SwiftUI

enum LogoPhase {
    case none
    case deltoid
    case chevron
    case movedChevron
    case sigma
    case complete
    
    mutating func next() {
        switch self {
        case .none:
            self = .deltoid
        case .deltoid:
            self = .chevron
        case .chevron:
            self = .movedChevron
        case .movedChevron:
            self = .sigma
        case .sigma:
            self = .complete
        case .complete:
            self = .none
        }
    }
    
    func points(inset: CGFloat) -> [CGPoint] {
        let xInset = inset / 250
        let yInset = inset / 1.21 / 250
        
        switch self {
        case .deltoid:
            return [
                CGPoint(x: 0.3928 + xInset * 2 / sqrt(3), y: 0.5),
                CGPoint(x: 0.3928 + xInset * 2 / sqrt(3), y: 0.5),
                CGPoint(x: 0.5, y: 0.3508 + yInset / (1 / 2)), // 0.5 - 0.4572 = 0.0428
                CGPoint(x: 0.5, y: 0.3508 + yInset / (1 / 2)),
                CGPoint(x: 0.5, y: 0.3508 + yInset / (1 / 2)),
                CGPoint(x: 0.5, y: 0.3508 + yInset / (1 / 2)),
                CGPoint(x: 0.5, y: 0.3508 + yInset / (1 / 2)),
                CGPoint(x: 0.6072 - xInset * 2 / sqrt(3), y: 0.5), // 0.5622 + 0.0428 = 0.6072
                CGPoint(x: 0.5, y: 0.6492 - yInset / (1 / 2)),
                CGPoint(x: 0.5, y: 0.6492 - yInset / (1 / 2)),
                CGPoint(x: 0.5, y: 0.6492 - yInset / (1 / 2)),
                CGPoint(x: 0.5, y: 0.6492 - yInset / (1 / 2)),
                CGPoint(x: 0.5, y: 0.6492 - yInset / (1 / 2)),
                CGPoint(x: 0.3928 + xInset * 2 / sqrt(3), y: 0.5)
            ]
        case .chevron:
            return [
                CGPoint(x: 0.3928 + xInset * 2 / sqrt(3), y: 0.5),
                CGPoint(x: 0.0428 + xInset * sqrt(3), y: 0 + yInset),
                CGPoint(x: 0.2528 - xInset / sqrt(3), y: 0 + yInset),
                CGPoint(x: 0.3519 - xInset * sqrt(3), y: 0.15 - yInset), // 0.3091 + 0.0428 = 0.3519
                CGPoint(x: 0.3519 - xInset * sqrt(3), y: 0.15 - yInset), // y prev: 0.15
                CGPoint(x: 0.3519 - xInset * sqrt(3), y: 0.15 - yInset),
                CGPoint(x: 0.3519 - xInset * sqrt(3), y: 0.15 - yInset),
                CGPoint(x: 0.6072 - xInset * 2 / sqrt(3), y: 0.5),
                CGPoint(x: 0.3519 - xInset * sqrt(3), y: 0.85 + yInset),
                CGPoint(x: 0.3519 - xInset * sqrt(3), y: 0.85 + yInset),
                CGPoint(x: 0.3519 - xInset * sqrt(3), y: 0.85 + yInset),
                CGPoint(x: 0.3519 - xInset * sqrt(3), y: 0.85 + yInset),
                CGPoint(x: 0.2528 - xInset / sqrt(3), y: 1 - yInset),
                CGPoint(x: 0.0428 + xInset * sqrt(3), y: 1 - yInset)
            ]
        case .movedChevron:
            return [
                CGPoint(x: 0.352 + xInset * 2 / sqrt(3), y: 0.5),
                CGPoint(x: 0 + xInset * sqrt(3), y: 0 + yInset),
                CGPoint(x: 0.21 - xInset / sqrt(3), y: 0 + yInset),
                CGPoint(x: 0.3091 - xInset * sqrt(3), y: 0.15 - yInset),
                CGPoint(x: 0.3091 - xInset * sqrt(3), y: 0.15 - yInset),
                CGPoint(x: 0.3091 - xInset * sqrt(3), y: 0.15 - yInset),
                CGPoint(x: 0.3091 - xInset * sqrt(3), y: 0.15 - yInset),
                CGPoint(x: 0.5622 - xInset * 2 / sqrt(3), y: 0.5),
                CGPoint(x: 0.3091 - xInset * sqrt(3), y: 0.85 + yInset),
                CGPoint(x: 0.3091 - xInset * sqrt(3), y: 0.85 + yInset),
                CGPoint(x: 0.3091 - xInset * sqrt(3), y: 0.85 + yInset),
                CGPoint(x: 0.3091 - xInset * sqrt(3), y: 0.85 + yInset),
                CGPoint(x: 0.21 - xInset / sqrt(3), y: 1 - yInset),
                CGPoint(x: 0  + xInset * sqrt(3), y: 1 - yInset)
            ]
        case .sigma:
            return [
                CGPoint(x: 0.352 + xInset * 2 / sqrt(3), y: 0.5),
                CGPoint(x: 0 + xInset * sqrt(3), y: 0 + yInset),
                CGPoint(x: 1 - xInset * sqrt(3), y: 0 + yInset),
                CGPoint(x: 0.9009 - xInset / sqrt(3), y: 0.15 - yInset),
                CGPoint(x: 0.7604 + xInset, y: 0.15 - yInset),
                CGPoint(x: 0.7604 + xInset, y: 0.15 - yInset),
                CGPoint(x: 0.3091 - xInset * sqrt(3), y: 0.15 - yInset),
                CGPoint(x: 0.5622 - xInset * 2 / sqrt(3), y: 0.5),
                CGPoint(x: 0.3091 - xInset * sqrt(3), y: 0.85 + yInset),
                CGPoint(x: 0.7604 + xInset, y: 0.85 + yInset),
                CGPoint(x: 0.7604 + xInset, y: 0.85 + yInset),
                CGPoint(x: 0.9009 - xInset / sqrt(3), y: 0.85 + yInset),
                CGPoint(x: 1 - xInset * sqrt(3), y: 1 - yInset),
                CGPoint(x: 0 + xInset * sqrt(3), y: 1 - yInset)
            ]
        case .complete:
            return [
                CGPoint(x: 0.352 + xInset * 2 / sqrt(3), y: 0.5),
                CGPoint(x: 0 + xInset * sqrt(3), y: 0 + yInset),
                CGPoint(x: 1 - xInset * sqrt(3), y: 0 + yInset),
                CGPoint(x: 0.7604 + xInset, y: 0.3397 - yInset / (2 - sqrt(3))),
                CGPoint(x: 0.7604 + xInset, y: 0.3397 - yInset / (2 - sqrt(3))),
                CGPoint(x: 0.7604 + xInset, y: 0.15 - yInset),
                CGPoint(x: 0.3091 - xInset * sqrt(3), y: 0.15 - yInset),
                CGPoint(x: 0.5622 - xInset, y: 0.5),
                CGPoint(x: 0.3091 - xInset * sqrt(3), y: 0.85 + yInset),
                CGPoint(x: 0.7604 + xInset, y: 0.85 + yInset),
                CGPoint(x: 0.7604 + xInset, y: 0.6603 + yInset / (2 - sqrt(3))),
                CGPoint(x: 0.7604 + xInset, y: 0.6603 + yInset / (2 - sqrt(3))),
                CGPoint(x: 1 - xInset * sqrt(3), y: 1 - yInset),
                CGPoint(x: 0 + xInset * sqrt(3), y: 1 - yInset)
            ]
        case .none:
            return [
                CGPoint(x: 0.5, y: 0.5),
                CGPoint(x: 0.5, y: 0.5),
                CGPoint(x: 0.5, y: 0.5),
                CGPoint(x: 0.5, y: 0.5),
                CGPoint(x: 0.5, y: 0.5),
                CGPoint(x: 0.5, y: 0.5),
                CGPoint(x: 0.5, y: 0.5),
                CGPoint(x: 0.5, y: 0.5),
                CGPoint(x: 0.5, y: 0.5),
                CGPoint(x: 0.5, y: 0.5),
                CGPoint(x: 0.5, y: 0.5),
                CGPoint(x: 0.5, y: 0.5),
                CGPoint(x: 0.5, y: 0.5),
                CGPoint(x: 0.5, y: 0.5)
            ]
        }
    }
}

struct LineShape: InsettableShape {
    var phase: LogoPhase
    var insetAmount: CGFloat
    var points: [CGPoint]
    
    init(phase: LogoPhase, insetAmount: CGFloat = 0) {
        self.phase = phase
        self.insetAmount = insetAmount
        self.points = phase.points(inset: insetAmount)
    }
    
    var animatableData: AnimatableLine {
        get { AnimatableLine(values: phase.points(inset: insetAmount)) }
        set { points = newValue.values }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: points[0].x * rect.width, y: points[0].y * rect.height))
        for i in 1..<points.count {
            path.addLine(to: CGPoint(x: points[i].x * rect.width, y: points[i].y * rect.height))
        }
        
        path.closeSubpath()
        
        return path
    }
    
    func inset(by amount: CGFloat) -> some InsettableShape {
        var copy = self
        copy.insetAmount += amount
        return copy
    }
}


//struct Logo: Shape {
//    var phase: LogoPhase
//    
//    func path(in rect: CGRect) -> Path {
//        let w = rect.width
//        let h = rect.height
//        
//        var path = Path()
//        
//        let points: [CGPoint] = switch phase {
//        case .deltoid:
//            [
//                CGPoint(x: w * 0.352, y: h * 0.5),
//                CGPoint(x: w * 0.352, y: h * 0.5),
//                CGPoint(x: w * 0.4572, y: h * 0.3508),
//                CGPoint(x: w * 0.4572, y: h * 0.3508),
//                CGPoint(x: w * 0.4572, y: h * 0.3508),
//                CGPoint(x: w * 0.4572, y: h * 0.3508),
//                CGPoint(x: w * 0.4572, y: h * 0.3508),
//                CGPoint(x: w * 0.5622, y: h * 0.5),
//                CGPoint(x: w * 0.4572, y: h * 0.6492),
//                CGPoint(x: w * 0.4572, y: h * 0.6492),
//                CGPoint(x: w * 0.4572, y: h * 0.6492),
//                CGPoint(x: w * 0.4572, y: h * 0.6492),
//                CGPoint(x: w * 0.4572, y: h * 0.6492),
//                CGPoint(x: w * 0.352, y: h * 0.5)
//            ]
//        case .chevron:
//            [
//                CGPoint(x: w * 0.352, y: h * 0.5),
//                CGPoint(x: 0, y: 0),
//                CGPoint(x: w * 0.21, y: 0),
//                CGPoint(x: w * 0.3091, y: h * 0.15),
//                CGPoint(x: w * 0.3091, y: h * 0.15),
//                CGPoint(x: w * 0.3091, y: h * 0.15),
//                CGPoint(x: w * 0.3091, y: h * 0.15),
//                CGPoint(x: w * 0.5622, y: h * 0.5),
//                CGPoint(x: w * 0.3091, y: h * 0.85),
//                CGPoint(x: w * 0.3091, y: h * 0.85),
//                CGPoint(x: w * 0.3091, y: h * 0.85),
//                CGPoint(x: w * 0.3091, y: h * 0.85),
//                CGPoint(x: w * 0.21, y: h),
//                CGPoint(x: 0, y: h)
//            ]
//        case .sigma:
//            [
//                CGPoint(x: w * 0.352, y: h * 0.5),
//                CGPoint(x: 0, y: 0),
//                CGPoint(x: w, y: 0),
//                CGPoint(x: w * 0.9009, y: h * 0.15),
//                CGPoint(x: w * 0.7902, y: h * 0.15),
//                CGPoint(x: w * 0.7902, y: h * 0.15),
//                CGPoint(x: w * 0.3091, y: h * 0.15),
//                CGPoint(x: w * 0.5622, y: h * 0.5),
//                CGPoint(x: w * 0.3091, y: h * 0.85),
//                CGPoint(x: w * 0.7902, y: h * 0.85),
//                CGPoint(x: w * 0.7902, y: h * 0.85),
//                CGPoint(x: w * 0.9009, y: h * 0.85),
//                CGPoint(x: w, y: h),
//                CGPoint(x: 0, y: h)
//            ]
//        case .complete:
//            [
//                CGPoint(x: w * 0.352, y: h * 0.5),
//                CGPoint(x: 0, y: 0),
//                CGPoint(x: w, y: 0),
//                CGPoint(x: w * 0.7902, y: h * 0.3057),
//                CGPoint(x: w * 0.7902, y: h * 0.3057),
//                CGPoint(x: w * 0.7902, y: h * 0.15),
//                CGPoint(x: w * 0.3091, y: h * 0.15),
//                CGPoint(x: w * 0.5622, y: h * 0.5),
//                CGPoint(x: w * 0.3091, y: h * 0.85),
//                CGPoint(x: w * 0.7902, y: h * 0.85),
//                CGPoint(x: w * 0.7902, y: h * 0.6943),
//                CGPoint(x: w * 0.7902, y: h * 0.6943),
//                CGPoint(x: w, y: h),
//                CGPoint(x: 0, y: h)
//            ]
//        }
//        
//        path.move(to: points[0])
//        for point in points.dropFirst() {
//            path.addLine(to: point)
//        }
//        path.closeSubpath()
//        
//        return path
//    }
//}


struct LogoView: View {
    @Binding var backgroundPhase: LogoPhase
    @Binding var foregroundPhase: LogoPhase
    var strokeWidth: CGFloat = 4
    
    var body: some View {
        ZStack {
//            LineShape(points: backgroundPhase.points(), phase: backgroundPhase)
//                .fill(.black)
            
            LineShape(phase: foregroundPhase)
                .strokeBorder(.blue, lineWidth: strokeWidth)
                .fill(.red)
        }
    }
}

struct TempView: View {
    @State private var backgroundPhase: LogoPhase = .deltoid
    @State private var foregroundPhase: LogoPhase = .deltoid
    
    @State private var outerOutline: Bool = false
    
    
    private let strokeWidth: CGFloat = 8
//    @State private var changeShape: Bool = true

    
    var body: some View {
        
        VStack {
            
            LogoView(
                backgroundPhase: $backgroundPhase,
                foregroundPhase: $foregroundPhase,
                strokeWidth: strokeWidth
            )
                .frame(width: 250, height: 305)

            
                Button {
//                    withAnimation(.easeIn(duration: 0.2)) {
//                        backgroundPhase = .chevron
//                        foregroundPhase = .deltoid
//                    } completion: {
//                        withAnimation(.easeIn(duration: 0.2)) {
//                            foregroundPhase = .chevron
//                        } completion: {
//                            withAnimation(.easeIn(duration: 0.2)) {
//                                backgroundPhase = .movedChevron
//                                foregroundPhase = .movedChevron
//                            } completion: {
//                                withAnimation(.easeIn(duration: 0.2)) {
//                                    backgroundPhase = .sigma
//                                } completion: {
//                                    withAnimation(.easeIn(duration: 0.2)) {
//                                        backgroundPhase = .complete
//                                        foregroundPhase = .sigma
//                                    } completion: {
//                                        withAnimation(.easeIn(duration: 0.2)) {
//                                            foregroundPhase = .complete
//                                        }
//                                    }
//                                }
//                            }
//                        }
//                    }
                    
                    withAnimation(.linear(duration: 1)) {
                        backgroundPhase.next()
                        foregroundPhase.next()
                    }

                } label: {
                    Capsule()
                        .fill(Color.blue)
                        .frame(width: 100, height: 50)
                        .overlay {
                            Text("Animate")
                                .foregroundStyle(.white)
                        }
                }
                
                Button {
                    foregroundPhase = .deltoid
                    backgroundPhase = .deltoid
                } label: {
                    Capsule()
                        .fill(Color.blue)
                        .frame(width: 100, height: 50)
                        .overlay {
                            Text("Reset")
                                .foregroundStyle(.white)
                        }
                }
            
                Button {
                    outerOutline.toggle()
                } label: {
                    Capsule()
                        .fill(Color.blue)
                        .frame(width: 100, height: 50)
                        .overlay {
                            Text("Toggle Outline")
                                .foregroundStyle(.white)
                        }
                }
        }
    }
}

#Preview {
    TempView()
}

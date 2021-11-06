//
//  ContentView.swift
//  Spirograph
//
//  Created by Aliakbar Eski on 2021-11-06.
//

import SwiftUI

class Spirograph {
    let frameWidth = 500.0
    let frameHeight = 500.0
    let w = 1
    var cx = 0.0
    var cy = 0.0
    var radiusMult = 1.0
    
    var radii: [CGFloat] = [120, 10]
    var mults: [CGFloat] = [1, 12]
        
    var startx = 0.0
    var starty = 0.0
    
    init(){
        calculateParams()
    }
    
    func calculateParams(){
        var radiiSum = 0.0
        for idx in 0..<radii.count {
            radiiSum += abs(radii[idx])
        }
        let radiiMults = [frameWidth/(2*radiiSum), frameHeight/(2*radiiSum)]
        radiusMult = radiiMults.min() ?? 1.0
        
        cx = frameWidth/2.0
        cy = frameHeight/2.0
        
        let startPoint: CGPoint = getXYFrom(t:0)
        startx = startPoint.x
        starty = startPoint.y
    }
    
    func getXYFrom(t: CGFloat) -> CGPoint{
        var point = CGPoint(x:cx, y:cy)
        for idx in 0..<radii.count {
            point.x += radii[idx] * radiusMult * sin((mults[idx] * CGFloat(w) * t)/100.0)
            point.y += radii[idx] * radiusMult * cos((mults[idx] * CGFloat(w) * t)/100.0)
        }
        return point
    }
    
    func setRadii(idx: Int, val: Binding<CGFloat>) {
        radii[idx] = val.wrappedValue
        calculateParams()
    }
    
    func setMult(idx: Int, val: Binding<CGFloat>) {
        mults[idx] = floor((val.wrappedValue * 100)/25) * 25 / 100
        calculateParams()
    }
}

struct ContentView: View {
    
    @State var value: Float = 0
    @State var sliderValue1: CGFloat = 1
    @State var sliderValue2: CGFloat = 1
    @State var strokeColor: Color = .blue
    let array = [1, 2, 3, 4]
    var body: some View {
        
        let spirograph = Spirograph()
        ZStack {
            VStack() {
                Text("Spirograph- SwiftUIJam 2021")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 2)
                Text("By Eski and Erin")
                    .font(.title)
                Spacer()
            }
            
            HStack {
                Path { path in
                    
                    spirograph.setRadii(idx: 0, val: $sliderValue1)
                    spirograph.setMult(idx: 1, val: $sliderValue2)
                    
                    path.move(
                        to: CGPoint(
                            x: spirograph.startx,
                            y: spirograph.starty
                        )
                    )
                    
                    for t in 0...3600{
                        path.addLine(to: spirograph.getXYFrom(t: CGFloat(t)))
                    }
                }
                .stroke($strokeColor.wrappedValue, lineWidth: 1)
                .frame(width: spirograph.frameWidth, height: spirograph.frameHeight, alignment: .center)
                
                VStack {
                    ColorPicker ("Color of Drawer", selection: $strokeColor)
                    HStack {
                        Text("Radius Ratio: ")
                        Slider(value: $sliderValue1, in: 1...100)
                            .onChange(of: self.sliderValue1) { newValue in
                                sliderValue1 = newValue
                            }
                    }
                    
                    HStack {
                        Text ("Multiplier: ")
                        Slider(value: $sliderValue2, in: -10...10)
                            .onChange(of: self.sliderValue2) { newValue in
                                sliderValue2 = newValue
                            }
                    }
                }
                .padding()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .previewInterfaceOrientation(.landscapeLeft)
        }
    }
}

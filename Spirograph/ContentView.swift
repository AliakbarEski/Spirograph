//
//  ContentView.swift
//  Spirograph
//
//  Created by Aliakbar Eski on 2021-11-06.
//

import SwiftUI

struct CircleParams {
    var radii: Double
    var speed: Double
}

class Spirograph{
    //    let screenHeight = UIScreen.main.bounds.height
    //    let screenWidth = UIScreen.main.bounds.width
    let frameWidth = 500.0
    let frameHeight = 500.0
    let w = 1
    var cx = 0.0  //UIScreen.main.bounds.width/2.0
    var cy = 0.0 //UIScreen.main.bounds.height/2.0
    var radiusMult = 1.0
    
    var radii: [CGFloat] = [120, 40]
    var mults: [CGFloat] = [1, 12]
    
    var cicleParams: [CircleParams] = []
    
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
        startx = cx
        starty = cy
        for idx in 0..<radii.count {
            startx += radii[idx] * radiusMult * sin(0)
            starty += radii[idx] * radiusMult * cos(0)
        }
    }
    
    func getXYFrom(t: Binding<CGFloat>) -> CGPoint{
        let value = t.wrappedValue
        var point = CGPoint(x:cx, y:cy)
        for idx in 0..<radii.count {
            point.x += radii[idx] * radiusMult * sin((mults[idx] * CGFloat(w) * value)/100.0)
            point.y += radii[idx] * radiusMult * cos((mults[idx] * CGFloat(w) * value)/100.0)
        }
        return point
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
        mults[idx] = CGFloat(Int(val.wrappedValue))
        calculateParams()
    }
}

struct ContentView: View {
    
    @State var textValue: String = "hello"
    @State var value: Float = 0
    @State var sliderValue1: CGFloat = 0
    @State var sliderValue2: CGFloat = 1
    @State var strokeColor: Color = .blue
    let array = [1, 2, 3, 4]
    var body: some View {
        
        
        //how to declare these as doubles?
        //implicit type casting
        //background colour
        //stroke colour
        //animation?
        //use pencil to allow to draw on canvas like a real spirograph?
        
        let spirograph = Spirograph()
        ZStack {
            VStack() {
                Text("Spirograph - by Eski and Erin")
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
                    
                    //step size?
                    for t in 0...3600{
                        path.addLine(to: spirograph.getXYFrom(t: CGFloat(t)))
                    }
                }
                .stroke($strokeColor.wrappedValue, lineWidth: 1)
                .frame(width: spirograph.frameWidth, height: spirograph.frameHeight, alignment: .center)
//                .background(.green)
                
                VStack {
                    
                    ColorPicker ("Color of Drawer", selection: $strokeColor)
                    
                    Slider(value: $sliderValue1, in: 0...100)
                        .onChange(of: self.sliderValue1) { newValue in
                            sliderValue1 = newValue
                        }
                        
                    Slider(value: $sliderValue2, in: 1...30)
                        .onChange(of: self.sliderValue2) { newValue in
                            sliderValue2 = newValue
                        }
                        
                }
//                .background(.green)
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

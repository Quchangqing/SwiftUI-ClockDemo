//
//  ContentView.swift
//  ClockDemo
//
//  Created by nobady on 2021/1/19.
//

import SwiftUI

struct ContentView: View {
    @State var isDark = false
    var body: some View {
        NavigationView {
            Home(isDark: $isDark)
                .navigationBarHidden(true)
                .preferredColorScheme(isDark ? .dark : .light)
        }
    }
}

struct Home: View {
    
    @Binding var isDark: Bool
    @State var current_time: Time = Time(sec: 0, min: 0, hour: 0)
    @State var recivier = Timer.publish(every: 1, on: .current, in: .default).autoconnect()
    
    var body: some View {
        
        VStack {
            HStack {
                Text("时钟")
                    .font(.title)
                    .fontWeight(.heavy)
                Spacer(minLength: 0)
                Button(action: {
                    isDark.toggle()
                }) {
                    Image(systemName: isDark ? "sun.min.fill" : "moon.fill")
                        .font(.system(size: 22))
                        .foregroundColor( isDark ? .black : .white)
                        .padding()
                        .background(Color.primary)
                        .clipShape(Circle())
                }
            }
            .padding()
            
            Spacer(minLength: 0)
            
            ZStack {
                Circle()
                    .fill(Color.black.opacity(0.1))
                
                ForEach(0..<60){i in
                    //dot
                    Rectangle()
                        .fill(Color.primary)
                        .frame(width: 2, height: i % 5 == 0 ? 15 : 5)
                        .offset(y: (width - 110)/2)
                        .rotationEffect(.init(degrees: Double(i) * 6))
                    
                    //second
                    Rectangle()
                        .fill(Color.primary)
                        .frame(width: 2, height: (width - 180)/2)
                        .offset(y: -(width - 180)/4)
                        .rotationEffect(.init(degrees: Double(current_time.sec) * 6))
                    
                    //min
                    Rectangle()
                        .fill(Color.primary)
                        .frame(width: 4, height: (width - 200)/2)
                        .offset(y: -(width - 200)/4)
                        .rotationEffect(.init(degrees: Double(current_time.min) * 6))
                    
                    //hour
                    Rectangle()
                        .fill(Color.primary)
                        .frame(width: 4.5, height: (width - 240)/2)
                        .offset(y: -(width - 240)/4)
                        .rotationEffect(.init(degrees: (Double(current_time.hour) + (Double(current_time.min) / 60)) * 30))
                    
                    //center
                    Circle()
                        .fill(Color.primary)
                        .frame(width: 15, height: 15)
                }
                
            }
            .frame(width: width - 80, height: width - 80)
             
            Spacer()
        }
        .onAppear(perform: {
            
            let calendar = Calendar.current
            let sec = calendar.component(.second, from: Date())
            let min = calendar.component(.minute, from: Date())
            let hour = calendar.component(.hour, from: Date())
            
            withAnimation(Animation.linear(duration: 0.01)) {
                self.current_time = Time(sec: sec, min: min, hour: hour)
            }
            
        })
        .onReceive(recivier, perform: { _ in
            let calendar = Calendar.current
            let sec = calendar.component(.second, from: Date())
            let min = calendar.component(.minute, from: Date())
            let hour = calendar.component(.hour, from: Date())
            
            withAnimation(Animation.linear(duration: 0.01)) {
                self.current_time = Time(sec: sec, min: min, hour: hour)
            }
        })
    }
}

struct Time {
    var sec: Int
    var min: Int
    var hour: Int
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

let width = UIScreen.main.bounds.size.width

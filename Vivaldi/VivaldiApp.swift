//
//  VivaldiApp.swift
//  Vivaldi
//
//  Created by LiLi on 2023/11/28.
//

import SwiftUI
import SwiftData
import Combine

@main
struct VivaldiApp: App {
    
    @State private var uiConfiguration = UIConfiguration.shared
    
    
    @State var text = "sdasdasdas"
    @State var color = UIColor.green
    var body: some Scene {
        WindowGroup {
            VStack {
                Test()
                    .text(text)
                    .color(color)
                    .frame(height: 400)
                    .border(.red)
                
                Button("Random") {
                    text = "text updated!"
                    color = UIColor.red
                }
            }
        }
        .environmentObject(LockState())
        .environment(uiConfiguration)
    }
}

class Observe: ObservableObject {
    @Published var text: String?
    @Published var textColor: UIColor?
}

struct Test: UIViewRepresentable {
    
    class Coordinator {
        weak var label: UILabel?
        
        var cancellables = Set<AnyCancellable>()
        
        func subscribe(_ obj: Observe) {
            obj.$text.sink { [weak self] text in
                self?.label?.text = text
            }
            .store(in: &cancellables)
            obj.$textColor.sink { [weak self] color in
                self?.label?.textColor = color
            }
            .store(in: &cancellables)
        }
        
    }
    
    static var obj = Observe()
    
    func makeUIView(context: Context) -> UILabel {
        let label = UILabel()
        context.coordinator.label = label
        
        context.coordinator.subscribe(Self.obj)
        return label
    }
    
    func makeCoordinator() -> Coordinator {
        let coordinator = Coordinator()
        return coordinator
    }
    
    func updateUIView(_ uiView: UILabel, context: Context) {
        
    }
    
}


extension Test {
    
    func text(_ text: String) -> Self {
        Self.obj.text = text
        return self
    }
    
    func color(_ color: UIColor) -> Self {
        Self.obj.textColor = color
        return self
    }
}

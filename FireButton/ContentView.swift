//
//  ContentView.swift
//  FireButton
//
//  Created by cm0620 on 2023/3/22.
//

import SwiftUI

// https://zhangdinghao.cn/2017/06/25/swift-animation07/

struct ContentView: View {
    var body: some View {
        Button(action: {}) {
            Text("Press me!")
        }.frame(width: 100, height: 100)
        .buttonStyle(FlameButtonStyle())
    }
}

struct FlameButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(20)
            .foregroundColor(.white)
            .background(
                ZStack {
                    if configuration.isPressed {
                        FlameParticleView()
                    } else {
                        Circle()
                            .fill(Color.red)
                    }
                }
            )
    }
}

struct FlameParticleView: View {
    var body: some View {
        ParticleView(particle: .fire)
            .frame(width: 100, height: 100)
            .scaleEffect(1.2)
            .opacity(0.8)
    }
}

struct ParticleView: UIViewRepresentable {
    let particle: ParticleType
    func makeUIView(context: Context) -> ParticleUIView {
        let size = CGSize(width: 100.0, height: 100.0)
        return ParticleUIView(frame: CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height), particle: particle)
    }
    func updateUIView(_ uiView: ParticleUIView, context: Context) {
        uiView.particle = particle
    }
}

class ParticleUIView: UIView {
    var particle: ParticleType
    init(frame: CGRect, particle: ParticleType) {
        self.particle = particle
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if let emitterLayer = layer as? CAEmitterLayer {
            emitterLayer.position = center
            emitterLayer.emitterPosition = CGPoint(x: bounds.midX, y: bounds.midY)
            emitterLayer.emitterSize = bounds.size
            emitterLayer.renderMode = .additive
            emitterLayer.emitterMode = .outline
            emitterLayer.emitterShape = .line
            switch particle {
            case .fire:
                emitterLayer.emitterCells = [fireEmitterCell()]
            case .smoke:
                emitterLayer.emitterCells = [smokeEmitterCell()]
            }
        }
    }
    
    override class var layerClass: AnyClass {
        return CAEmitterLayer.self
    }
    
    private func fireEmitterCell() -> CAEmitterCell {
        let cell = CAEmitterCell()
        cell.name = "fire"
        cell.birthRate = 500
        cell.lifetime = 1
        cell.emissionLongitude = .pi
        cell.velocity = -1 // 粒子速度
        cell.emissionRange = 1.1 // 發射角度
        cell.yAcceleration = -200 // 加速度
        cell.scaleSpeed = 0.5 // 縮放
        cell.color = UIColor(red: 0.5 ,green: 0 ,blue: 0 ,alpha: 0.1).cgColor
        cell.contents = UIImage(named: "fire")?.cgImage
        return cell
    }
    
    private func smokeEmitterCell() -> CAEmitterCell {
        let cell = CAEmitterCell()
        cell.birthRate = 50
        cell.lifetime = 4.0
        cell.lifetimeRange = 1.0
        cell.color = UIColor(white: 0.3, alpha: 0.7).cgColor
        cell.contents = UIImage(named: "smoke")?.cgImage
        cell.scale = 0.1
        cell.scaleRange = 0.05
        cell.emissionLongitude = -.pi / 2
        cell.emissionRange = .pi / 4
        cell.velocity = 40
        cell.velocityRange = 10
        cell.alphaSpeed = -0.03
        cell.yAcceleration = -50
        return cell
    }
}

enum ParticleType {
    case fire
    case smoke
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//
//  GameScene.swift
//  DiveIntoSpriteKit
//
//  Created by Paul Hudson on 16/10/2017.
//  Copyright © 2017 Paul Hudson. All rights reserved.
//

import SpriteKit
import CoreMotion

@objcMembers
class GameScene: SKScene {
    
    let player = SKSpriteNode(imageNamed: "player-submarine.png")
    let motionManager = CMMotionManager()
    var gameTimer: Timer?
    
    override func didMove(to view: SKView) {
        // this method is called when your game scene is ready to run
        
        let background = SKSpriteNode(imageNamed: "water.jpg")
        background.zPosition = -1
        addChild(background)
        //bubbles
        if let particles = SKEmitterNode(fileNamed: "Bubbles") {
            particles.advanceSimulationTime(10)
            particles.position.x = 512
            addChild(particles)
        }
        
        player.position.x = -400
        player.zPosition = 1
        addChild(player)
        
        motionManager.startAccelerometerUpdates()
        
        gameTimer = Timer.scheduledTimer(timeInterval: 0.35, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // this method is called when the user touches the screen
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // this method is called when the user stops touching the screen
    }
    
    override func update(_ currentTime: TimeInterval) {
        // this method is called before each frame is rendered
        
        func createEnemy() {
            //code goes here
            
            let sprite = SKSpriteNode(imageNamed: "mine")
            sprite.position = CGPoint(x: 1200, y: Int.random(in: -350...350))
            sprite.name = "enemy"
            sprite.zPosition = 1
            addChild(sprite)
            
            sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
            sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
            sprite.physicsBody?.linearDamping = 0
            
        }
        
        
        
        if let accelerometerData =
            motionManager.accelerometerData {
            let changeX =
            CGFloat(accelerometerData.acceleration.y) * 100
            let changeY =
            CGFloat(accelerometerData.acceleration.x) * 100
            player.position.x -= changeX
            player.position.y += changeY
        }
        
    }
}


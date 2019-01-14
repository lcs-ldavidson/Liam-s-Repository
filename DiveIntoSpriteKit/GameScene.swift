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
class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let player = SKSpriteNode(imageNamed: "player-submarine.png")
    let torpedo = SKSpriteNode(imageNamed: "Torpedo.png")
    let motionManager = CMMotionManager()
    var gameTimer: Timer?
    let scoreLabel = SKLabelNode(fontNamed: "AvenirNextCondensed-Bold")
    var score = 0 {
        didSet {
            scoreLabel.text = "SCORE: \(score)"
        }
    }
    let music = SKAudioNode(fileNamed: "cyborg-ninja.mp3")
    let Jet = SKEmitterNode(fileNamed: "JetStream.sks")
    
    
    
    
    
    override func didMove(to view: SKView) {
        // this method is called when your game scene is ready to run
        
        //background
        let background = SKSpriteNode(imageNamed: "water.jpg")
        background.zPosition = -1
        addChild(background)
        
        //bubbles
        if let particles = SKEmitterNode(fileNamed: "Bubbles") {
            particles.advanceSimulationTime(10)
            particles.position.x = 512
            addChild(particles)
        }
        
        //player
        player.position.x = -400
        player.zPosition = 2
        addChild(player)
        player.physicsBody = SKPhysicsBody (texture: player.texture!, size: player.size)
        player.physicsBody?.categoryBitMask = 1
        
        motionManager.startAccelerometerUpdates()
        
        gameTimer = Timer.scheduledTimer(timeInterval: 0.35, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
        
        physicsWorld.contactDelegate = self
        
        scoreLabel.zPosition = 2
        scoreLabel.position.y = 300
        addChild(scoreLabel)
        score = 0
        
        addChild(music)
        
        Jet?.zPosition = 1
        addChild(Jet!)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // this method is called when the user touches the screen
        
//        torpedoLaunch()
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // this method is called when the user stops touching the screen
    }
    
    override func update(_ currentTime: TimeInterval) {
        // this method is called before each frame is rendered
        
        for node in children {
            if node.position.x < -700 {
                node.removeFromParent()
            }
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
        
        if player.parent != nil {
            score += 1
        }
        
        if player.position.x < -400 {
            player.position.x = -400
        } else if player.position.x > 400 {
            player.position.x = 400
        }
        
        if player.position.y < -300 {
            player.position.y = -300
        } else if player.position.y > 300 {
            player.position.y = 300
        }
        
        Jet?.particlePosition.x = player.position.x - 45
        Jet?.particlePosition.y = player.position.y - 10
        
    }
    
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
        sprite.physicsBody?.contactTestBitMask = 1
        sprite.physicsBody?.categoryBitMask = 0
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        
        if nodeA == player {
            playerHit(nodeB)
        } else {
            playerHit(nodeA)
        }
    }
    
    func playerHit(_ node: SKNode) {
        if let particles = SKEmitterNode(fileNamed: "Explosion.sks") {
            particles.position = player.position
            particles.zPosition = 3
            addChild(particles)
        }
        
        Jet?.removeFromParent()
        player.removeFromParent()
        
        let sound = SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: false)
        run(sound)
        music.removeFromParent()
        
        let gameOver = SKSpriteNode(imageNamed: "gameOver-3")
        gameOver.zPosition = 10
        addChild(gameOver)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if let scene = GameScene(fileNamed: "GameScene") {
                // make it stretch to fill all available space
                scene.scaleMode = .aspectFill
                // present it immediately
                self.view?.presentScene(scene)
            }
        }
    }
    
    
    func torpedoLaunch() {
        
        //create torpedo
        if torpedo.parent == nil {
            
            torpedo.physicsBody = SKPhysicsBody(texture: torpedo.texture!, size: torpedo.size)
            torpedo.position.x = player.position.x + 100
            torpedo.position.y = player.position.y
            torpedo.physicsBody?.categoryBitMask = 3
            addChild(torpedo)
            torpedo.scale(to: CGSize(width: 40, height: 30))
            torpedo.physicsBody?.velocity = CGVector(dx: 150, dy: 0)
        }
        
    }
    
    
    
    
}


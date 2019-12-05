//: # A SpriteKit-based Playground
//: ## Physics body demo
//: ### Required libraries
import PlaygroundSupport    // Allows playground to show live view
import SpriteKit            // Provides 2D graphics classes

/*:
 ### Initial scene setup
 Here we define the size and background color of the scene.
 */
// Define the size of the animation
let frame = CGRect(x: 0, y: 0, width: 400, height: 320)

// Set the midpoint of the scene to the centre of the frame
let midpoint = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)

// Create an instance of SKScene to contain our game / animation
var scene = SKScene(size: frame.size)

// Set the scene background color
scene.backgroundColor = UIColor.black

/*:
 ### Present the scene
 For UIKit projects you have usually created views on a storyboard in Interface Builder.
 
 Here, we create a view in code instead, and then show that view in the playground's live view area.
 */
// Create a view – an instance of the SKView class
let view = SKView(frame: frame)
view.showsFPS = true
view.showsNodeCount = true

// Present the scene we just configured
view.presentScene(scene)

// Show the view in the live view area at right
PlaygroundSupport.PlaygroundPage.current.liveView = view

/*:
 ### Define and add sprites
 
 Sprites can take the the form of abstract shapes – for example, via an instance of `SKShapeNode`.
 
 More commonly, sprites are created from the `SKSpriteNode` class and based on a bitmap image you provide.
 
 This means sprites in your games or animations can be images you find online, or images you create yourself (for example, using an iPad, or by scanning hand-drawn images).
 */

// Make a three sprites (nodes) of various shapes

// 1. A square
let square = SKSpriteNode(imageNamed: "square")
/*:
 - Callout(Naming nodes):
 By [naming nodes with the same identifier](https://developer.apple.com/documentation/spritekit/sknode/1483136-name) we can later "find" and "do something with" all nodes that share this identifer.
 */
square.name = "shape"
square.position = CGPoint(x: scene.size.width * 0.25,
                          y: scene.size.height * 0.50)      // Left side

// 2. A circle
let circle = SKSpriteNode(imageNamed: "circle")
circle.name = "shape"
circle.position = CGPoint(x: scene.size.width * 0.50,
                          y: scene.size.height * 0.50)      // Centre

// 3. A star
let star = SKSpriteNode(imageNamed: "star")
star.name = "shape"
star.position = CGPoint(x: scene.size.width * 0.75,
                            y: scene.size.height * 0.50)    // Right side

/*:
- Callout(Experiment):
Try commenting out one or more of the following three lines of code. What happens?
 */
// Finally, actually go ahead and add the nodes to the scene
scene.addChild(square)
scene.addChild(circle)
scene.addChild(star)


/*:
 ### Physics bodies
 One of the huge benefits that SpriteKit offers is a built-in physics engine.
 
 That might sound complicated. It's simple, though – all you need to understand is that you can tell SpriteKit how you want a node to move (velocity), whether you want it to slow down (due to friction), and whether it is affected by gravity.
 
 To have nodes be affected by the SpriteKit physics, we must define *bodies*, or edges, for the nodes.
 
 */
/*:
- Callout(Experiment):
Remove the comments below, one by one. Run the scene after each comment you remove. What happens?
 */
square.physicsBody = SKPhysicsBody(texture: square.texture!,
                                   alphaThreshold: 0.1,
                                   size: square.size)

circle.physicsBody = SKPhysicsBody(texture: circle.texture!,
                                   alphaThreshold: 0.1,
                                   size: circle.size)

star.physicsBody = SKPhysicsBody(texture: star.texture!,
                                 alphaThreshold: 0.1,
                                 size: star.size)

/*:
### More about physics bodies
"The circle body is a **dynamic** physics body — that is, it moves. It’s solid, has mass and can collide with any other type of physics body. The physics simulation can apply various forces to move volume-based bodies."

"The edge loop body is a **static** volume-less physics body — that is, it does not move. As the name implies, an edge loop only defines the edges of a shape. It doesn’t have mass, cannot collide with other edge loop bodies and is never moved by the physics simulation. Other objects can be inside or outside its edges."

"The most common use for an edge loop body is to define collision areas to describe your game’s boundaries, ground, walls, trigger areas or any other type of unmoving collision space."
 
![example](types-of-physics-bodies.png "Types of physics bodies")
 
 *Excerpts and image from:* [2D Apple Games by Tutorials, raywenderlich.com](https://store.raywenderlich.com/products/2d-apple-games-by-tutorials)

 Try uncommenting the line below the "Make an edge loop at the boundaries of the scene" comment.
 
 What happens to the circle now?
 */
// Make an edge loop at the boundaries of the scene
scene.physicsBody = SKPhysicsBody(edgeLoopFrom: scene.frame)

/*:
 ### Helper functions
 
 These functions are used by the code further below.
 
 Consider expanding each function to understand how it works.
 
 */
// This function returns a random number
public func random(min: CGFloat, max: CGFloat) -> CGFloat {
    
    // Get a random number between 0 and largest possible number for an unsigned 32-bit integer
    let randomValue = arc4random()
    
    // Get a decimal value between 0 and 1 by dividing by largest possible number for an unsigned 32-bit integer
    let decimal = Float(randomValue) / Float(UInt32.max)
    
    // Scale the decimal value to the range between max and min
    let scaled = CGFloat(decimal) * (max - min)
    
    // Now push the random value into the desired range by adding the minimum value
    return scaled + min
    
}

// This function will add a sand sprite to the scene
func spawnSand() {
    
    // Create a node from the sand image
    let sand = SKSpriteNode(imageNamed: "sand")
    
    // Vertical position just above top of the scene
    let y = scene.size.height - sand.size.height
    // Horizontal position is randome
    let x = random(min: 0.0, max: scene.size.width)
    
    // Set the grain of sand's position
    sand.position = CGPoint(x: x, y: y)
    
    // Create a physics body for the grain of sand
    sand.physicsBody = SKPhysicsBody(circleOfRadius:
        sand.size.width/2)
    
    // Name the node
    sand.name = "sand"
    
    // Add node to the scene
    scene.addChild(sand)
}

/*:
 ### Create a lot of sand particles
 
 This code adds 100 sand particles to the scene at a rate of 1 particle per second.
 */

// Drop a lot of sand particles from the top of screen
let actionRun = SKAction.run(spawnSand)
let actionWait = SKAction.wait(forDuration: 1.0)
let sequence = SKAction.sequence([actionRun, actionWait])
let actionRepeat = SKAction.repeat(sequence, count: 100)
scene.run(actionRepeat)



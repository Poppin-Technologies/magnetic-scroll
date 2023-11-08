![Magnetic Scroll](https://github.com/Poppin-Technologies/magnetic-scroll/assets/69051988/f6c7b963-39da-4497-8e0c-cfc06d973f40)
# MagneticScroll

A Library that adds a sticky behavior to the `SwiftUI`'s `ScrollView`, while triggering a smooth haptic feedback as you scroll through the views.

<h3 style ="text-align: center">Installation</h3> 
<p>Requires <b>iOS 14.0+</b> 

MagneticScroll currently can only be installed through the Swift Package Manager.</p>

<table>
<tr>
<td>
<strong>
Swift Package Manager
</strong>
<br>
Add the Package URL: 
</td>
</tr>
<tr>
<td>
<br>

```
https://github.com/Poppin-Technologies/magnetic-scroll.git
```

</td>
</table>

## Showcase
### ⚛️ Regular Magnetic Scroll
As you scroll, when the `ScrollView`'s velocity is lesser than `MagneticScrollView`'s velocity, magnetic scroll automatically sticks to the predicted end location.

![regular](https://github.com/Poppin-Technologies/magnetic-scroll/assets/69051988/838e1403-f0b1-4289-a4f3-24925377fe15)

### ✨ Manually changing the blocks
![manual](https://github.com/Poppin-Technologies/magnetic-scroll/assets/69051988/1a83b124-3b1f-4108-a483-515d2e6b09f3)

### 🙌 Magnetic Scroll with `.matchedGeometryEffect` modifier
![geometry](https://github.com/Poppin-Technologies/magnetic-scroll/assets/69051988/d0f629f1-04d4-4874-be00-41583129b093)

## Usage
```swift 
import SwiftUI
import MagneticScroll

struct ContentView: View {
  // If you were to set activeBlock to "second" or "first" manually, MagneticScroll would automatically scroll to the block with that id.
  @State private var activeBlock = "first"
  var body: some View {
    MagneticScrollView(activeBlock: $activeBlock) { organizer in
      Block(id: "first", height: 400, inActiveHeight: 300) { // All of these fields are optional, except the ID, but magnetic scroll works x5 better with constant heights.
        Text("Hello World")
      }
      Block(id: "second", height: 400, inActiveHeight: 300) {
        Text("Hello World")
      }
    }
  }
}
```
## Methods

Here are the methods available for configuring the behavior of `MagneticScrollView`:

### 🖱️ changesActiveBlockOnTapGesture(_ value: Bool)
Sets whether the active block should be changed on a tap gesture.
### 🏁 velocityThreshold(_ threshold: Double)
Sets the velocity threshold for `MagneticScrollView` to react to scroll view velocity.
### 📳 triggersHapticFeedbackOnBlockChange(_ bool: Bool)
Sets whether haptic feedback should be triggered when the active block changes.
### 📳 triggersHapticFeedbackOnActiveBlockChange(_ bool: Bool)
Sets whether haptic feedback should be triggered when the active block changes.
### 📋 formStyle(_ bool:)
Sets whether the form style should be enabled or not.
### ⏳ scrollAnimationDuration(_ duration: Double)
Sets the scroll animation duration when changing the active block.
### ⌛ setTimeout(_ duration: Double)
Sets the timeout duration needed to change a block to another.

## Organizer
`MagneticScrollView` gives an organizer to control the behavior of itself. Organizer contains a `ScrollViewProxy` so if you want to control the `ScrollView` itself, you can use that.
### 🪐 activate(with: Block.ID)
Activates a block with given ID. But doesn't scroll to it
### 👇🏻 scrollTo(id: Block.ID, anchor: UnitPoint)
Scrolls and activates a block with given id and anchor
### 👆🏻 scrollToCurrentOffset()
Scrolls to the nearest block with the current offset of the `MagneticScrollView`.


## Apps Using MagneticScroll

#### [Poppin](https://apps.apple.com/us/app/poppin-the-party-platform/id1573674111) - The Party Platform 
### ![logoppin](https://github.com/Poppin-Technologies/magnetic-scroll/assets/69051988/874e990f-fc80-43fb-b14f-a488faecaaa3)
![poppin](https://github.com/Poppin-Technologies/magnetic-scroll/assets/69051988/849d6a8e-019c-4739-8c8a-fb6f29d62fed)

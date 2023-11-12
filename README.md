![thmb-modified](https://github.com/Poppin-Technologies/magnetic-scroll/assets/69051988/0b0c3d8e-924b-42ee-b6d7-143f2948522b)
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

<img src="https://github.com/Poppin-Technologies/magnetic-scroll/assets/69051988/a6105c9b-ea59-42aa-9091-b6a5097ae47d" alt="regular" height=600 />

### ✨ Manually changing the blocks
<img src="https://github.com/Poppin-Technologies/magnetic-scroll/assets/69051988/01df66a2-9d39-48f5-9e02-c0a1ec9266af" alt="manual" height=600 />

### 🙌 Magnetic Scroll with `.matchedGeometryEffect` modifier
<img src="https://github.com/Poppin-Technologies/magnetic-scroll/assets/69051988/f694f466-e17e-472f-a955-c0d762584fba" alt="mached" height=600 />

### 🔥 MagneticCarousel
If you set the `velocityThreshold` to `.infinity`, MagneticScroll becomes a carousel.

<img src="https://github.com/Poppin-Technologies/magnetic-scroll/assets/69051988/feadbb7b-817d-48cd-9a27-469c46b6aacd" alt="carousel" height=600/ >

## Usage
MagneticScroll is designed to operate with a view called `Block`. For MagneticScroll to detect scroll changes, it requires your content to be wrapped within `Block` elements.
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
### ![logoppin](https://github.com/Poppin-Technologies/magnetic-scroll/assets/69051988/f7cb683f-131d-4fbd-ab32-0dc00d4f8e75)
### <img src="https://github.com/Poppin-Technologies/magnetic-scroll/assets/69051988/213fda7f-9f2b-4bca-b78c-ce839527d879" alt="poppin" height=600/ >

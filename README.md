![Magnetic Scroll](https://github.com/Poppin-Technologies/magnetic-scroll/assets/69051988/6586829c-e9a2-4e3f-bf58-73bbf3ad3a1c)

# MagneticScroll
A Library that adds a sticky behavior to the `SwiftUI`'s `ScrollView`, while triggering a smooth feedback as you scroll through the magnetic blocks.

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
### Regular Magnetic Scroll
As you scroll, when the `ScrollView`'s velocity is lesser than `MagneticScrollView`'s velocity, magnetic scroll automatically sticks to the predicted end location.

![regular](https://github.com/Poppin-Technologies/magnetic-scroll/assets/69051988/838e1403-f0b1-4289-a4f3-24925377fe15)

### Manually changing the blocks
![manual](https://github.com/Poppin-Technologies/magnetic-scroll/assets/69051988/1a83b124-3b1f-4108-a483-515d2e6b09f3)

### Magnetic Scroll with `.matchedGeometryEffect` modifier
![geometry](https://github.com/Poppin-Technologies/magnetic-scroll/assets/69051988/d0f629f1-04d4-4874-be00-41583129b093)

## Usage
```swift 
import SwiftUI
import MagneticScroll

struct ContentView: View {
  // If you were to set activeBlock to "second" or "first" manually, MagneticScroll would automatically scroll to the block with that id.
  @State private var activeBlock = "first"
  var body: some View {
    MagneticScrollView(activeBlock: $activeBlock) {
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

### Apps Using MagneticScroll

[Poppin](https://apps.apple.com/us/app/poppin-the-party-platform/id1573674111) - The Party Platform 

<a href="https://joinpoppin.com/">
  <img src="https://github.com/Poppin-Technologies/magnetic-scroll/assets/69051988/7c83a740-1d7e-42a7-b5ec-5fc737a231c0" height="300" alt="Poppin">
</a>

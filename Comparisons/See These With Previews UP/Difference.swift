//
// 💡 If "maskAdjustment" is calculated... then add the init and calculate it. If someone comes in here an needs to change the stroke width, they might not happen upon the comment.
// 💡 If the stroke width is only used once, put it in the call site, or if at the top for ease of adjustment, then why not have the shadow radius at the top too? Either way...
// 💡 Need to calculate the "maskAdustment" so might as well pull everything into an init, calculate the width and heights for the frames below too, then just have a single var at the call site with better names. instead of "content.contentHeight + frameAdjustment" just "adjustedWidth"
// 💡💡 OVERALL. None of this should be necessary with Swift UI, if you find yourself making calculations for masking, you might be doing it wrong. Hit up google and search for "RoundedRectangle Stroke Shadow SwiftUI" Somebody has probably done it already.
// 👇 See the bottom of this file for the refactored code that produces the same result, without hardcoded numbers, without a protocol, without any math, and without any vars. It does it also resizes based on content, see canvas previews ->

import SwiftUI

// 👇 This protocol is unecessary. If you really need access to the content width or height, use geometry reader. Most of the time that isn't even necessary.


public protocol PBLModalContent : View { // 34
    var contentWidth: CGFloat { get }
    var contentHeight: CGFloat { get }
}

struct PBLModalDialogOld<Content: PBLModalContent>: View {
    
    let content: Content
    
    let strokeWidth: CGFloat = 2.0
    let cornerRadius: CGFloat = 6.0
    let frameAdjustment: CGFloat = 60.0
    let maskAdjustment: CGFloat = 58.0  // frameAdjustment - strokeWidth
    
    var body: some View {
        ZStack(alignment: .center) {
            RoundedRectangle(cornerRadius: cornerRadius)
                .frame(width: content.contentWidth + frameAdjustment,
                       height: content.contentHeight + frameAdjustment)
                .foregroundColor(Color.white)
                .overlay(RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(Color.secondary, lineWidth: strokeWidth))
                .shadow(color: Color.secondary, radius: 3)
            
            // Clip out the shadow on the inside of the dialog.
            RoundedRectangle(cornerRadius: cornerRadius)
                .frame(width: content.contentWidth + maskAdjustment,
                       height: content.contentHeight + maskAdjustment)
                .foregroundColor(Color.white)
            content
        }
        .padding()
    }
}
// 👆👆👆👆 ORIGINAL ABOVE    ⬆⬆⬆
// 👇👇👇👇 REFACTORED BELOW  ⬇⬇⬇
struct PBLRefactoredModalDialog<Content: View>: View { //  16
    var content: Content
    var body: some View {
        content
            .padding(30)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.white)
                    .shadow(color: .primary, radius: 3)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.secondary, lineWidth: 2)
                    )
            )
            .padding()
    }
}
 
//PREVIEWS
struct PBLModalDialogOld_Previews: PreviewProvider {
    
    struct DemoContent: PBLModalContent {
        let contentWidth: CGFloat = 160
        let contentHeight: CGFloat = 20
        
        var body: some View {
            VStack{
                Text("This is a modal window.")
            }
        }
    }
    
    
    struct DemoContent2: PBLModalContent {
        let contentWidth: CGFloat = 160
        let contentHeight: CGFloat = 20
        
        var body: some View {
            VStack{
                Text("This is a modal window, with a different text.")
                Text("And some more new lines 1.")
                Text("And some more new lines 2.")
                Text("And some more new lines 3.")
                Text("And some more new lines 4.")
            }
        }
    }
    
    static var previews: some View {
        Group {
            PBLModalDialogOld(content: DemoContent())
                .previewDisplayName("🦠🦠🦠")
                .preferredColorScheme(.light)
                .previewLayout(.sizeThatFits)
            PBLModalDialogOld(content: DemoContent2())
                .previewDisplayName("🦠🦠🦠")
                .preferredColorScheme(.light)
                .previewLayout(.sizeThatFits)
        }
    }
}
struct PBLRefactoredModalDialog_Previews: PreviewProvider {
    static var previews: some View {
        
        Group {
            PBLRefactoredModalDialog(content:
                                        VStack{
                                            Text("This is a modal window.")
                                        }
            )
            .previewDisplayName("🌸🌸🌸")
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
            PBLRefactoredModalDialog(content:
                                        VStack{
                                            Text("This is a modal window, with a different text.")
                                            Text("And some more new lines 1.")
                                            Text("And some more new lines 2.")
                                            Text("And some more new lines 3.")
                                            Text("And some more new lines 4.")
                                        }
            )
            .previewDisplayName("🌸🌸🌸")
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
        }
    }
}

 
 
//

import SwiftUI

struct TextFieldWithLabel: View {
    
    let label: String
    let placeholder: String
    @Binding var userInput: String
    var color = Color.primary
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(label)
               
            TextField(placeholder, text: $userInput, onEditingChanged: { editingBegan in
                let editingEnded = !editingBegan
                
                if editingEnded {
                 
                    NSLog("**************************************")
                    NSLog("TextField edit ended")
                    NSLog("**************************************")
                }
            })
                
        }
    }
}

struct TextFieldWithLabel_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldWithLabel(label: "Mission Number", placeholder: "Mission Number", userInput: .constant("ABCDEFG"))
            .previewLayout(.sizeThatFits)
            .padding()
        TextFieldWithLabel(label: "Mission Number", placeholder: "Mission Number", userInput: .constant("ABCDEFG"))
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
            .padding()
    }
}


//
//  FontModifiers.swift
//  Logging
//
//  Created by Bethany Morris on 1/20/21.
//

import SwiftUI

struct PageHeadingModifier: ViewModifier {
    
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .font(.custom("DMSans-Bold", size: 40))
            .foregroundColor(color)
    }
}

struct SectionHeadingModifier: ViewModifier {
        
    func body(content: Content) -> some View {
        content
            .font(.custom("DMSans-Bold", size: 24))
            .foregroundColor(.pblSecondary)
    }
}

struct FormInputModifier: ViewModifier {
        
    func body(content: Content) -> some View {
        content
            .font(.custom("DMSans-Regular", size: 18))
            .foregroundColor(.pblSecondary)
            //.autocapitalization(.allCharacters)
    }
}

struct FormLabelModifier: ViewModifier {
        
    func body(content: Content) -> some View {
        content
            .font(.custom("DMSans-Bold", size: 12))
            .foregroundColor(.pblTertiary)
            //.autocapitalization(.allCharacters)
    }
}

struct FormMessageModifier: ViewModifier {
        
    func body(content: Content) -> some View {
        content
            .font(.custom("DMSans-Bold", size: 12))
            .foregroundColor(.pblSecondary)
    }
}

extension View {
    
    func fontPageHeading(color: Color = .pblPrimary) -> some View {
        self.modifier(PageHeadingModifier(color: color))
    }
    
    func fontSectionHeading() -> some View {
        self.modifier(SectionHeadingModifier())
    }
    
    func fontFormInput() -> some View {
        self.modifier(FormInputModifier())
    }
    
    func fontFormLabel() -> some View {
        self.modifier(FormLabelModifier())
    }
    
    func fontFormMessage() -> some View {
        self.modifier(FormMessageModifier())
    }
}

struct FontModifiers_Previews: PreviewProvider {
    static var previews: some View {
        
        Text("Hello World")
            .fontPageHeading()
            .padding()
            .previewLayout(.sizeThatFits)
            .previewDisplayName("H1 - Page Heading - Light")
        Text("Hello World")
            .fontPageHeading()
            .padding()
            .previewLayout(.sizeThatFits)
            .previewDisplayName("H1 - Page Heading - Dark")
            .preferredColorScheme(.dark)
        
        Text("Hello World")
            .fontSectionHeading()
            .padding()
            .previewLayout(.sizeThatFits)
            .previewDisplayName("H2 - Section Heading - Light")
        Text("Hello World")
            .fontSectionHeading()
            .padding()
            .previewLayout(.sizeThatFits)
            .previewDisplayName("H2 - Section Heading - Dark")
            .preferredColorScheme(.dark)
        
        Text("HELLO WORLD")
            .tracking(2)
            .fontFormInput()
            .padding()
            .previewLayout(.sizeThatFits)
            .previewDisplayName("H3 - Form Input - Light")
        Text("HELLO WORLD")
            .fontFormInput()
            .padding()
            .previewLayout(.sizeThatFits)
            .previewDisplayName("H3 - Form Input - Dark")
            .preferredColorScheme(.dark)
        
        Text("Hello World")
            .fontFormLabel()
            .padding()
            .previewLayout(.sizeThatFits)
            .previewDisplayName("H4 - Form Label - Light")
        Text("Hello World")
            .fontFormLabel()
            .padding()
            .previewLayout(.sizeThatFits)
            .previewDisplayName("H4 - Form Label - Dark")
            .preferredColorScheme(.dark)
        
        Text("Hello World")
            .fontFormMessage()
            .padding()
            .previewLayout(.sizeThatFits)
            .previewDisplayName("H5 - Form Message - Light")
        Text("Hello World")
            .fontFormMessage()
            .padding()
            .previewLayout(.sizeThatFits)
            .previewDisplayName("H5 - Form Message - Dark")
            .preferredColorScheme(.dark)
    }
}
//
//  Color+PBLStyle.swift
//  PBLogging
//
 

import SwiftUI

extension Color {
    
    // Foreground colors
    public static let pblPrimary    = Color("primary")
    public static let pblSecondary  = Color("secondary")
    public static let pblTertiary   = Color("tertiary")

    public static let pblSlate      = Color("slate")
    public static let pblSlateBG    = Color("slateBG")
    public static let pblFog        = Color("fog")
    public static let pblFogBG      = Color("fogBG")
    public static let pblHaze       = Color("haze")
    public static let pblMistBG     = Color("mist")
    public static let pblNotBlack   = Color("notBlack")
    public static let pblGray       = Color("PBLGray")
    public static let pblBackground = Color("background")
    public static let pblDefault    = Color("default")
    public static let pblElevated   = Color("elevated")
    
    public static let pblErrorFG    = Color("error_fg")
}

extension UIColor {
    
    public static let pblSecondaryUIColor  = UIColor(named: "secondary")
    public static let pblElevatedUIColor = UIColor(named: "elevated")
}
/// See: https://www.swiftbysundell.com/articles/getting-the-most-out-of-xcode-previews/
/// Allows to use .mock(value) in previews instead of .constant
/// Mocked values can be changed in the live prevew
extension Binding {
    static func mock(_ value: Value) -> Self {
        var value = value
        return Binding(get: { value }, set: { value = $0 })
    }
}

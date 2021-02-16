
//  EventDialogContent.swift
//  Logging
//
//  Created by Pete Hoch on 2/10/21.
//

import SwiftUI

struct EventDialogContentOld: PBLModalContent { //50
    // 💡No need to write a protocol to contain values that are already present. The use case for protocols is not this. If it was really necessary to pass, the values could be passed in an intializer. The sole purpose of the PBLModalContent protocol is to pass size. A better name might be  "SizeExposing" or "Measurable".  "PBLModalContent" doesn't describe the protocol or what it does. It's not modal and it's not content.
    
    // Let's take a look at a nicely named protocol from the STL "Comparable"
    
    struct AnExamplePerson: Comparable {
        
        static func < (lhs: EventDialogContentOld.AnExamplePerson, rhs: EventDialogContentOld.AnExamplePerson) -> Bool {
            guard lhs.lastName == rhs.lastName else { return lhs.lastName < rhs.lastName}
            return lhs.firstName <= rhs.firstName
        }
        
        var firstName = "Bob"
        var lastName = "Smith"
    }
    
    //Regardless of the above, the protocol is unecessary. SwiftUI views already have a readable size. Hard coding it is strange.
    
    let contentWidth: CGFloat = 280     // 💡To conform to the unecessary protocol REMOVE
    let contentHeight: CGFloat = 150    // 💡To conform to the unecessary protocol REMOVE
     
    @Binding var eventName: String  // 💡Needed for testing. Acceptable, needs a comment to let us know it will be replaced when Core Data implementation is in.
    @Binding var eventDate: Date    // Same
    
    var completion: (_ button: String) -> Void // 💡REMOVE
    // 💡 Poor variable name. A button is a button. This is a string. What does it represent? It represents whether the user clicked Ok or Cancel. More concisely it represents whether the user wants to save the record or not. This shouldn't be a string at all. The desired effects have an enumerated usage. If this is only two values It should be a bool with a good name like "shouldSave." The call site for this is going to have no context. This should be named better. In a future case like this with more than two values then an enum with proper names should be used. (E.g. ".cancelPressed, .okPressed, .helpPressed") NEVER a string.
    
    //  🧑‍🏫 Why don't we use strings in these cases? Cause they are easy to mess up. If I put "cancel" here and "Cancel" when checking at the call site, I get unexpected behavior, but the code "looks" correct and doesn't throw any errors. If I use a bool named "isCancelled" instead, then Xcode is going to yell at me if i type "iscancelled" instead of the correct name or if I type True instead of true.
    
    /*
        1️⃣ Scenario 1 1️⃣
        var isOvenOn = "On"
        if isOvenOn == "ON" {
            turnOffOven()
        }
        Result: 🔥🏠🔥🔥 🚒
        
     
        2️⃣ Scenario 2 2️⃣
        var isOvenOn = true
        if isOvenOn {
            turnOvenOff()
        }
        Result: 🏠
        */
    
    // 🧐 Compare these two calls:
    // completionShouldSave(true)
    //
    // completion("Cancel")

    //better:
    //var completionShouldSave: (_ shouldSave: Bool) -> Void
    
    // 💡 Like the protocol, this completion handler is also unecessary. The Persistance object is a singleton that can be called from anywhere... such as here. This doesn't need a completion handler. Just a "isDisplayed" binded var perhaps.

    var body: some View {
        VStack {
            
            Text("DEVELOPMENT ONLY") //remove
            // 🤮 We are 0.2.0, everything is "development only" labeling it shouldn't allow for bad code.
            Spacer() // remove
            HStack {
                TextFieldWithLabel(label: "Event Title", placeholder: "Mission #", userInput: $eventName)
                Spacer()
                VStack(alignment: .leading, spacing: 0) {
                   
                    Text("Date")
                        .fontFormLabel()

                    DatePicker("", selection: .constant(Date()), displayedComponents: [.date])
                        .accentColor(.pblPrimary)
                        .environment(\.locale, .init(identifier: "en_GB"))
                        .frame(width:100)
                }
            }
            Spacer()
            HStack {
                Spacer()
                Button("Cancel") {
                    withAnimation() { // Remove
                        //  💡 The animation is not happening here. would probably be better to put in the view where the animation is happening so future coders can understand why it is happening. Further, it adds code clutter to this file, as it must be called twice. Once from this button and once from  the next. 
                        completion("Cancel") // REPLACE (See top documention)
                    }
                }
                .padding(.trailing)
                Button("OK") {
                    withAnimation() { // Remove
                        // see previous comment on other button concerning animation.
                        completion("OK") // REPLACE (See top documention)
                    }
                }
                .padding(.leading) // 💡combined with the .trailing padding above is somewhat odd. Perhaps one padding call with the distance required?
                .accessibility(identifier: "editEventButton") // 🤔 This is an "OK" button. It does no editing. The other button doesn't have an accessibility name. It seems this was left in to pass a test. Are we passing the test? Yes. Are we providing any value by passing the test? No. We shouldn't be doing any UI Tests while actively updating the UI and not even having unit tests complete. The order should be 1. Unit Tests 2. Integration Tests 3. UI Tests. As we aren't doing TDD, our code base should be pretty well developed prior to writing any tests for things that haven't been locked down yet. We are just making extra work for ourselves until then.

            }
        }
        .frame(width: contentWidth, height: contentHeight)
    }
}

//OLD ABOVE ^^^
//REFACTORED BELOW VVV

/// This is the above but with the changes. I still wouldn't write it this way. The persistence controller is a singleton that can be called from anywhere. The callbacks are unecessary and the "Modal" this content is sent too is bad architecture as well. 

struct EventDialogContent: View { //40
    
    @Binding var eventName: String
    @Binding var eventDate: Date
    
    var completionShouldSave: (_ shouldSave: Bool) -> Void
    
    var body: some View {
        VStack {
 
            HStack {
                TextFieldWithLabel(label: "Event Title", placeholder: "Mission #", userInput: $eventName)
                Spacer()
                VStack(alignment: .leading) {
                    Text("Date")
                        .fontFormLabel()

                    DatePicker("", selection: $eventDate, displayedComponents: [.date])
                        .accentColor(.pblPrimary)
                        .environment(\.locale, .init(identifier: "en_GB"))
                        .frame(width:100)
                }
            }
            Spacer()
            HStack {
                Spacer()
                Button("Cancel") {
                    completionShouldSave(false)
                }
                .padding(.trailing, 26)
                .accessibility(identifier: "cancelButton")
                Button("OK") {
                    completionShouldSave(true)
                }
                .accessibility(identifier: "okButton")

            }
        }
        .frame(width: 280, height: 150)
    }
}

//Previews
struct EventDialogContentOld_Previews: PreviewProvider {
  
    @State static private var eventIndex: Int = -1
    @State static private var eventName: String = "Mission #"
    @State static private var eventDate: Date = Date()

    static var previews: some View {
        EventDialogContentOld(eventName: $eventName, eventDate: $eventDate) {_ in}
            .previewDisplayName("🔥🏠🔥🔥 🚒")
            .previewLayout(.sizeThatFits)
    }
}
struct EventDialogContent_Previews: PreviewProvider {
 
    @State static private var eventIndex: Int = -1
    @State static private var eventName: String = "Mission #"
    @State static private var eventDate: Date = Date()

    static var previews: some View {
        EventDialogContent(eventName: $eventName, eventDate: $eventDate) {_ in}
            .previewDisplayName("😴")
            .previewLayout(.sizeThatFits)
    }
}

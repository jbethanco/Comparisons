//
//  DoubleWTF.swift
//  Comparisons
//
//

import SwiftUI

struct CallSiteOnly: View {
    @State var dialogIsDisplayed = false
    @State var eventName: String = ""
    @State var eventDate: Date = Date()
    @State var disableButtons = false
    @State var isAddingNewEvent = true   //🤖 added
    
    var body: some View {
     
        VStack{
            HStack{
                Spacer()
                Button{
                  dialogIsDisplayed = true
                } label: {
                    Text("+")
                }
            }
            Text("The rest of the form")
            
                // 💡 This call site is confusing, poorly named, and unecessarily so.
                // There is no need for a callback because Persistence could be called inside the content where the data is being manipulated. There is no reason to do the saving here. See other files about the usage of String "OK" instead of a normal boolean or enum.
                // "button" is a bad var name. In this case it should be "buttonPressed" or in this case "textOfButtonPressed"
                // 🤮 "disableButtons" and "dialogIsDisplayed" This is blatantly bad design.  They are always set the same set in tandem. We only need one. The original was dialogIsDisplayed. There was no reason to add a new one. Even the name is bad.
                    //
                    // SomeButton.disabled(disableButtons) <- doesn't have a why
                    // - does not read as well as:
                    // SomeButton.disabled(dialogIsDisplayed) <- The why is provided
                    //
                // 🤮  using a var to disable buttons and controls and various places around the app is really bizzare and adds so much code clutter. If your modal isn't modal, you are doing it wrong. The modal itself should handle blocking all user interaction behind it. Instead we have disableButtons appearing FIFTEEN Times in the code base now.
                
                // I added the "Old" suffixes below so this file could still work.
                // The names are bad even without that.
                // PBLModalDialog is not modal, and is not a dialog.
                // EventDialogContent is not a dialog. Event is in the name, so shouldn't be needed in the variable names in the init message. E.g.
                // EventDialogContent(eventName: $eventName, eventDate: $eventDate) { button in }
                // looks better as:
                // NewEventForm(event: $eventName, date: $eventDate) { buttonPressed in }
                // or perhaps:
                // AddEventForm(for: $eventName, on: $eventDate) { buttonPressed in }
                // This is suggestion on how to make this look better, not an endorsement of their use
                // The current way looks odd next to the Persistence controller method that calls it in another way.
                // PersistenceController.newEvent(name: eventName, date: eventDate)
                // if the weird disableButtons is used, perhaps "disableButtonsForModal
            
            if dialogIsDisplayed {
                
                PBLModalDialogOld(content: EventDialogContentOld(eventName: $eventName,
                                                           eventDate: $eventDate) { button in
                    dialogIsDisplayed = false
                    disableButtons = false
                    if button == "OK" {
                        PersistenceController.newEvent(name: eventName, date: eventDate)
                    }
                })
                 
            }
            
            //  The above is just a terrible call site. When you first see it, you have no idea what is happening. You have to visit two other files to figure it out.
            
            //  The call site could / should look something similar too:
            
            if isAddingNewEvent {
                ModalAddEventForm(name: $eventName, date: $eventDate, isShowing: $isAddingNewEvent)
            }
            
            // or better
/*
            .modal(isShowing: $isAddingNewEvent){
                AddEventForm()
            }
 */
            
        }
        
    }
}
struct ModalAddEventForm: View {
    @Binding var name: String
    @Binding var date: Date
    @Binding var isShowing: Bool
    var body: some View {
        Button("Save"){
            PersistenceController.newEvent(name: name, date: date)
            PersistenceController.saveContext()
            withAnimation{
                isShowing = false
            }
        }
        // Cancel button ,etc
    }
     
}
var isAddingNewEvent = true
struct CallSiteOnly_Previews: PreviewProvider {
    static var previews: some View {
        CallSiteOnly()
    }
}

struct PersistenceController{
    static func newEvent(name: String, date: Date){
        print(name + " " + date.description)
    }
    static func saveContext(){
        print("saving")
    }
}

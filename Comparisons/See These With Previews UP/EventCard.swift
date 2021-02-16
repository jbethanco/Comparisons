//
//  EventCard.swift
//  Logging
//
//  Created by Pete Hoch on 2/10/21.
//

import Combine
class  Form781: ObservableObject{
    @Published var harmLocation = "Hello"
    @Published var date = Date()
}


import SwiftUI
struct EventCard: View {

    @ObservedObject var form: Form781
    @Binding var disableButtons: Bool // ⚠️ If the modal was modal, this is unecessary
    @State private var pushToSortie: Int? = 0 // 🤔 An uneeded private optional. Why is it optional, if it's never nil?

    var body: some View {
        ZStack {
            Button(action: {
                if !disableButtons { // ⚠️ Button, has a disabled view modifier. Button.disabled(disableButtons)
                                    // this would avoid the double negative as well
                    pushToSortie = 1 // ⚠️ This is hacky.
                                    
                }
            }) {
                HStack {
                    Spacer()
                    Image(systemName: "chevron.right")
                        .padding()
                    // ⚠️ This is hacky. Can we do better?
                    NavigationLink(
                        destination: Text("Some Form"),
                        tag: 1,
                        selection: $pushToSortie,
                        label: {
                            // Note: The NavigationLink does not have a view because
                            // we are using pushToSortie to trigger the navigation
                            // view push. So the button (the whole card) is what is
                            // triggering the view push.
                            EmptyView()
                    })
                }
                .padding()
                .background(Color.pblDefault)
                .foregroundColor(Color.pblSecondary)
                .cornerRadius(10)
            }
           
            // Set the label on top of the button. This is so the tap on the
            // label will not activate the card button.
            HStack {
                // The EventLabel view will push to a sheet to edit the event data.
                EventLabel(form: form, disableButtons: $disableButtons)
                Spacer()
            }
        }
    }

    
    struct EventLabel: View { // 🤔 Maybe this was a label before, but it is not just a label anymore. This needs to be decomposed and renamed. Labels typically don't have functions or buttons, or display dialogs to add records to a database.

        @ObservedObject var form: Form781
        @Binding var disableButtons: Bool // ⚠️ This is hacky. We can do better

        @State private var eventName: String = ""
        @State private var eventDate: Date = Date()
        @State private var dialogIsDisplayed: Bool = false

        var body: some View {
            ZStack {
                VStack {
                    Button {
                        _displayEditEvent() // 🤔 Underscore... This is not standard for swift. Apple did this with their private funcs for Objective C and instructed the public not to use it.
                    } label: {
                        VStack(alignment: .leading) {
                            Text(form.harmLocation)
                            HStack {
                                Image(systemName: "calendar")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 16)

                                Text("Some date")
                            }
                        }
                    }
                    .padding(.leading)
                    .padding(.trailing)
                }
                .foregroundColor(Color.pblSecondary)
                // ⚠️ See Call Site Only file concerning this.
                if dialogIsDisplayed {
                    Spacer()
                    PBLModalDialogOld(content: EventDialogContentOld(eventName: $eventName,
                                                               eventDate: $eventDate) { button in
                        dialogIsDisplayed = false // ⚠️ Tandem bools is silly
                        disableButtons = false
                        if button == "OK" {
                            form.harmLocation = eventName
                            form.date = eventDate
                            PersistenceController.saveContext()
                        }
                    })
                }
            }
        }

        private func _displayEditEvent() {
            if disableButtons { // 🤔 The button can be disabled as opposed to this.
                return
            }
            eventName = form.harmLocation
            eventDate = form.date
            disableButtons = true
            withAnimation() {
                dialogIsDisplayed = true
            }
        }
    }
}

struct EventCard_Previews: PreviewProvider {
    static let form = Form781()
    @State static var displayed = false

    static var previews: some View {
        EventCard(form:form, disableButtons: $displayed)
    }
}

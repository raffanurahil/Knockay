import SwiftUI

struct FullScreenCoverView<Content: View>: View {
    @Binding var isPresented: Bool
    let content: Content
    let dismissible: Bool
    
    init(isPresented: Binding<Bool>, dismissible: Bool = true, @ViewBuilder content: () -> Content) {
        self._isPresented = isPresented
        self.content = content()
        self.dismissible = dismissible
    }
    
    var body: some View {
        ZStack {
            if isPresented {
                content
            }
        }
        .allowsHitTesting(isPresented && dismissible)
    }
}

import SwiftUI

struct AddProductView: View {
    private let viewModel: AddProductView.ViewModel
    private var isPresented: Binding<Bool>
    @State private var showCancelActionSheet = false
    @State private var isProductValid = false

    init(viewModel: AddProductView.ViewModel, isPresented: Binding<Bool>) {
        self.viewModel = viewModel
        self.isPresented = isPresented
    }

    private func setup() {
        viewModel.product.onUpdate = { isProductValid = $0.isValid }
    }

    var body: some View {
        setup()
        return NavigationView {
            ProductDetails(viewModel: ProductDetails.ViewModel(product: viewModel.product))
                .navigationTitle(LocalizedStringKey("Product.Add"))
                .navigationBarItems(leading: Button(LocalizedStringKey("Cancel")) { showCancelActionSheet = true },
                                    trailing: Button(LocalizedStringKey("Add")) {
                                        isPresented.wrappedValue = false
                                        viewModel.isProductAddingCancelled = false
                }
                .disabled(!isProductValid))
                .actionSheet(isPresented: $showCancelActionSheet) {
                    ActionSheet(title: Text(LocalizedStringKey("Alert.CancelAdding.Title")),
                                message: Text(LocalizedStringKey("Alert.CancelAdding.Description")),
                                buttons: [
                                    .default(Text(LocalizedStringKey("Alert.CancelAdding.Button.KeepEditing"))),
                                    .default(Text(LocalizedStringKey("Alert.CancelAdding.Button.CancelAdding"))) {
                                        isPresented.wrappedValue = false
                                        viewModel.isProductAddingCancelled = true
                                    },
                                    .cancel()
                                ]
                    )
                }
                .onDisappear() {
                    viewModel.onViewDissapear()
                }
        }
    }
}

struct AddProductView_Previews: PreviewProvider {

    static var previews: some View {
        AddProductView(viewModel: AddProductView.ViewModel(product: Product()),
                       isPresented: Binding(get: { true }, set: { _ in }))
    }
}

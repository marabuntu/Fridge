import SwiftUI
import Combine

struct ProductsListView: View {
    @ObservedObject private var viewModel: ViewModel
    @State private var showingActionSheet = false
    @State private var showingAddNewProductView = false
    @State private var showingBarcodeScannerView = false
    private var cameraViewModel: CameraViewModel
    private let fetchedBarcode = NSMutableString(string: "")

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        cameraViewModel = CameraViewModel()
    }

    var body: some View {
        NavigationView {
            List {
                listSection(isForExpiredProducts: false)
                listSection(isForExpiredProducts: true)
                Section() { }
            }
            .navigationBarTitle(LocalizedStringKey("ProductList.Title"))
            .toolbar {
                Button(action: { showingActionSheet = true }) { Image(systemName: "plus") }
                    .sheet(isPresented: $showingAddNewProductView) {
                        AddProductView(viewModel: AddProductView.ViewModel(product: newProduct()),
                                       isPresented: $showingAddNewProductView)
                    }
            }
            .onAppear() {
                UITableView.appearance().backgroundColor = UIColor(Color.tableBackground)
            }
            .actionSheet(isPresented: $showingActionSheet) {
                ActionSheet(title: Text(LocalizedStringKey("Alert.AddNewProduct.Title")),
                            message: Text(LocalizedStringKey("Alert.AddNewProduct.Description")),
                            buttons: [
                    .default(Text(LocalizedStringKey("Alert.AddNewProduct.Button.ScanBarcode"))) { showingBarcodeScannerView = true },
                    .default(Text(LocalizedStringKey("Alert.AddNewProduct.Button.AddManually"))) { showingAddNewProductView = true },
                    .cancel()
                ])
            }
        }
        .onReceive(cameraViewModel.barcodeScanned) {
            showingBarcodeScannerView = false
            fetchedBarcode.setString($0)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Constants.delayAddNewProductView) {
                self.showingAddNewProductView = true
            }
        }
        .sheet(isPresented: $showingBarcodeScannerView) {
            BarcodeScanner(viewModel: cameraViewModel)
        }
    }
}

// MARK: - Helpers

extension ProductsListView {

    private func listSection(isForExpiredProducts: Bool) -> some View {
        Section(header: headerView(with: isForExpiredProducts ? Constants.expiredProductsTitle : Constants.notExpiredProductsTitle),
                footer: footerView(with: isForExpiredProducts ? Constants.expiredProductsDescription : Constants.notExpiredProductsDescription)) {
            ForEach(viewModel.products) {
                if isForExpiredProducts ? $0.isExpired : !$0.isExpired {
                    ProductsListViewItem(viewModel: ProductsListViewItem.ViewModel(product: $0))
                }
            }
            .onDelete {
                $0.forEach {
                    viewModel.removeProduct(viewModel.products[$0])
                    viewModel.storeProducts()
                }
            }
        }
    }

    private func newProduct() -> Product {
        let code = fetchedBarcode as String
        let productWithCode = viewModel.product(code: code)
        let newProduct = viewModel.createProduct()
        newProduct.name = productWithCode?.name ?? ""
        newProduct.barcode = productWithCode?.barcode ?? code
        newProduct.expirationDate = Date().addingTimeInterval(Constants.defaultProductExpirationInterval)
        fetchedBarcode.setString("")
        return newProduct
    }

    private func headerView(with text: String) -> some View {
        Text(text)
            .font(.subheadline)
            .padding()
            .frame(width: UIScreen.main.bounds.width, height: Constants.headerViewHeight, alignment: .leading)
            .background(Color.tableBackground)
    }

    private func footerView(with text: String) -> some View {
        Text(text)
            .font(.footnote)
            .multilineTextAlignment(.leading)
            .padding(.bottom, Constants.footerViewBottomPadding)
            .listRowBackground(Color.tableBackground)
    }
}

// MARK: - Constants

extension ProductsListView {

    struct Constants {
        static let expiredProductsDescription = LocalizedStringKey("ProductList.Expired.Description").asString
        static let notExpiredProductsDescription = LocalizedStringKey("ProductList.NotExpired.Description").asString
        static let expiredProductsTitle = LocalizedStringKey("ProductList.Expired").asString
        static let notExpiredProductsTitle = LocalizedStringKey("ProductList.NotExpired").asString
        static let headerViewHeight: CGFloat = 28
        static let footerViewBottomPadding: CGFloat = 20
        static let delayAddNewProductView: Double = 0.5
        static let defaultProductExpirationInterval: Double = 24 * 60 * 60
    }
}

// MARK: - Previews

struct ProductsListView_Previews: PreviewProvider {

    static var previews: some View {
        ProductsListView(viewModel: ProductsListView.ViewModel())
    }
}

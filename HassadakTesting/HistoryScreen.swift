//import SwiftUI
//
//
//
//// MARK: - 1) HistoryView (and everything in it)
//
//struct PersistentGreenBorderStyle: ButtonStyle {
//    var isSelected: Bool
//
//    func makeBody(configuration: Configuration) -> some View {
//        configuration.label
//            .padding()
//            .background(
//                RoundedRectangle(cornerRadius: 12)
//                    .fill(Color(UIColor.systemBackground))
//            )
//            .overlay(
//                RoundedRectangle(cornerRadius: 16)
//                    .stroke(isSelected ? Color("green") : Color.gray.opacity(0.2), lineWidth: 2)
//            )
//    }
//}
//
//struct HistoryView: View {
//    @State private var showPopup = false
//    @State private var selectedItemName = ""
//    @State private var selectedItemQTY = 0
//    @State private var userName = "Younes123"
//    @State private var showShareSheet = false
//    @State private var pdfURL: URL?
//    @State private var isBannerSelected = false
//    
//    
//    
//    private let currentDate = Date()
//
//    var body: some View {
//        GeometryReader { geometry in
//            ZStack {
//                VStack(alignment: .leading, spacing: 16) {
//                    Text("History")
//                        .font(.largeTitle)
//                        .fontWeight(.bold)
//                        .foregroundColor(Color("Green"))
//
//                    Text(Formatter.date.string(from: currentDate))
//                        .font(.subheadline)
//                        .foregroundColor(.gray)
//
//                    VStack(alignment: .leading, spacing: 16) {
//                        Button {
//                            selectedItemName = "Tomato"
//                            selectedItemQTY = 60
//                            isBannerSelected = true
//                            showPopup = true
//                        } label: {
//                            HStack(spacing: 16) {
//                                Image("bannerimage")
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fit)
//                                    .frame(width: min(geometry.size.width * 0.15, 56), height: min(geometry.size.width * 0.15, 56))
//
//                                Text("Today's Tomato")
//                                    .font(.system(size: 18, weight: .bold))
//                                    .foregroundColor(.primary)
//                                    .lineLimit(1)
//
//                                Spacer()
//
//                                Text("60 pieces")
//                                    .font(.headline)
//                                    .foregroundColor(Color("Green"))
//                                    .lineLimit(1)
//                            }
//                            .padding(.vertical, 0)
//                            .padding(.horizontal, 0)
//                            .frame(maxWidth: .infinity)
//                        }
//                        .buttonStyle(PersistentGreenBorderStyle(isSelected: isBannerSelected))
//
//                        Spacer()
//                    }
//
//                    Spacer()
//                }
//                .padding(geometry.size.width * 0.05)
//                .onChange(of: showPopup) { newValue in
//                    if !newValue {
//                        isBannerSelected = false
//                    }
//                }
//
//                if showPopup {
//                    Color.black.opacity(0.4)
//                        .edgesIgnoringSafeArea(.all)
//                        .onTapGesture {
//                            showPopup = false
//                        }
//
//                    VStack(spacing: 16) {
//                        CutoutReportCard(
//                            userName: userName,
//                            itemName: selectedItemName,
//                            itemQTY: selectedItemQTY,
//                            date: currentDate,
//                            showShape: true,
//                            geometry: geometry
//                        )
//
//                        Button("Share") {
//                            shareReportAsPDF(geometry: geometry)
//                        }
//                        .font(.headline)
//                        .foregroundColor(.white)
//                        .frame(height: 56)
//                        .frame(maxWidth: geometry.size.width * 0.8)
//                        .background(Color("Green"))
//                        .cornerRadius(12)
//                    }
//                    .padding(geometry.size.width * 0.05)
//                }
//            }
//        }
//        .sheet(isPresented: $showShareSheet) {
//            if let pdfURL = pdfURL {
//                ActivityViewController(activityItems: [pdfURL])
//            } else {
//                Text("No PDF available.")
//            }
//        }
//    }
//
//    private func shareReportAsPDF(geometry: GeometryProxy) {
//        let cardView = CutoutReportCard(
//            userName: userName,
//            itemName: selectedItemName,
//            itemQTY: selectedItemQTY,
//            date: currentDate,
//            showShape: false,
//            geometry: geometry
//        )
//
//        let pdfData = renderViewAsPDF(cardView, size: CGSize(width: geometry.size.width * 0.8, height: geometry.size.height * 0.6))
//        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("Report.pdf")
//
//        do {
//            try pdfData.write(to: tempURL)
//            pdfURL = tempURL
//            showShareSheet = true
//        } catch {
//            print("Error writing PDF data: \(error)")
//        }
//    }
//
//    private func renderViewAsPDF<Content: View>(_ view: Content, size: CGSize) -> Data {
//        let controller = UIHostingController(rootView: view)
//        controller.view.frame = CGRect(origin: .zero, size: size)
//        controller.view.layoutIfNeeded()
//        controller.view.backgroundColor = .white
//        controller.overrideUserInterfaceStyle = .light
//
//        let pdfRenderer = UIGraphicsPDFRenderer(bounds: controller.view.bounds)
//        return pdfRenderer.pdfData { context in
//            context.beginPage()
//            controller.view.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
//        }
//    }
//}
//
//// MARK: - 2) Report Card
//
//struct CircleCutoutShape: Shape {
//    var cornerRadius: CGFloat = 20
//    var holeRadius: CGFloat = 20
//
//    func path(in rect: CGRect) -> Path {
//        var path = Path()
//        let w = rect.width
//        let h = rect.height
//        let midX = rect.midX
//
//        path.move(to: CGPoint(x: 0, y: cornerRadius))
//        path.addArc(
//            center: CGPoint(x: cornerRadius, y: cornerRadius),
//            radius: cornerRadius,
//            startAngle: .degrees(180),
//            endAngle: .degrees(270),
//            clockwise: false
//        )
//        path.addLine(to: CGPoint(x: midX - holeRadius, y: 0))
//        path.addArc(
//            center: CGPoint(x: midX, y: 0),
//            radius: holeRadius,
//            startAngle: .degrees(180),
//            endAngle: .degrees(0),
//            clockwise: true
//        )
//        path.addLine(to: CGPoint(x: w - cornerRadius, y: 0))
//        path.addArc(
//            center: CGPoint(x: w - cornerRadius, y: cornerRadius),
//            radius: cornerRadius,
//            startAngle: .degrees(270),
//            endAngle: .degrees(360),
//            clockwise: false
//        )
//        path.addLine(to: CGPoint(x: w, y: h - cornerRadius))
//        path.addArc(
//            center: CGPoint(x: w - cornerRadius, y: h - cornerRadius),
//            radius: cornerRadius,
//            startAngle: .degrees(0),
//            endAngle: .degrees(90),
//            clockwise: false
//        )
//        path.addLine(to: CGPoint(x: cornerRadius, y: h))
//        path.addArc(
//            center: CGPoint(x: cornerRadius, y: h - cornerRadius),
//            radius: cornerRadius,
//            startAngle: .degrees(90),
//            endAngle: .degrees(180),
//            clockwise: false
//        )
//        path.addLine(to: CGPoint(x: 0, y: cornerRadius))
//        return path
//    }
//}
//
//struct CutoutReportCard: View {
//    var userName: String
//    var itemName: String
//    var itemQTY: Int
//    var date: Date
//    var showShape: Bool = true
//    var geometry: GeometryProxy
//
//    private let dateFormatter: DateFormatter = {
//        let df = DateFormatter()
//        df.dateFormat = "dd/MM/yyyy"
//        return df
//    }()
//
//    var body: some View {
//        ZStack {
//            if showShape {
//                CircleCutoutShape()
//                    .fill(style: FillStyle(eoFill: true))
//                    .foregroundColor(Color(UIColor.systemBackground))
//                    .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.6)
//                    .shadow(color: Color.primary.opacity(0.3), radius: 8, x: 0, y: 2)
//            } else {
//                Rectangle()
//                    .fill(Color.white)
//                    .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.6)
//            }
//
//            VStack(alignment: .leading, spacing: 20) {
//                Text("Report")
//                    .font(.largeTitle)
//                    .fontWeight(.bold)
//                    .foregroundColor(.primary)
//
//                VStack(alignment: .leading, spacing: 8) {
//                    HStack {
//                        Text("From:")
//                            .fontWeight(.semibold)
//                        Text(userName)
//                    }
//                    HStack {
//                        Text("Date:")
//                            .fontWeight(.semibold)
//                        Text(dateFormatter.string(from: date))
//                    }
//                }
//                .foregroundColor(.primary)
//
//                VStack(spacing: 0) {
//                    HStack {
//                        Text("Items name")
//                            .bold()
//                        Spacer()
//                        Text("QTY")
//                            .bold()
//                    }
//                    .padding(.horizontal)
//                    .padding(.top, 8)
//
//                    Divider()
//
//                    HStack {
//                        Text(itemName)
//                        Spacer()
//                        Text("\(itemQTY)")
//                    }
//                    .padding(.horizontal)
//                    .padding(.bottom, 8)
//                }
//                .foregroundColor(.primary)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 12)
//                        .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
//                )
//
//                Spacer()
//            }
//            .padding(.top, geometry.size.height * 0.06)
//            .padding(.horizontal, geometry.size.width * 0.05)
//            .padding(.bottom, geometry.size.height * 0.02)
//            
//            VStack {
//                Spacer()
//                HStack {
//                    Spacer()
//                    Image("logo")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: min(geometry.size.width * 0.1, 40), height: min(geometry.size.width * 0.1, 40))
//                        .padding([.trailing, .bottom], geometry.size.width * 0.05)
//                        .padding([.leading, .bottom], geometry.size.width * 0.05)
//                }
//            }
//        }
//        .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.6)
//    }
//}
//
//// MARK: - 3) Sharing Part
//
//struct Formatter {
//    static let date: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "dd/MM/yyyy"
//        return formatter
//    }()
//}
//
//struct ActivityViewController: UIViewControllerRepresentable {
//    let activityItems: [Any]
//    let applicationActivities: [UIActivity]? = nil
//
//    func makeUIViewController(context: Context) -> UIActivityViewController {
//        UIActivityViewController(activityItems: activityItems,
//                                 applicationActivities: applicationActivities)
//    }
//
//    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
//}
//
//// MARK: - Preview
//
//struct HistoryView_Previews: PreviewProvider {
//    static var previews: some View {
//        HistoryView()
//    }
//}
//import SwiftUI
//
//struct HistoryView: View {
//    @State private var showPopup = false
//    @State private var pdfURL: URL?
//    var selectedItemName: String
//    var selectedItemQTY: Int
//    var captureDate: String
//
//    var body: some View {
//        GeometryReader { geometry in
//            ZStack {
//                VStack(alignment: .leading, spacing: 16) {
//                    Text("History")
//                        .font(.largeTitle)
//                        .fontWeight(.bold)
//                        .foregroundColor(Color("Green"))
//
//                    // ✅ Displays the capture date
//                    Text(captureDate)
//                        .font(.subheadline)
//                        .foregroundColor(.gray)
//
//                    VStack(alignment: .leading, spacing: 16) {
//                        Button {
//                            showPopup = true
//                        } label: {
//                            HStack(spacing: 16) {
//                                Image("bannerimage")
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fit)
//                                    .frame(width: min(geometry.size.width * 0.15, 56), height: min(geometry.size.width * 0.15, 56))
//
//                                VStack(alignment: .leading) {
//                                    Text(selectedItemName.isEmpty ? "" : selectedItemName)
//                                        .font(.system(size: 18, weight: .bold))
//                                        .foregroundColor(.primary)
//                                        .lineLimit(1)
//
////                                    Text("Captured on: \(captureDate)")
////                                        .font(.subheadline)
////                                        .foregroundColor(.gray)
//                                }
//
//                                Spacer()
//
//                                Text("\(selectedItemQTY) pieces")
//                                    .font(.headline)
//                                    .foregroundColor(Color("Green"))
//                                    .lineLimit(1)
//                            }
//                            .padding(.vertical, 0)
//                            .padding(.horizontal, 0)
//                            .frame(maxWidth: .infinity)
//                        }
//
//                        Spacer()
//                    }
//
//                    Spacer()
//                }
//                .padding(geometry.size.width * 0.05)
//
//                if showPopup {
//                    Color.black.opacity(0.4)
//                        .edgesIgnoringSafeArea(.all)
//                        .onTapGesture {
//                            showPopup = false
//                        }
//
//                    VStack(spacing: 16) {
//                        // ✅ Passing Data to CutoutReportCard
//                        CutoutReportCard(
//                            itemName: selectedItemName,
//                            itemQTY: selectedItemQTY,
//                            date: captureDate,
//                            showShape: true,
//                            geometry: geometry
//                        )
//
//                        if let pdfURL = pdfURL {
//                            ShareLink(item: pdfURL, preview: SharePreview("Report", image: Image(systemName: "doc"))) {
//                                HStack {
//                                    Image(systemName: "square.and.arrow.up")
//                                    Text("Share Report")
//                                }
//                                .font(.headline)
//                                .foregroundColor(.white)
//                                .frame(height: 56)
//                                .frame(maxWidth: geometry.size.width * 0.8)
//                                .background(Color("Green"))
//                                .cornerRadius(12)
//                            }
//                        } else {
//                            Button("Generate Report") {
//                                shareReportAsPDF(geometry: geometry)
//                            }
//                            .font(.headline)
//                            .foregroundColor(.white)
//                            .frame(height: 56)
//                            .frame(maxWidth: geometry.size.width * 0.8)
//                            .background(Color("Green"))
//                            .cornerRadius(12)
//                        }
//                    }
//                    .padding(geometry.size.width * 0.05)
//                }
//            }
//        }
//    }
//
//    // ✅ Generates and saves the PDF with passed data
//    private func shareReportAsPDF(geometry: GeometryProxy) {
//        let cardView = CutoutReportCard(
//            itemName: selectedItemName,
//            itemQTY: selectedItemQTY,
//            date: captureDate,
//            showShape: false,
//            geometry: geometry
//        )
//
//        let pdfData = renderViewAsPDF(cardView, size: CGSize(width: geometry.size.width * 0.8, height: geometry.size.height * 0.6))
//        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("Report.pdf")
//
//        do {
//            try pdfData.write(to: tempURL)
//            pdfURL = tempURL
//        } catch {
//            print("Error writing PDF data: \(error)")
//        }
//    }
//
//    private func renderViewAsPDF<Content: View>(_ view: Content, size: CGSize) -> Data {
//        let controller = UIHostingController(rootView: view)
//        controller.view.frame = CGRect(origin: .zero, size: size)
//        controller.view.layoutIfNeeded()
//        controller.view.backgroundColor = .white
//        controller.overrideUserInterfaceStyle = .light
//
//        let pdfRenderer = UIGraphicsPDFRenderer(bounds: controller.view.bounds)
//        return pdfRenderer.pdfData { context in
//            context.beginPage()
//            controller.view.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
//        }
//    }
//}
//
//// ✅ Keeps preview functionality without passing arguments
//struct HistoryView_Previews: PreviewProvider {
//    static var previews: some View {
//        HistoryView(selectedItemName: "", selectedItemQTY: 0, captureDate: "")
//    }
//}

//import SwiftUI
//
//struct HistoryView: View {
//    @State private var showPopup = false
//    @State private var pdfURL: URL?
//    var selectedItemName: String
//    var selectedItemQTY: Int
//    var captureDate: String
//    var userName: String // ✅ Add this to accept userName
//
//    var body: some View {
//        GeometryReader { geometry in
//            ZStack {
//                VStack(alignment: .leading, spacing: 16) {
//                    Text("History")
//                        .font(.largeTitle)
//                        .fontWeight(.bold)
//                        .foregroundColor(Color("Green"))
//
//                    // ✅ Displays the capture date
//                    Text(captureDate)
//                        .font(.subheadline)
//                        .foregroundColor(.gray)
//
//                    VStack(alignment: .leading, spacing: 16) {
//                        Button {
//                            showPopup = true
//                        } label: {
//                            HStack(spacing: 16) {
//                                Image("bannerimage")
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fit)
//                                    .frame(width: min(geometry.size.width * 0.15, 56), height: min(geometry.size.width * 0.15, 56))
//
//                                VStack(alignment: .leading) {
//                                    Text(selectedItemName.isEmpty ? "" : selectedItemName)
//                                        .font(.system(size: 18, weight: .bold))
//                                        .foregroundColor(.primary)
//                                        .lineLimit(1)
//                                }
//
//                                Spacer()
//
//                                Text("\(selectedItemQTY) pieces")
//                                    .font(.headline)
//                                    .foregroundColor(Color("Green"))
//                                    .lineLimit(1)
//                            }
//                            .padding(.vertical, 0)
//                            .padding(.horizontal, 0)
//                            .frame(maxWidth: .infinity)
//                        }
//
//                        Spacer()
//                    }
//
//                    Spacer()
//                }
//                .padding(geometry.size.width * 0.05)
//                .onAppear {
//                    generatePDF(geometry: geometry) // ✅ Automatically generate PDF on load
//                }
//
//                if showPopup {
//                    Color.black.opacity(0.4)
//                        .edgesIgnoringSafeArea(.all)
//                        .onTapGesture {
//                            showPopup = false
//                        }
//
//                    VStack(spacing: 16) {
//                        // ✅ Pass `userName` to CutoutReportCard
//                        CutoutReportCard(
//                        itemName: selectedItemName,
//                        itemQTY: selectedItemQTY,
//                        date: captureDate,
//                        userName: userName, // ✅ Added
//                        showShape: true,
//                        geometry: geometry)
//
//
//                        if let pdfURL = pdfURL {
//                            ShareLink(item: pdfURL, preview: SharePreview("Report", image: Image(systemName: "doc"))) {
//                                HStack {
//                                    Image(systemName: "square.and.arrow.up")
//                                    Text("Share Report")
//                                }
//                                .font(.headline)
//                                .foregroundColor(.white)
//                                .frame(height: 56)
//                                .frame(maxWidth: geometry.size.width * 0.8)
//                                .background(Color("Green"))
//                                .cornerRadius(12)
//                            }
//                        } else {
//                            Text("Generating Report...")
//                                .font(.headline)
//                                .foregroundColor(.gray)
//                        }
//                    }
//                    .padding(geometry.size.width * 0.05)
//                }
//            }
//        }
//    }
//
//    // ✅ Generates and saves the PDF automatically
//    private func generatePDF(geometry: GeometryProxy) {
//        let cardView = CutoutReportCard(
//            itemName: selectedItemName,
//            itemQTY: selectedItemQTY,
//            date: captureDate,
//            userName: userName, // ✅ Added userName
//            showShape: false,
//            geometry: geometry
//        )
//
//        let pdfData = renderViewAsPDF(cardView, size: CGSize(width: geometry.size.width * 0.8, height: geometry.size.height * 0.6))
//        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("Report.pdf")
//
//        do {
//            try pdfData.write(to: tempURL)
//            DispatchQueue.main.async {
//                self.pdfURL = tempURL // ✅ Updates the PDF URL once generated
//            }
//        } catch {
//            print("Error writing PDF data: \(error)")
//        }
//    }
//
//    private func renderViewAsPDF<Content: View>(_ view: Content, size: CGSize) -> Data {
//        let controller = UIHostingController(rootView: view)
//        controller.view.frame = CGRect(origin: .zero, size: size)
//        controller.view.layoutIfNeeded()
//        controller.view.backgroundColor = .white
//        controller.overrideUserInterfaceStyle = .light
//
//        let pdfRenderer = UIGraphicsPDFRenderer(bounds: controller.view.bounds)
//        return pdfRenderer.pdfData { context in
//            context.beginPage()
//            controller.view.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
//        }
//    }
//}
//
//// ✅ Keeps preview functionality without passing arguments
//struct HistoryView_Previews: PreviewProvider {
//    static var previews: some View {
//        HistoryView(selectedItemName: "", selectedItemQTY: 0, captureDate: "", userName: "Preview User") // ✅ Added userName
//    }
//}
//
import SwiftUI

struct HistoryView: View {
    @State private var showPopup = false
    @State private var pdfURL: URL?
    var itemName: String // ✅ Renamed from selectedItemName
    var totalProducts: Int // ✅ Renamed from selectedItemQTY
    var date: String // ✅ Renamed from captureDate
    var userName: String // ✅ Accept userName

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack(alignment: .leading, spacing: 16) {
                    Text("History")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color("Green"))

                    // ✅ Displays the capture date
                    Text(date) // ✅ Updated variable name
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    VStack(alignment: .leading, spacing: 16) {
                        Button {
                            showPopup = true
                        } label: {
                            HStack(spacing: 16) {
                                Image("bannerimage")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: min(geometry.size.width * 0.15, 56), height: min(geometry.size.width * 0.15, 56))

                                VStack(alignment: .leading) {
                                    Text(itemName.isEmpty ? "" : itemName) // ✅ Updated variable name
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(.primary)
                                        .lineLimit(1)
                                }

                                Spacer()

                                Text("\(totalProducts) pieces") // ✅ Updated variable name
                                    .font(.headline)
                                    .foregroundColor(Color("Green"))
                                    .lineLimit(1)
                            }
                            .padding(.vertical, 0)
                            .padding(.horizontal, 0)
                            .frame(maxWidth: .infinity)
                        }

                        Spacer()
                    }

                    Spacer()
                }
                .padding(geometry.size.width * 0.05)
                .onAppear {
                    generatePDF(geometry: geometry) // ✅ Automatically generate PDF on load
                }

                if showPopup {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            showPopup = false
                        }

                    VStack(spacing: 16) {
                        // ✅ Pass `userName` to CutoutReportCard
                        CutoutReportCard(
                            itemName: itemName, // ✅ Updated variable name
                            totalProducts: totalProducts, // ✅ Updated variable name
                            date: date, // ✅ Updated variable name
                            userName: userName, // ✅ Pass userName
                            showShape: true,
                            geometry: geometry
                        )

                        if let pdfURL = pdfURL {
                            ShareLink(item: pdfURL, preview: SharePreview("Report", image: Image(systemName: "doc"))) {
                                HStack {
                                    Image(systemName: "square.and.arrow.up")
                                    Text("Share Report")
                                }
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(height: 56)
                                .frame(maxWidth: geometry.size.width * 0.8)
                                .background(Color("Green"))
                                .cornerRadius(12)
                            }
                        } else {
                            Text("Generating Report...")
                                .font(.headline)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(geometry.size.width * 0.05)
                }
            }
        }
    }

    // ✅ Generates and saves the PDF automatically
    private func generatePDF(geometry: GeometryProxy) {
        let cardView = CutoutReportCard(
            itemName: itemName, // ✅ Updated variable name
            totalProducts: totalProducts, // ✅ Updated variable name
            date: date, // ✅ Updated variable name
            userName: userName, // ✅ Added userName
            showShape: false,
            geometry: geometry
        )

        let pdfData = renderViewAsPDF(cardView, size: CGSize(width: geometry.size.width * 0.8, height: geometry.size.height * 0.6))
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("Report.pdf")

        do {
            try pdfData.write(to: tempURL)
            DispatchQueue.main.async {
                self.pdfURL = tempURL // ✅ Updates the PDF URL once generated
            }
        } catch {
            print("Error writing PDF data: \(error)")
        }
    }

    private func renderViewAsPDF<Content: View>(_ view: Content, size: CGSize) -> Data {
        let controller = UIHostingController(rootView: view)
        controller.view.frame = CGRect(origin: .zero, size: size)
        controller.view.layoutIfNeeded()
        controller.view.backgroundColor = .white
        controller.overrideUserInterfaceStyle = .light

        let pdfRenderer = UIGraphicsPDFRenderer(bounds: controller.view.bounds)
        return pdfRenderer.pdfData { context in
            context.beginPage()
            controller.view.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}

// ✅ Keeps preview functionality without passing arguments
struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView(itemName: "", totalProducts: 0, date: "", userName: "Preview User") // ✅ Updated variable names
    }
}

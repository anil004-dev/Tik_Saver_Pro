//
//  FakeChatPreviewGeneratorView.swift
//  WTScan
//
//  Created by iMac on 21/11/25.
//

import SwiftUI
import PhotosUI

struct FakeChatPreviewGeneratorView: View {
    
    @StateObject var viewModel = FakeChatPreviewGeneratorViewModel()
    @State private var selectedItem: PhotosPickerItem?
    
    var body: some View {
        ZStack {
            WTSwipeToBackGesture()
            LinearGradient.wtGreen.ignoresSafeArea()
            
            ZStack {
                Color.lightGreenBg.ignoresSafeArea()
                    .clipShape(UnevenRoundedRectangle(topLeadingRadius: 20, topTrailingRadius: 20))
                
                VStack(alignment: .leading, spacing: 0) {
                    fakeChatPreviewGeneratorSection
                }
                .background(Color.lightGreenBg)
                .clipShape(UnevenRoundedRectangle(topLeadingRadius: 20, topTrailingRadius: 20))
                .onTapGesture {
                    Utility.hideKeyboard()
                }
            }
            .ignoresSafeArea(edges: .bottom)
            .ignoresSafeArea(.keyboard)
            .padding(.top, 10)
            
            WTToastView()
                .zIndex(9999)
        }
        .ignoresSafeArea(.keyboard)
        .navigationTitle("Chat Preview Generator")
    }
    
    private var fakeChatPreviewGeneratorSection: some View {
        ScrollView(.vertical) {
            let safeArea = safeAreaInsets()
            
            VStack(alignment: .leading, spacing: 5) {
                headerSection
                messageSection
                inputSection
            }
            .frame(height: UIScreen.main.bounds.height - (safeArea?.top ?? 0.0) - (safeArea?.bottom ?? 0.0))
        }
        .scrollDisabled(true)
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            PhotosPicker(
                selection: $selectedItem,
                matching: .images,
                photoLibrary: .shared()
            ) {
                HStack(alignment: .center, spacing: 0) {
                    Image(uiImage: viewModel.profileImage ?? UIImage(systemName: "person.circle.fill")!)
                        .renderingMode(viewModel.profileImage == nil ? .template : .original)
                        .resizable()
                        .scaledToFill()
                        .foregroundStyle(Color.btnDarkGreen)
                        .frame(width: 38, height: 38)
                        .background(Color.lightGreenBg)
                        .clipShape(Circle())
                        .padding(.leading, 13)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        WTText(title: viewModel.profileName, color: .black, font: .system(size: 17, weight: .medium, design: .default), alignment: .leading)
                        
                        WTText(title: "online", color: .lightBorderGrey, font: .system(size: 13, weight: .regular, design: .default), alignment: .leading)
                    }
                    .padding(.leading, 12)
                    
                    Spacer(minLength: 0)
                }
                
                .padding(.horizontal, 20)
                .padding(.top, 15)
            }
            .onChange(of: selectedItem) { _, newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        viewModel.profileImage = uiImage
                    }
                }
            }
        }
        .frame(height: 50)
    }
    
    private var messageSection: some View {
        VStack(alignment: .center, spacing: 0) {
            ScrollViewReader { proxy in
                ScrollView(.vertical) {
                    
                    VStack(alignment: .center, spacing: 0) {
                        ForEach(viewModel.arrMessage, id: \.id) { message in
                            messageRow(message: message)
                                .padding(.vertical, 5)
                        }
                    }
                    
                    VStack{ }
                        .frame(height: 1)
                        .id("scrollId")
                }
                .scrollIndicators(.hidden)
                .onChange(of: viewModel.arrMessage) { _, _ in
                    proxy.scrollTo("scrollId", anchor: .bottom)
                }
            }
        }
    }
    
    private var inputSection: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 15) {
                    WTTextField(placeHolder: "Enter name", text: $viewModel.profileName)
                        .frame(height: 50)
                    
                    WTTextView(placeHolder: "Enter message", text: $viewModel.messageText)
                        .frame(height: 100)
                    
                    HStack(alignment: .center, spacing: 15) {
                        VStack(alignment: .leading, spacing: 5) {
                            WTText(title: "Time", color: .black, font: .system(size: 17, weight: .regular, design: .default), alignment: .leading)
                                .padding(.horizontal, 15)
                            
                            HStack(alignment: .center, spacing: 0) {
                                DatePicker(
                                    "Select Date",
                                    selection: $viewModel.messageTime,
                                    displayedComponents: .hourAndMinute
                                )
                                .preferredColorScheme(.light)
                                .foregroundStyle(.black)
                                .tint(.black)
                                .clipped()
                                .labelsHidden()
                                
                            }
                            .padding(.horizontal, 15)
                        }
                        
                        VStack(alignment: .leading, spacing: 5) {
                            WTText(title: "Side", color: .black, font: .system(size: 17, weight: .regular, design: .default), alignment: .leading)
                                .padding(.horizontal, 15)
                            
                            Picker("", selection: $viewModel.messageSide) {
                                Text("You").tag(0)
                                Text("Other").tag(1)
                            }
                            .pickerStyle(.segmented)
                            .padding(.horizontal, 15)
                        }
                    }
                    
                    WTButton(
                        title: "Add Message",
                        onTap: {
                            viewModel.btnAddMessage()
                        }
                    )
                    
                    HStack(alignment: .center, spacing: 15) {
                        if AppState.shared.isLive == true {
                            WTButton(
                                title: "Generate image",
                                onTap: {
                                    viewModel.btnGenerateImageAction()
                                }
                            )
                        }
                        
                        WTButton(
                            title: "Clear",
                            onTap: {
                                viewModel.btnClearAction()
                            }
                        )
                    }
                }
                .padding(16)
            }
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.bottom, 150)
        }
        .frame(height: 500)
    }
}

extension FakeChatPreviewGeneratorView {
    @ViewBuilder func messageRow(message: Message) -> some View {
        let isMyMessage: Bool = message.isMyMessage
        let textColor: Color = isMyMessage ? .white : .black
        var timeColor: Color {
            if AppState.shared.isLive {
                isMyMessage ? Color(hex: "94FA9B") : Color(hex: "125023")
            } else {
                isMyMessage ? Color.white.opacity(0.8) : Color.gray
            }
        }
        
        var bgColor: Color {
            if AppState.shared.isLive {
                isMyMessage ? Color(hex: "029F26") : Color(hex: "8CE38E")
            } else {
                isMyMessage ? Color.btnDarkGreen : Color.btnDarkGreen.opacity(0.2)
            }
        }
        
        let timeString = message.time.formatted(date: .omitted, time: .shortened)
        
        HStack(alignment: .bottom, spacing: 0) {
            if isMyMessage == true {
                Spacer(minLength: 50)
            }
            
            HStack(alignment: .bottom, spacing: 0) {
                HStack(alignment: .bottom, spacing: 10) {
                    WTText(title: message.message, color: textColor, font: .system(size: 16, design: .default), alignment: .leading)
                        .padding(.vertical, 10)
                    
                    WTText(title: timeString, color: timeColor, font: .system(size: 9, design: .default), alignment: .leading)
                        .padding(.bottom, 5)
                }
                .padding(.leading, isMyMessage ? 10 : 15)
                .padding(.trailing, !isMyMessage ? 10 : 15)
            }
            .background(bgColor)
            .clipShape(EPBubbleShape(myMessage: isMyMessage))
            
            
            if isMyMessage == false {
                Spacer(minLength: 50)
            }
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    FakeChatPreviewGeneratorView()
        .environmentObject(WTAlertManager.shared)
}

struct EPBubbleShape: Shape {
    var myMessage : Bool
    func path(in rect: CGRect) -> Path {
        let width = rect.width
        let height = rect.height
        
        let bezierPath = UIBezierPath()
        if !myMessage {
            bezierPath.move(to: CGPoint(x: 20, y: height))
            bezierPath.addLine(to: CGPoint(x: width - 15, y: height))
            bezierPath.addCurve(to: CGPoint(x: width, y: height - 15), controlPoint1: CGPoint(x: width - 8, y: height), controlPoint2: CGPoint(x: width, y: height - 8))
            bezierPath.addLine(to: CGPoint(x: width, y: 15))
            bezierPath.addCurve(to: CGPoint(x: width - 15, y: 0), controlPoint1: CGPoint(x: width, y: 8), controlPoint2: CGPoint(x: width - 8, y: 0))
            bezierPath.addLine(to: CGPoint(x: 20, y: 0))
            bezierPath.addCurve(to: CGPoint(x: 5, y: 15), controlPoint1: CGPoint(x: 12, y: 0), controlPoint2: CGPoint(x: 5, y: 8))
            bezierPath.addLine(to: CGPoint(x: 5, y: height - 10))
            bezierPath.addCurve(to: CGPoint(x: 0, y: height), controlPoint1: CGPoint(x: 5, y: height - 1), controlPoint2: CGPoint(x: 0, y: height))
            bezierPath.addLine(to: CGPoint(x: -1, y: height))
            bezierPath.addCurve(to: CGPoint(x: 12, y: height - 4), controlPoint1: CGPoint(x: 4, y: height + 1), controlPoint2: CGPoint(x: 8, y: height - 1))
            bezierPath.addCurve(to: CGPoint(x: 20, y: height), controlPoint1: CGPoint(x: 15, y: height), controlPoint2: CGPoint(x: 20, y: height))
        } else {
            bezierPath.move(to: CGPoint(x: width - 20, y: height))
            bezierPath.addLine(to: CGPoint(x: 15, y: height))
            bezierPath.addCurve(to: CGPoint(x: 0, y: height - 15), controlPoint1: CGPoint(x: 8, y: height), controlPoint2: CGPoint(x: 0, y: height - 8))
            bezierPath.addLine(to: CGPoint(x: 0, y: 15))
            bezierPath.addCurve(to: CGPoint(x: 15, y: 0), controlPoint1: CGPoint(x: 0, y: 8), controlPoint2: CGPoint(x: 8, y: 0))
            bezierPath.addLine(to: CGPoint(x: width - 20, y: 0))
            bezierPath.addCurve(to: CGPoint(x: width - 5, y: 15), controlPoint1: CGPoint(x: width - 12, y: 0), controlPoint2: CGPoint(x: width - 5, y: 8))
            bezierPath.addLine(to: CGPoint(x: width - 5, y: height - 12))
            bezierPath.addCurve(to: CGPoint(x: width, y: height), controlPoint1: CGPoint(x: width - 5, y: height - 1), controlPoint2: CGPoint(x: width, y: height))
            bezierPath.addLine(to: CGPoint(x: width + 1, y: height))
            bezierPath.addCurve(to: CGPoint(x: width - 12, y: height - 4), controlPoint1: CGPoint(x: width - 4, y: height + 1), controlPoint2: CGPoint(x: width - 8, y: height - 1))
            bezierPath.addCurve(to: CGPoint(x: width - 20, y: height), controlPoint1: CGPoint(x: width - 15, y: height), controlPoint2: CGPoint(x: width - 20, y: height))
        }
        return Path(bezierPath.cgPath)
    }
}

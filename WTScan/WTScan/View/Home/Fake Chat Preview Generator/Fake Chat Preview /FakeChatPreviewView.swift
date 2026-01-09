//
//  FakeChatPreviewView.swift
//  WTScan
//
//  Created by iMac on 21/11/25.
//

import SwiftUI

struct FakeChatPreviewView: View {
    
    var isForRender: Bool = false
    @StateObject var viewModel: FakeChatPreviewViewModel
    
    init(isForRender: Bool = false, messagePreview: MessagePreviewModel) {
        self.isForRender = isForRender
        _viewModel = StateObject(wrappedValue: FakeChatPreviewViewModel(messagePreview: messagePreview))
    }
    
    var body: some View {
        ZStack {
            WTSwipeToBackGesture()
            LinearGradient.wtGreen.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 0) {
                fakeChatPreviewSection
            }
            .ignoresSafeArea(edges: .bottom)
            
            WTToastView()
                .zIndex(9999)
        }
        .ignoresSafeArea(edges: .bottom)
        .navigationTitle("Chat Preview")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.btnSaveAction()
                } label: {
                    Text("Save")
                        .foregroundStyle(.white)
                }
            }
        }
        .sheet(isPresented: $viewModel.showShareSheetView.sheet) {
            if let qr = viewModel.showShareSheetView.chatPreviewImage {
                WTShareSheetView(items: [qr])
                    .presentationDetents([.medium, .large])
            }
        }
    }
    
    private var fakeChatPreviewSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            headerSection
            messageSection
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center, spacing: 0) {
                Image(systemName: "chevron.backward")
                    .resizable()
                    .scaledToFit()
                    .bold()
                    .foregroundStyle(.white)
                    .frame(width: 13, height: 35)
                
                Image(uiImage: viewModel.profileImage ?? UIImage(systemName: "person.circle.fill")!)
                    .renderingMode(viewModel.profileImage == nil ? .template : .original)
                    .resizable()
                    .scaledToFill()
                    .foregroundStyle(.white)
                    .frame(width: 40, height: 40)
                    .background(.gray)
                    .clipShape(Circle())
                    .padding(.leading, 25)
                
                VStack(alignment: .leading, spacing: 2) {
                    WTText(title: viewModel.profileName, color: .white, font: .system(size: 18, weight: .semibold, design: .default), alignment: .leading)
                    
                    WTText(title: "online", color: .white, font: .system(size: 13, weight: .regular, design: .default), alignment: .leading)
                }
                .padding(.leading, 12)
                
                Spacer(minLength: 0)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
        }
        .background(AppState.shared.isLive ? Color(hex: "008756") : Color.navBackground)
    }
    
    private var messageSection: some View {
        ZStack {
            Color(hex: "EFEADF").ignoresSafeArea()
            
            if isForRender {
                VStack(alignment: .center, spacing: 15) {
                    VStack{}.frame(height: 20)
                    
                    ForEach(viewModel.arrMessage, id: \.id) { message in
                        messageRow(message: message)
                    }
                    
                    VStack{}.frame(height: 40)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView(.vertical) {
                    VStack(alignment: .center, spacing: 15) {
                        VStack{}.frame(height: 20)
                        
                        ForEach(viewModel.arrMessage, id: \.id) { message in
                            messageRow(message: message)
                        }
                        
                        VStack{}.frame(height: 40)
                    }
                }
                .scrollContentBackground(.hidden)
            }
        }
    }
}

extension FakeChatPreviewView {
    @ViewBuilder func messageRow(message: Message) -> some View {
        let isMyMessage: Bool = message.isMyMessage
        let textColor: Color = isMyMessage ? .black : .black
        let bgColor: Color = isMyMessage ? Color(hex: "DFFFD5") : .white
        let timeString = message.time.formatted(date: .omitted, time: .shortened)

        HStack(alignment: .bottom, spacing: 0) {
            if isMyMessage == true {
               Spacer(minLength: 50)
            }
            
            HStack(alignment: .bottom, spacing: 0) {
                HStack(alignment: .bottom, spacing: 10) {
                    WTText(title: message.message, color: textColor, font: .system(size: 16, design: .default), alignment: .leading)
                        .padding(.vertical, 10)
                    
                    HStack(alignment: .center, spacing: 5) {
                        WTText(title: timeString, color: .black.opacity(0.5), font: .system(size: 11.5, weight: .medium, design: .default), alignment: .leading)
                        
                        if isMyMessage {
                            Image(.icBlueCheckmark)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 15, height: 15)
                        }
                    }
                    .padding(.bottom, 5)
                }
                .padding(.leading, isMyMessage ? 10 : 15)
                .padding(.trailing, !isMyMessage ? 10 : 15)
            }
            .background(bgColor)
            .clipShape(EPWPBubbleShape(myMessage: isMyMessage))
            
            if isMyMessage == false {
                Spacer(minLength: 50)
            }
        }
        .padding(.horizontal, 15)
    }
}

struct EPWPBubbleShape: Shape {
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

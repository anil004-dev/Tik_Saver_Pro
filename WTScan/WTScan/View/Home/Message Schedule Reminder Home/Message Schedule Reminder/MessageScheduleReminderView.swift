//
//  MessageSchedulerReminderView.swift
//  WTScan
//
//  Created by iMac on 24/11/25.
//

import SwiftUI

struct MessageSchedulerReminderView: View {
    @StateObject var viewModel = MessageSchedulerReminderViewModel()
    @EnvironmentObject private var entitlementManager: EntitlementManager
    var body: some View {
        ZStack {
            WTSwipeToBackGesture()
            LinearGradient.wtGreen.ignoresSafeArea()
            
            ZStack(alignment: .top) {
                LinearGradient.optionBg.ignoresSafeArea()
                    .clipShape(UnevenRoundedRectangle(topLeadingRadius: 20, topTrailingRadius: 20))
                
                VStack(alignment: .leading, spacing: 0) {
                    messageScheduleReminderSection
                }
                //.background(Color.lightGreenBg)
                .clipShape(UnevenRoundedRectangle(topLeadingRadius: 20, topTrailingRadius: 20))
                .onTapGesture {
                    Utility.hideKeyboard()
                }
            }
            .ignoresSafeArea(edges: .bottom)
            .padding(.top, 10)
            if !entitlementManager.hasPro {
                VStack(alignment: .center, spacing: 0) {
                    Spacer()
                    BannerAdContentView()
                }
            }
            WTToastView()
                .zIndex(9999)
        }
        .ignoresSafeArea(.keyboard)
        .navigationTitle("Message Scheduler Reminder")
    }
    
    private var messageScheduleReminderSection: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 12) {
                    WTText(title: "⏰ Message schedule reminder", color: .white, font: .system(size: 18, weight: .bold, design: .default), alignment: .leading)
                    
                    WTText(title: "Schedule reminders for important message", color: .white, font: .system(size: 16, weight: .regular, design: .default), alignment: .leading)
                }
                .padding(.horizontal, 16)
                
                VStack {
                    VStack(alignment: .leading, spacing: 0) {
                        VStack(alignment: .leading, spacing: 0) {
                            WTText(title: "Enter message text", color: .white, font: .system(size: 16, weight: .semibold, design: .default), alignment: .leading)
                                .padding(.leading, 8)
                                .padding(.bottom, 10)
                            
                            WTTextField(placeHolder: "Have a great day!", text: $viewModel.message)
                                .frame(height: 50)
                                .padding(.bottom, 20)
                            
                            WTText(title: "Select reminder time", color: .white, font: .system(size: 16, weight: .semibold, design: .default), alignment: .leading)
                                .padding(.leading, 8)
                                .padding(.bottom, 10)
                            
                            HStack {
                                TimelineView(.everyMinute) { _ in
                                    DatePicker(
                                        "",
                                        selection: $viewModel.scheduleDate,
                                        in: (Date.now.addingTimeInterval(60*5))...,
                                        displayedComponents: [.date, .hourAndMinute]
                                    )
                                    .preferredColorScheme(.light)
                                    .datePickerStyle(.compact)
                                    .labelsHidden()
                                }
                                
                                Spacer()
                            }
                            .padding(.bottom, 40)
                            WTButton(
                                title: "Schedule Reminders",
                                onTap: {
                                    viewModel.btnScheduleReminderAction()
                                }
                            )
                        }
                    }
                    .padding(16)
                }
                .background(AppColor.Gray.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(16)
                .frame(maxWidth: .infinity)
            }
            .padding(.top, 20)
        }
        .scrollIndicators(.hidden)
    }
}

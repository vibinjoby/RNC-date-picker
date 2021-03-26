//
//  RNCustomDatePicker.m
//
//  Created by vibin joby on 2021-03-21.
//
#import "React/RCTBridgeModule.h"
#import <React/RCTViewManager.h>
 
@interface RCT_EXTERN_MODULE(DtPickerViewManager, RCTViewManager)
RCT_EXPORT_VIEW_PROPERTY(restrictedDays, NSArray)
RCT_EXPORT_VIEW_PROPERTY(hint, NSString)
RCT_EXPORT_VIEW_PROPERTY(dateFormat, NSString)
RCT_EXPORT_VIEW_PROPERTY(onDonePressed, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onDateChanged, RCTBubblingEventBlock)
@end

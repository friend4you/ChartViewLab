//
//  RDLPushUpsModel.m
//  ChartViewLab
//
//  Created by Dmitriy Frolov on 07/11/2017.
//  Copyright © 2017 Dmitriy Frolov. All rights reserved.
//

#import "RDLPushUpsModel.h"

@interface RDLPushUpsModel()

@property (nonatomic, assign) NSInteger day;
@property (nonatomic, assign) NSInteger pushUps;

@end

@implementation RDLPushUpsModel

- (instancetype)initWithDay:(NSInteger)day withPushUpsAmount:(NSInteger)pushUps {
    self = [super init];
    if (self) {
        _day = day;
        _pushUps = pushUps;
    }
    return self;
}

- (NSNumber *)yAxisValue {
    return @(self.pushUps);
}

- (NSNumber *)xAxisValue {
    return @(self.day);
}

- (UIColor *)pointColor {
    return [UIColor redColor];
}

@end

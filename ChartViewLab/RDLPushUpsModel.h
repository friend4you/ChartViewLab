//
//  RDLPushUpsModel.h
//  ChartViewLab
//
//  Created by Dmitriy Frolov on 07/11/2017.
//  Copyright © 2017 Dmitriy Frolov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RDLChartPointProtocol.h"

@interface RDLPushUpsModel : NSObject <RDLChartPointProtocol>

- (instancetype)initWithDay:(NSInteger)day withPushUpsAmount:(NSInteger)pushUps;

@end

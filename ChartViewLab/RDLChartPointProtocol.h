//
//  RDLChartPointProtocol.h
//  ChartViewLab
//
//  Created by Dmitriy Frolov on 07/11/2017.
//  Copyright © 2017 Dmitriy Frolov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol RDLChartPointProtocol <NSObject>

- (NSNumber *)yAxisValue;
- (NSNumber *)xAxisValue;
- (UIColor *)pointColor;

@end

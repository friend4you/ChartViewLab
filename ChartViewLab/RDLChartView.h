//
//  RDLChartView.h
//  ChartViewLab
//
//  Created by Dmitriy Frolov on 07/11/2017.
//  Copyright © 2017 Dmitriy Frolov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RDLChartPointProtocol.h"

@interface RDLChartView : UIView

- (void)reloadWithData:(NSArray <RDLChartPointProtocol> *)data;

@end

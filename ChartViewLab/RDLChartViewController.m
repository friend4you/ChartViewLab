//
//  ViewController.m
//  ChartViewLab
//
//  Created by Dmitriy Frolov on 07/11/2017.
//  Copyright © 2017 Dmitriy Frolov. All rights reserved.
//

#import "RDLChartViewController.h"
#import "RDLPushUpsModel.h"
#import "RDLChartView.h"

@interface RDLChartViewController ()

@property (weak, nonatomic) IBOutlet RDLChartView *chartView;

@end

@implementation RDLChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.chartView reloadWithData:[self pushUpsResults]];
}

- (NSArray <RDLChartPointProtocol> *)pushUpsResults {
    NSMutableArray *results = [[NSMutableArray alloc] init];
    for (NSInteger i = 1; i < 8; i++) {
        NSInteger value = [self pushupsValue];
        RDLPushUpsModel *pushUpsModel = [[RDLPushUpsModel alloc] initWithDay:i withPushUpsAmount:value];
        [results addObject:pushUpsModel];
    }
    
    NSArray <RDLChartPointProtocol> *updatedResult  = [results copy];
    
    return updatedResult;
}

- (NSInteger)pushupsValue {
    NSInteger value = arc4random_uniform(40);
    
    return value;
}

@end

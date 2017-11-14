//
//  RDLChartView.m
//  ChartViewLab
//
//  Created by Dmitriy Frolov on 07/11/2017.
//  Copyright © 2017 Dmitriy Frolov. All rights reserved.
//

#import "RDLChartView.h"
@import CoreText;


static const CGFloat kSideOffsetValue = 30;
static const CGFloat kAxisSideOffset = 10;

@interface RDLChartView()

@property (nonatomic, strong) NSMutableArray *pointValues;

@property (nonatomic, strong) UIColor *fillColor;
@property (nonatomic, strong) UIColor *axisColor;
@property (nonatomic, strong) UIColor *graphColor;

@property (nonatomic, assign) CGFloat pointWidth;
@property (nonatomic, assign) CGFloat graphLineWidth;
@property (nonatomic, assign) CGFloat axisLineWidth;

@end

@implementation RDLChartView

- (void)reloadWithData:(NSArray <RDLChartPointProtocol> *)data {
    self.pointValues = [NSMutableArray arrayWithArray:data];
    //Colors
    self.fillColor = [UIColor yellowColor];
    self.axisColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7] ;
    self.graphColor = [[UIColor yellowColor] colorWithAlphaComponent:0.7];
    
    //width
    self.pointWidth = 8;
    self.graphLineWidth = 2.5;
    self.axisLineWidth = 3;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = [self currentContext];
    [self drawGradientWithContext:ctx inRect:rect];
    [self drawAxisInRect:rect context:ctx];
//    [self drawGraphWithPathWithContext:ctx];
    
    [self drawGraphicWithBezierPath];
    [self addPointsOnVertexWithContext:ctx];
}

- (void)drawGraphicWithBezierPath {
    if (self.pointValues.count > 0) {
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        path.lineJoinStyle = kCGLineJoinRound;
        [[UIColor yellowColor] setStroke];
        [path moveToPoint:CGPointMake(kAxisSideOffset, kAxisSideOffset)];
        path.lineWidth = self.graphLineWidth;
        
        //get max value
        NSNumber *maxXValue = [self.pointValues valueForKeyPath:@"@max.xAxisValue"];
        NSNumber *maxYValue = [self.pointValues valueForKeyPath:@"@max.yAxisValue"];
        
        //draw with points
        [self.pointValues enumerateObjectsUsingBlock:^(id <RDLChartPointProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CGFloat updatedX = [self updatedXValue:obj.xAxisValue maxValue:maxXValue];
            CGFloat updatedY = [self updatedYValue:obj.yAxisValue maxYValue:maxYValue];
            [path addLineToPoint:CGPointMake(updatedX, updatedY)];
        }];
        
        [path stroke];
    }
}



- (void)addVertexText:(NSString *)text
              context:(CGContextRef)ctx
             withrect:(CGRect)rect {
    
    NSMutableAttributedString *currentText =
    [[NSMutableAttributedString alloc] initWithString:text
                                           attributes:@{NSForegroundColorAttributeName : [UIColor redColor]}];
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, rect);
    // generate cf frame and draw it itself
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((CFMutableAttributedStringRef)currentText);
    //setup range of text
    CFRange currentRange = CFRangeMake(0, text.length);
    //create frame with setter, range, path , NULL = without additional attributes
    CTFrameRef frameRef = CTFramesetterCreateFrame(frameSetter, currentRange, path, NULL);
    CTFrameDraw(frameRef,ctx);
}

- (void)addPointsOnVertexWithContext:(CGContextRef)ctx {
    NSNumber *maxXValue = [self.pointValues valueForKeyPath:@"@max.xAxisValue"];
    NSNumber *maxYValue = [self.pointValues valueForKeyPath:@"@max.yAxisValue"];
    [self.pointValues enumerateObjectsUsingBlock:^(id <RDLChartPointProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat updatedX = [self updatedXValue:obj.xAxisValue maxValue:maxXValue];
        CGFloat updatedY = [self updatedYValue:obj.yAxisValue maxYValue:maxYValue];
        CGRect circlePointRect = CGRectMake((updatedX - self.pointWidth/2), (updatedY - self.pointWidth/2), self.pointWidth, self.pointWidth);
        
        CGContextSetFillColorWithColor(ctx, obj.pointColor.CGColor);
        CGContextFillEllipseInRect(ctx, circlePointRect);
        
        //Text Rect
        NSString *value = [NSString stringWithFormat:@"%@",obj.yAxisValue];
        CGRect textRect = CGRectMake(circlePointRect.origin.x + 10, circlePointRect.origin.y, 50, 20);
        [self addVertexText:value context:ctx withrect:textRect];
    }];
}

- (void)drawGraphWithPathWithContext:(CGContextRef)ctx {
    if (self.pointValues.count > 0) {
        CGContextSetStrokeColorWithColor(ctx, self.graphColor.CGColor);
        CGMutablePathRef path = CGPathCreateMutable();
        
        CGContextSetLineWidth(ctx, 5);
        CGPathMoveToPoint(path, nil, kAxisSideOffset, kAxisSideOffset);
        
        //get max value
        NSNumber *maxXValue = [self.pointValues valueForKeyPath:@"@max.xAxisValue"];
        NSNumber *maxYValue = [self.pointValues valueForKeyPath:@"@max.yAxisValue"];
        //draw with points
        [self.pointValues enumerateObjectsUsingBlock:^(id <RDLChartPointProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CGFloat updatedX = [self updatedXValue:obj.xAxisValue maxValue:maxXValue];
            CGFloat updatedY = [self updatedYValue:obj.yAxisValue maxYValue:maxYValue];
            CGPathAddLineToPoint(path, nil, updatedX, updatedY);
        }];
        CGContextAddPath(ctx, path);
        CGContextStrokePath(ctx);
    }
}

- (void)drawAxisInRect:(CGRect)rect context:(CGContextRef)ctx {
    CGContextSetStrokeColorWithColor(ctx, self.axisColor.CGColor);
    CGFloat maxXPointValue = CGRectGetMaxX(rect);
    CGFloat maxYPointValue = CGRectGetMaxY(rect);
    
    CGContextSetLineWidth(ctx, 3);
    CGContextMoveToPoint(ctx,kAxisSideOffset, kAxisSideOffset);
    CGContextAddLineToPoint(ctx, kAxisSideOffset, maxYPointValue);
    
    CGContextMoveToPoint(ctx, kAxisSideOffset, kAxisSideOffset);
    CGContextAddLineToPoint(ctx, maxXPointValue, kAxisSideOffset);
    CGContextStrokePath(ctx);
    
//    draw dash lines
    CGContextSetStrokeColorWithColor(ctx, [self.axisColor colorWithAlphaComponent:0.2].CGColor);
    id maxXValue = [self.pointValues valueForKeyPath:@"@max.xAxisValue"];
    [self.pointValues enumerateObjectsUsingBlock:^(id <RDLChartPointProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat updatedX = [self updatedXValue:obj.xAxisValue maxValue:maxXValue];
        CGContextSetLineWidth(ctx, 2);
        CGContextMoveToPoint(ctx, updatedX, kAxisSideOffset);
        CGContextAddLineToPoint(ctx, updatedX, CGRectGetMaxY(rect));
        CGFloat dash[] = {0.0, 5.0};
        //0 - starts drwain from the begin
        //dash - length
        CGContextSetLineDash(ctx, 0, dash, 3);
        CGContextStrokePath(ctx);
    }];
    
    CGContextSetLineDash(ctx, 0, NULL, 0);
}

- (CGContextRef)currentContext {
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(ctx, kCGLineCapRound); //end of the line
    CGContextSetLineJoin(ctx, kCGLineJoinRound); //join line
    
    //changes the coordinate system, update origin coordinate
    //we should update only by height
    CGContextTranslateCTM(ctx,0.0, CGRectGetHeight(self.frame));
    //scale context. from the programming guide we should use scale
    CGContextScaleCTM(ctx, 1.0, -1.0);
    //color that should be used in fill
    CGContextSetFillColorWithColor(ctx, self.fillColor.CGColor);
    return ctx;
}

- (void)drawGradientWithContext:(CGContextRef)ctx inRect:(CGRect)rect {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[3] = { 0.0, 0.5, 0.95};
    
    NSArray *colors = @[(id)[UIColor colorWithRed:1/255.0 green:30/255.0 blue:76/255.0 alpha:1].CGColor,
                        (id)[UIColor colorWithRed:45/255.0 green:18/255.0 blue:237/255.0 alpha:1].CGColor,
                        (id)[UIColor colorWithRed:59/255.0 green:128/255.0 blue:239/255.0 alpha:1].CGColor];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)colors, locations);
    CGContextDrawLinearGradient(ctx, gradient, CGPointMake(0, 0), CGPointMake(0,CGRectGetHeight(rect)), 0);
}

#pragma mark - Helpers

- (CGFloat)updatedXValue:(NSNumber*)value maxValue:(NSNumber*)maxValue {
    CGFloat maxXBoudsValue = CGRectGetMaxX(self.bounds) - kSideOffsetValue;
    CGFloat diff = maxXBoudsValue/[maxValue floatValue];
    
    return ([value floatValue] * diff) + kAxisSideOffset;
}

- (CGFloat)updatedYValue:(NSNumber*)value maxYValue:(NSNumber*)maxValue {
    CGFloat maxYBoudsValue = CGRectGetMaxY(self.bounds) - kSideOffsetValue;
    CGFloat diff = maxYBoudsValue/[maxValue floatValue];
    
    return ([value floatValue] * diff) + kAxisSideOffset;
}

@end

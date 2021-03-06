//
//  GraphView.m
//  SCDLifeStyle
//
//  Created by Juan Fluxa on 6/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GraphView.h"
#import "Day.h"
#import <QuartzCore/QuartzCore.h>
#import "Util.h"
#import "NSDate+SCDCategory.h"

//ALL VALUES AT ZOOM LEVEL 1.0
#define BAR_W 10
#define BAR_GAP 1

#define MARGIN_X 28
#define SHOW_DATE_EACH 9 //days
#define DATE_LINE_H 180.0f


@implementation GraphView
@synthesize data = _data;

//NSArray [dates,days,zoomlevel,graphType]
- (void) setData:(NSArray *)data
{
    _data = data;
    
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    if (self.data != nil) 
    {
        //clean graph view
        for (UIView *v in [self subviews]) 
        {
            [v removeFromSuperview];
        }
        
        NSArray *dates = [self.data objectAtIndex:0];
        NSArray *days = [self.data objectAtIndex:1];
        NSNumber *zoom = [self.data objectAtIndex:2];
        NSNumber *type = [self.data objectAtIndex:3];
    
        float posX = self.frame.size.width - MARGIN_X*zoom.floatValue;
        float posY = self.frame.size.height;
        float barW = BAR_W*zoom.floatValue;
        float barGap = BAR_GAP*zoom.floatValue;
        int graphType = type.intValue;

        int c = [dates count];
        for (int i=0; i<c; i++) 
        {
            NSDate *date = [dates objectAtIndex:i];
            NSObject *dayO = [days objectAtIndex:i];
            
            CGContextRef c = UIGraphicsGetCurrentContext();
            
            //date
            if (i == 0 || i%SHOW_DATE_EACH == 0) 
            {
                CGContextBeginPath(c);
                CGContextSetLineWidth(c, 1.0f);
                CGContextSetStrokeColorWithColor(c, [UIColor whiteColor].CGColor);
                CGContextMoveToPoint(c, posX+barW+barGap, posY);
                CGContextAddLineToPoint(c, posX+barW+barGap, self.frame.size.height-DATE_LINE_H);
                CGContextClosePath(c);
                CGContextDrawPath(c, kCGPathStroke);
                
                NSString *dateString;
                if ([date isToday]) {
                    dateString = @"Today";
                }
                else {
                    dateString = [NSString stringWithFormat:@"%d %@", date.dateInformation.day, [date monthString]];
                }
                
                CGContextSetFillColorWithColor(c, [UIColor whiteColor].CGColor);
                [dateString drawInRect:CGRectMake(posX-40, 10, 100, 50) 
                              withFont:[UIFont fontWithName:@"Helvetica" size:16]];
            }
            
            if (dayO != [NSNull null]) 
            {
                Day *day = (Day*)dayO;
                NSNumber *barValue;
                
                switch (graphType) {
                    case SLEEP_TYPE:
                        barValue = day.sleep_quality;
                        break;
                        
                    case STRESS_TYPE:
                        barValue = day.stress;
                        break;
        
                    case EXERCISE_TYPE:
                        barValue = day.excercise;
                        break;
                }
                
                
                if (barValue != nil) 
                {
                    //we can graph
                    float barH = [Util getHeightFor:graphType andValue:barValue];
                    UIColor *color = [Util getColorFor:graphType andValue:barValue];
                    CGContextSetFillColorWithColor(c, color.CGColor);
                    CGContextFillRect(c, CGRectMake(posX, posY, barW, -barH));
                }
                
                
                
            }
            
            posX -= barW + barGap;
        }
    }
}


@end

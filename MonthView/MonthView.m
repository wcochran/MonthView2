//
//  MonthView.m
//  MonthView
//
//  Created by Wayne Cochran on 3/30/14.
//  Copyright (c) 2014 Wayne Cochran. All rights reserved.
//

#import "MonthView.h"

//
// http://en.wikipedia.org/wiki/Determination_of_the_day_of_the_week
// Tomohiko Sakamoto
//
static int dow(int y, int m, int d)
{
    static int t[] = {0, 3, 2, 5, 0, 3, 5, 1, 4, 6, 2, 4};
    y -= m < 3;
    return (y + y/4 - y/100 + y/400 + t[m-1] + d) % 7;
}

static BOOL isLeapYear(int y) {
    return y % 400 == 0 || (y % 4 == 0 && y % 100 != 0);
}

static int numDaysInMonth(int y, int m) {
    static int days[] = {0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
    int n = days[m];
    if (m == 2 && isLeapYear(y))
        n++;
    return n;
}

@implementation MonthView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
    }
    return self;
}

#define MARGIN 2

-(CGRect)contentRect {
    const CGFloat size = MIN(self.bounds.size.width,self.bounds.size.height) - MARGIN;
    const CGRect contentRect = CGRectMake((self.bounds.size.width - size)/2,
                                          (self.bounds.size.height - size)/2,
                                          size, size);
    return contentRect;
}

//
// Draws month in largest possible square centered in view.
// Month is laid on on a 7x7 grid; the top row contains Month/Year title
// and 7 column headers for the for the days of the week.
// The last 6 rows (bottom 6x7 portion of the grid) contains 42 days
// which covers the month specified in 'self.date' as well as 0 to 6 days
// of the previous month and as many days of the next month fill in
// the last 1 or 2 rows.
// We assume the drawing region is a 700x700 square and modify the
// Current Modeling Transformation (CTM) to map this to a square that
// fite comfortable winthin the view.
//
- (void)drawRect:(CGRect)rect
{
    NSInteger startDayOfWeek = dow(self.year, self.month, 1);
    NSInteger daysInMonth = numDaysInMonth(self.year, self.month);

    //
    // Use Core Graphics to render month view.
    //
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //
    // Find the largest square that can fit in the current view and
    // center it.
    // Modify the CTM so that our 700 x 700 drawing maps to this square.
    //
    const CGFloat size = MIN(self.bounds.size.width,self.bounds.size.height) - MARGIN;
    const CGRect contentRect = [self contentRect];
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, contentRect.origin.x, contentRect.origin.y);
    CGContextScaleCTM(context, size/700, size/700);
    
    //
    // Draw Month/Year title.
    //
    NSDictionary *monthYearAttributes = @{ NSFontAttributeName: [UIFont fontWithName:@"Helvetica" size:36],
                                           NSForegroundColorAttributeName: [UIColor blackColor]};
    static NSString *monthStrings[] = {@"",
        @"January", @"February", @"March", @"April", @"May", @"June",
        @"July", @"August", @"September", @"October", @"November", @"December"
    };
    NSString *monthYearString = [NSString stringWithFormat:@"%@ %d", monthStrings[self.month], self.year];
    const CGSize headTextSize = [monthYearString sizeWithAttributes:monthYearAttributes];
    const CGRect headRect = CGRectMake((700 - headTextSize.width)/2, (50 - headTextSize.height)/2,
                                       headTextSize.width, headTextSize.height);
    [monthYearString drawInRect:headRect withAttributes:monthYearAttributes];
    
    //
    // Draw days of week.
    //
    NSDictionary *dowAttributes = @{ NSFontAttributeName: [UIFont fontWithName:@"Helvetica" size:28],
                                            NSForegroundColorAttributeName: [UIColor blackColor]};
    NSArray *dowStrings = @[@"Sun", @"Mon", @"Tue", @"Wed", @"Thu", @"Fri", @"Sat"];
    for (int c = 0; c < 7; c++) {
        NSString *dow = [dowStrings objectAtIndex:c];
        const CGSize dowSize = [dow sizeWithAttributes:dowAttributes];
        const CGRect dowRect = CGRectMake(c*100 + (100 - dowSize.width)/2, 50 + (50 - dowSize.height),
                                          dowSize.width, dowSize.height);
        [dow drawInRect:dowRect withAttributes:dowAttributes];
    }
    
    //
    // Draw numbers and boxes for days of current month.
    //
    NSDictionary *attributes = @{ NSFontAttributeName: [UIFont fontWithName:@"Helvetica" size:30],
                                  NSForegroundColorAttributeName: [UIColor blackColor]};
    CGContextSetLineWidth(context, 4);
    CGContextSetRGBStrokeColor(context, 0, 0, 0, 1);
    int r = 1;
    int c = startDayOfWeek;
    for (int d = 1; d <= daysInMonth; d++) {
        const CGRect monthRect = CGRectMake(c*100, r*100, 100, 100);
        CGContextStrokeRect(context, monthRect);
        NSString *dayStr = [NSString stringWithFormat:@"%d", d];
        const CGSize dsize = [dayStr sizeWithAttributes:attributes];
        const CGRect drect = CGRectMake(monthRect.origin.x + (50 - dsize.width)/2,
                                        monthRect.origin.y + (50 - dsize.height)/2,
                                        dsize.width, dsize.height);
        [dayStr drawInRect:drect withAttributes:attributes];
        if (c == 6) {
            c = 0;
            r++;
        } else {
            c++;
        }
    }
    
    CGContextRestoreGState(context);
}


@end

#import "TTTextEditor+Additions.h"

@implementation TTTextEditor (Additions)

-(void)setSelectedRange:(NSRange)range {
    [_textView setSelectedRange:range];
}

@end

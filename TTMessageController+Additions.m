#import "TTMessageController+Additions.h"

@implementation TTMessageController (Additions)

- (void)removeFieldOfClass:(Class)class {
    NSMutableArray *fields = [NSMutableArray arrayWithArray:self.fields];
    for (id field in self.fields)
        if ([field isKindOfClass:class])
            [fields removeObject:field];

    self.fields = [[NSArray arrayWithArray:fields] retain];
}

- (void)addFieldWithView:(UIView *)fieldView {
    [_scrollView addSubview:fieldView];
    [fieldView setNeedsLayout];
    _scrollView.scrollEnabled = YES;
    [_scrollView flashScrollIndicators];
}

@end

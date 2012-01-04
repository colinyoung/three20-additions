#import "TTTableViewDataSource+Accessible.h"

@implementation TTTableViewDataSource (Accessible)

-(NSIndexPath*)tableView:(UITableView *)tableView indexPathForObjectWithAccessibilityLabel:(NSString *)accessibilityLabel {
    
    for (id sectionOrItem in [(TTListDataSource*)self items])
    {
        if ([self respondsToSelector:@selector(sections)]) {
            for (TTTableItem *item in (NSArray*)sectionOrItem) {
                if ([item.accessibilityLabel isEqualToString:accessibilityLabel])
                    return [self tableView:tableView indexPathForObject:item];
            }
        } else {
            TTTableItem *item = (TTTableItem*)sectionOrItem;
            if ([item.accessibilityLabel isEqualToString:accessibilityLabel])
                return [self tableView:tableView indexPathForObject:item];
        }
    }
    
    return nil;
}

-(TTTableItem*)tableView:(UITableView *)tableView objectWithAccessibilityLabel:(NSString *)accessibilityLabel {
    NSIndexPath *path = [self tableView:tableView indexPathForObjectWithAccessibilityLabel:accessibilityLabel];
    return [self tableView:tableView objectForRowAtIndexPath:path];
}

@end

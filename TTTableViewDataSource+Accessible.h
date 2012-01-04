@interface TTTableViewDataSource (Accessible)

-(NSIndexPath*)tableView:(UITableView *)tableView indexPathForObjectWithAccessibilityLabel:(NSString *)accessibilityLabel;
-(TTTableItem*)tableView:(UITableView *)tableView objectWithAccessibilityLabel:(NSString *)accessibilityLabel;

@end

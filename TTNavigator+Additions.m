#import "TTNavigator+Additions.h"

@implementation TTNavigator (Additions)

-(Class)classOfViewControllerForURL:(NSURL *)URL {
    TTURLNavigatorPattern *pattern = [[[TTNavigator navigator] URLMap] matchObjectPattern:URL];
    return [pattern targetClass];
}

-(void)popToRootViewControllerAnimated:(BOOL)animated {
    [self popToRootViewControllerAnimated:animated thenOpenURLAction:nil];
}

-(void)popToRootViewControllerAnimated:(BOOL)animated thenOpenURLAction:(TTURLAction*)action {
    [self popViewControllerAnimated:animated];
    
    id navigationController = [self rootViewController];
    if ([navigationController isKindOfClass:[UINavigationController class]]) {
        [(UINavigationController*)navigationController popToRootViewControllerAnimated:animated];
    }
    
    if (action == nil) return;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0e9 * kModalTransitionDuration)), dispatch_get_main_queue(), ^{
        [action applyAnimated:animated];
        [self openURLAction:action];
    });
}

-(void)popViewControllerAnimated:(BOOL)animated {
    return [self popViewControllerAnimated:animated afterwards:^{}];
}

-(void)popViewControllerAnimated:(BOOL)animated afterwards:(void (^)(void))afterwards {
  
    id navigationController = [self rootViewController];
    
    // if ([[self topViewController] conformsToProtocol:@protocol(ModalPopoverViewControllerParent)]) {
    //     [(id <ModalPopoverViewControllerParent>)[self topViewController] dismissModalPopoverViewControllerAnimated:animated];
    //     [self performBlock:afterwards afterDelay:kModalTransitionDuration];
    //     return;
    // }
    
    // Declare a function presentsAsModal returning YES to have this method 
    // intelligently pop modally presenting controllers.
    if ([[self topViewController] respondsToSelector:@selector(presentsAsModal)]) {
        [[self topViewController].parentViewController dismissModalViewControllerAnimated:animated];
        [self performBlock:afterwards afterDelay:kModalTransitionDuration];
        return;
    }
    if ([navigationController isKindOfClass:[UINavigationController class]]) {
        [(UINavigationController*)navigationController popViewControllerAnimated:animated];
        [self performBlock:afterwards afterDelay:kHorizontalSlideAnimationDuration];
    }
}

-(void)popToRootViewControllerThenOpenURLs:(NSArray*)URLs {
  
    [self popToRootViewControllerAnimated:NO];
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timedOpenURLAction:) userInfo:
     [NSDictionary dictionaryWithObjectsAndKeys:
      URLs,@"actions",
      self, @"navigator",
      nil]
                                    repeats:NO];
}

-(void)clearRootViewControllerThenOpenURLAction:(TTURLAction*)action {
    return [self clearRootViewControllerThenOpenURLAction:action afterDelay:0.f];
}

-(void)clearRootViewControllerThenOpenURLAction:(TTURLAction*)action afterDelay:(CGFloat)delay {
    [self resetDefaults];
    [self removeAllViewControllers];
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window removeAllSubviews];
    
    // Add a temporary cover view
    [window setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    TTActivityLabel* label = [[[TTActivityLabel alloc] initWithStyle:TTActivityLabelStyleGray] autorelease];
    [label setIsAnimating:YES];
    label.frame = CGRectMake(0, 0, 320, 40);
    label.text = @"Loading...";
    [label sizeToFit];
    label.center = window.center;
    label.frame = CGRectMake( 
      ceilf(label.frame.origin.x), 
      ceilf(label.frame.origin.y),
      ceilf(label.frame.size.width),
      ceilf(label.frame.size.height)
    );
    [window addSubview:label];
    
    // Perform block after delay
    int64_t delta = (int64_t)(1.0e9 * delay);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delta), dispatch_get_main_queue(), ^{
      
      [[[UIApplication sharedApplication] keyWindow] removeAllSubviews];
      [[[UIApplication sharedApplication] keyWindow] setBackgroundColor:[UIColor blackColor]];
      [[TTNavigator navigator] openURLAction:action];
      
    });
}

-(void)dismissModalViewController:(UIViewController *)viewController thenOpenURLAction:(TTURLAction *)URLAction animated:(BOOL)animated {
    UIViewController *parentVC = viewController.parentViewController;
    [parentVC dismissModalViewControllerAnimated:animated];
    
    [URLAction applyAnimated:animated];
    
    (void (^)(void)) blk = ^{ 
        [self openURLAction:URLAction];
    };
    CGFloat delay = 0.0f;
    if (animated) delay = 0.5f;
    
    int64_t delta = (int64_t)(1.0e9 * delay);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delta), dispatch_get_main_queue(), blk);
}

#pragma mark - Private
-(void)timedOpenURLAction:(NSTimer *)timer {
    TTNavigator *navigator = [[timer userInfo] objectForKey:@"navigator"];    
    NSArray *URLs = [[timer userInfo] objectForKey:@"actions"];
    if (URLs != nil) {
        for (NSString *URL in URLs)
            [navigator openURLAction:[TTURLAction actionWithURLPath:URL]];
        return;
    }
    TTURLAction *action = [[timer userInfo] objectForKey:@"action"];
    [navigator openURLAction:action];
}


@end

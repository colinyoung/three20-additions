/* A group of additions to TTNavigator to provide for Back button functionality,
  dismissal of modal view controllers, and more */

#define kHorizontalSlideAnimationDuration 0.35f
#define kModalTransitionDuration 0.25f

-(Class)classOfViewControllerForURL:(NSURL *)URL;

-(void)popToRootViewControllerAnimated:(BOOL)animated;
-(void)popToRootViewControllerAnimated:(BOOL)animated thenOpenURLAction:(TTURLAction*)action;
-(void)popViewControllerAnimated:(BOOL)animated;
-(void)popViewControllerAnimated:(BOOL)animated afterwards:(Block)afterwards;
-(void)popToRootViewControllerThenOpenURLs:(NSArray*)URLs;
-(void)clearRootViewControllerThenOpenURLAction:(TTURLAction*)action;
-(void)clearRootViewControllerThenOpenURLAction:(TTURLAction*)action afterDelay:(CGFloat)delay;
-(void)dismissModalViewController:(UIViewController *)viewController thenOpenURLAction:(TTURLAction *)URLAction animated:(BOOL)animated;

// Private
-(void)timedOpenURLAction:(NSTimer *)timer;
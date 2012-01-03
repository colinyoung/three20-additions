/* A group of additions to TTNavigator to provide for Back button functionality,
  dismissal of modal view controllers, and more */

#define kHorizontalSlideAnimationDuration 0.35f
#define kModalTransitionDuration 0.25f

/* Useful when determining what class of View controller a URL points to:
  for example, tt://home -> HomeController
*/ 
-(Class)classOfViewControllerForURL:(NSURL *)URL;

-(void)popToRootViewControllerAnimated:(BOOL)animated;
-(void)popToRootViewControllerAnimated:(BOOL)animated thenOpenURLAction:(TTURLAction*)action;

/* Pops only ONE view controller back. Essentially programmatically presses the back button,
  however, includes some niceties such as dismissing modals if the topViewController is modal.
  
  NOTE, that for that to work, you need to implement a 
  -(BOOL)presentsAsModal method on that modal view controller returning YES.
*/
-(void)popViewControllerAnimated:(BOOL)animated;
-(void)popViewControllerAnimated:(BOOL)animated afterwards:(void (^)(void))afterwards; // afterwards is a block (^{})

/* The root view controller is considered the "base" view controller.
  This method does _not_ remove the root view controller. */
-(void)popToRootViewControllerThenOpenURLs:(NSArray*)URLs;

/* This method completely clears your navigation stack. Useful at login, logout, etc. */
-(void)clearRootViewControllerThenOpenURLAction:(TTURLAction*)action;
-(void)clearRootViewControllerThenOpenURLAction:(TTURLAction*)action afterDelay:(CGFloat)delay;

-(void)dismissModalViewController:(UIViewController *)viewController thenOpenURLAction:(TTURLAction *)URLAction animated:(BOOL)animated;

// Private
-(void)timedOpenURLAction:(NSTimer *)timer;

/* Fix a warning. This is a private method in TTURLNavigationPattern. */
@interface TTURLMap (CBAdditions)

-(TTURLNavigatorPattern*)matchObjectPattern:(NSURL*)URL;

@end
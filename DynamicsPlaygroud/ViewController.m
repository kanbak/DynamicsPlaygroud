//
//  ViewController.m
//  DynamicsPlaygroud
//
//  Created by Umut Kanbak on 12/12/13.
//  Copyright (c) 2013 Umut Kanbak. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UICollisionBehaviorDelegate>

@end

UIDynamicAnimator* _animator;
UIGravityBehavior* _gravity;
UICollisionBehavior* _collision;

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// create test objects
    UIView* square = [[UIView alloc] initWithFrame: CGRectMake(100, 100, 100, 100)];
    square.backgroundColor = [UIColor grayColor];
    [self.view addSubview:square];
    UIView* barrier = [[UIView alloc]initWithFrame:CGRectMake(0, 300, 130, 20)];
    barrier.backgroundColor = [UIColor redColor];
    [self.view addSubview:barrier];
    _animator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
    // add gravity
    _gravity = [[UIGravityBehavior alloc]initWithItems:@[square]];
    [_animator addBehavior:_gravity];
    // make objects respond to collision
    _collision = [[UICollisionBehavior alloc]initWithItems:@[square]];
    _collision.translatesReferenceBoundsIntoBoundary = YES;
    _collision.collisionDelegate = self;
    [_animator addBehavior:_collision];
    // add boundary coinsides with the top edge
    CGPoint rightEdge = CGPointMake(barrier.frame.origin.x + barrier.frame.size.width, barrier.frame.origin.y);
    [_collision addBoundaryWithIdentifier:@"barrier" fromPoint:barrier.frame.origin toPoint:rightEdge];
    // logs center and transform properties for the falling square
    _collision.action = ^{
        NSLog(@"%@, %@",
              NSStringFromCGAffineTransform(square.transform),
              NSStringFromCGPoint(square.center));
    };
    
    UIDynamicItemBehavior* itemBehavior =
    [[UIDynamicItemBehavior alloc]initWithItems:@[square]];
    itemBehavior.elasticity = 0.6;
    [_animator addBehavior:itemBehavior];
}

/*
 • elasticity – determines how ‘elastic’ collisions will be, i.e. how bouncy or ‘rubbery’ the item behaves in collisions.
 • friction – determines the amount of resistance to movement when sliding along a surface.
 • density – when combined with size, this will give the overall mass of an item. The greater the mass, the harder it is to accelerate or decelerate an object.
 • resistance – determines the amount of resistance to any linear movement. This is in contrast to friction, which only applies to sliding movements.
 • angularResistance - determines the amount of resistance to any rotational movement.
 • allowsRotation – this is an interesting one that doesn’t model any real-world physics property. With this property set to NO the object will not rotate at all, regardless of any rotational forces that occur.
 */


- (void)collisionBehavior:(UICollisionBehavior *)behavior
      beganContactForItem:(id<UIDynamicItem>)item
   withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p
{
    // log the contact
    NSLog(@"Boundary contact occurred - %@", identifier);
    // indicate when contact has occured with color
    UIView* view = (UIView*)item;
    view.backgroundColor = [UIColor yellowColor];
    [UIView animateWithDuration:0.3
                     animations:^{
            view.backgroundColor = [UIColor grayColor];
        }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

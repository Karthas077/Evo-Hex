//
//  EvoViewController.m
//  Evo Hex
//
//  Created by Steven Buell on 6/28/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "EvoViewController.h"
#import "EvoMenuScene.h"

@implementation EvoViewController

- (void)viewWillLayoutSubviews
{
  [super viewWillLayoutSubviews];
  
  // Configure the view.
  SKView * skView = (SKView *)self.view;
  skView.showsDrawCount = YES;
  skView.showsFPS = YES;
  skView.showsNodeCount = YES;
  
  if (!skView.scene) {
    // Create and configure the scene.
    SKScene * scene = [EvoMenuScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
  }
  else {
    skView.scene.size = skView.bounds.size;
  }
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end

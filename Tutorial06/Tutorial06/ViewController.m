//
//  ViewController.m
//  Tutorial06
//
//  Created by Gguomingyue on 2017/11/30.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)segmentSelectionChanged:(UISegmentedControl *)sender {
    [self.openGLView setCurrentSurface:(int)sender.selectedSegmentIndex];
}
@end

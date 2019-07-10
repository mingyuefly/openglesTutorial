//
//  ViewController.m
//  Tutorial05
//
//  Created by Gguomingyue on 2017/11/28.
//  Copyright © 2017年 guomingyue. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)OnShoulderSliderValueChanged:(UISlider *)sender {
    self.openGLView.rotateShoulder = sender.value;
}

- (IBAction)OnElbowSliderValueChanged:(UISlider *)sender {
    self.openGLView.rotateElbow = sender.value;
}

- (IBAction)OnRotateButtonClick:(UIButton *)sender {
    [self.openGLView toggleDisplayLink];
    
    NSString * text = sender.titleLabel.text;
    if ([text isEqualToString:@"Rotate"]) {
        [sender setTitle: @"Stop" forState: UIControlStateNormal];
    }
    else {
        [sender setTitle: @"Rotate" forState: UIControlStateNormal];
    }
}

- (IBAction)OnResetButtonClick:(UIButton *)sender {
    [self.openGLView resetTransform];
}
@end

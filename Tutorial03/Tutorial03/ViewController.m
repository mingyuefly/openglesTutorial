//
//  ViewController.m
//  Tutorial03
//
//  Created by Gguomingyue on 2017/11/23.
//  Copyright © 2017年 guomingyue. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

- (void)resetControls;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self resetControls];
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

- (IBAction)xSliderValueChanged:(UISlider *)sender {
    self.openGLView.posX = sender.value;
}

- (IBAction)ySliderValueChanged:(UISlider *)sender {
    self.openGLView.posY = sender.value;
}

- (IBAction)zSliderValueChanged:(UISlider *)sender {
    self.openGLView.posZ = sender.value;
}

- (IBAction)rotateXSliderValueChanged:(UISlider *)sender {
    self.openGLView.rotateX = sender.value;
}

- (IBAction)scaleZSliderValueChanged:(UISlider *)sender {
    self.openGLView.scaleZ = sender.value;
}

- (IBAction)autoButtonClick:(UIButton *)sender {
    [self.openGLView toggleDisplayLink];
    NSString *text = sender.titleLabel.text;
    if ([text isEqualToString:@"Auto"]) {
        [sender setTitle: @"Stop" forState: UIControlStateNormal];
    }
    else {
        [sender setTitle: @"Auto" forState: UIControlStateNormal];
    }
}

- (IBAction)resetButtonClick:(UIButton *)sender {
    [self.openGLView resetTransform];
    [self.openGLView render];
    
    [self resetControls];
}

- (void)resetControls
{
    [self.posXSlider setValue:self.openGLView.posX];
    [self.posYSlider setValue:self.openGLView.posY];
    [self.posZSlider setValue:self.openGLView.posZ];
    
    [self.scaleZSlider setValue:self.openGLView.scaleZ];
    [self.rotateXSlider setValue:self.openGLView.rotateX];
}
@end

//
//  ViewController.h
//  Tutorial05
//
//  Created by Gguomingyue on 2017/11/28.
//  Copyright © 2017年 guomingyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpenGLView.h"

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet OpenGLView *openGLView;
- (IBAction)OnShoulderSliderValueChanged:(UISlider *)sender;
- (IBAction)OnElbowSliderValueChanged:(UISlider *)sender;
- (IBAction)OnRotateButtonClick:(UIButton *)sender;
- (IBAction)OnResetButtonClick:(UIButton *)sender;

@end


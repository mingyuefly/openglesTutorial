//
//  ViewController.h
//  Tutorial03
//
//  Created by Gguomingyue on 2017/11/23.
//  Copyright © 2017年 guomingyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpenGLView.h"

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *controlView;
@property (weak, nonatomic) IBOutlet OpenGLView *openGLView;
@property (weak, nonatomic) IBOutlet UISlider *posXSlider;
@property (weak, nonatomic) IBOutlet UISlider *posYSlider;
@property (weak, nonatomic) IBOutlet UISlider *posZSlider;
@property (weak, nonatomic) IBOutlet UISlider *rotateXSlider;
@property (weak, nonatomic) IBOutlet UISlider *scaleZSlider;
- (IBAction)xSliderValueChanged:(UISlider *)sender;
- (IBAction)ySliderValueChanged:(UISlider *)sender;
- (IBAction)zSliderValueChanged:(UISlider *)sender;
- (IBAction)rotateXSliderValueChanged:(UISlider *)sender;
- (IBAction)scaleZSliderValueChanged:(UISlider *)sender;
- (IBAction)autoButtonClick:(UIButton *)sender;
- (IBAction)resetButtonClick:(UIButton *)sender;

@end


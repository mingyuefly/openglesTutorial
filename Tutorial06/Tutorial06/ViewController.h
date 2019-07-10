//
//  ViewController.h
//  Tutorial06
//
//  Created by Gguomingyue on 2017/11/30.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpenGLView.h"

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet OpenGLView *openGLView;
- (IBAction)segmentSelectionChanged:(UISegmentedControl *)sender;

@end


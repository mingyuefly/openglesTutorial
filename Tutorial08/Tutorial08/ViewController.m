//
//  ViewController.m
//  Tutorial08
//
//  Created by Gguomingyue on 2018/5/30.
//  Copyright © 2018年 Gmingyue. All rights reserved.
// https://www.cnblogs.com/kesalin/archive/2013/01/11/PerPixelLight-Catoon.html

#import "ViewController.h"
#import "OpenGLView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet OpenGLView *openGLView;

@property (weak, nonatomic) IBOutlet UISlider *lightXSlider;
@property (weak, nonatomic) IBOutlet UISlider *lightYSlider;
@property (weak, nonatomic) IBOutlet UISlider *lightZSlider;
@property (weak, nonatomic) IBOutlet UISlider *diffuseRSlider;
@property (weak, nonatomic) IBOutlet UISlider *diffuseGSlider;
@property (weak, nonatomic) IBOutlet UISlider *diffuseBSlider;
@property (weak, nonatomic) IBOutlet UISlider *ambientRSlider;
@property (weak, nonatomic) IBOutlet UISlider *ambientGSlider;
@property (weak, nonatomic) IBOutlet UISlider *ambientBSlider;
@property (weak, nonatomic) IBOutlet UISlider *specularRSlider;
@property (weak, nonatomic) IBOutlet UISlider *specularGSlider;
@property (weak, nonatomic) IBOutlet UISlider *specularBSlider;
@property (weak, nonatomic) IBOutlet UISlider *shininessSlider;

- (IBAction)lightXSliderValueChanged:(UISlider *)sender;
- (IBAction)lightYSliderValueChanged:(UISlider *)sender;
- (IBAction)lightZSliderValueChanged:(UISlider *)sender;
- (IBAction)diffuseRSliderValueChanged:(id)sender;
- (IBAction)diffuseGSliderValueChanged:(UISlider *)sender;
- (IBAction)diffuseBSliderValueChanged:(UISlider *)sender;
- (IBAction)ambientRSliderValueChanged:(UISlider *)sender;
- (IBAction)ambientGSliderValueChanged:(UISlider *)sender;
- (IBAction)ambientBSliderValueChanged:(UISlider *)sender;
- (IBAction)specularRSliderValueChanged:(UISlider *)sender;
- (IBAction)specularGSliderValueChanged:(UISlider *)sender;
- (IBAction)specularBSliderValueChanged:(UISlider *)sender;
- (IBAction)shininessSliderValueChanged:(UISlider *)sender;

- (IBAction)segmentSelectionChanged:(UISegmentedControl *)sender;
- (IBAction)polygonButtonClicked:(UIButton *)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.lightXSlider.value = self.openGLView.lightPosition.x;
    self.lightYSlider.value = self.openGLView.lightPosition.y;
    self.lightZSlider.value = self.openGLView.lightPosition.z;
    self.diffuseRSlider.value = self.openGLView.diffuse.r;
    self.diffuseGSlider.value = self.openGLView.diffuse.g;
    self.diffuseBSlider.value = self.openGLView.diffuse.b;
    self.ambientRSlider.value = self.openGLView.ambient.r;
    self.ambientGSlider.value = self.openGLView.ambient.g;
    self.ambientBSlider.value = self.openGLView.ambient.b;
    self.specularRSlider.value = self.openGLView.specular.r;
    self.specularGSlider.value = self.openGLView.specular.g;
    self.specularBSlider.value = self.openGLView.specular.b;
    self.shininessSlider.value = self.openGLView.shininess;
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

// light position
- (IBAction)lightXSliderValueChanged:(UISlider *)sender {
    KSVec3 pos = self.openGLView.lightPosition;
    pos.x = sender.value;
    self.openGLView.lightPosition = pos;
}

- (IBAction)lightYSliderValueChanged:(UISlider *)sender {
    KSVec3 pos = self.openGLView.lightPosition;
    pos.y = sender.value;
    self.openGLView.lightPosition = pos;//-0.577350
}

- (IBAction)lightZSliderValueChanged:(UISlider *)sender {
    KSVec3 pos = self.openGLView.lightPosition;
    pos.z = sender.value;
    self.openGLView.lightPosition = pos;
}

// diffuse
- (IBAction)diffuseRSliderValueChanged:(id)sender {
    KSColor color = self.openGLView.diffuse;
    color.r = ((UISlider *)sender).value;
    self.openGLView.diffuse = color;
}

- (IBAction)diffuseGSliderValueChanged:(UISlider *)sender {
    KSColor color = self.openGLView.diffuse;
    color.g = sender.value;
    self.openGLView.diffuse = color;
}

- (IBAction)diffuseBSliderValueChanged:(UISlider *)sender {
    KSColor color = self.openGLView.diffuse;
    color.b = sender.value;
    self.openGLView.diffuse = color;
}

// ambient
- (IBAction)ambientRSliderValueChanged:(UISlider *)sender {
    KSColor color = self.openGLView.ambient;
    color.r = sender.value;
    self.openGLView.ambient = color;
}

- (IBAction)ambientGSliderValueChanged:(UISlider *)sender {
    KSColor color = self.openGLView.ambient;
    color.g = sender.value;
    self.openGLView.ambient = color;
}

- (IBAction)ambientBSliderValueChanged:(UISlider *)sender {
    KSColor color = self.openGLView.ambient;
    color.b = sender.value;
    self.openGLView.ambient = color;
}

// specular
- (IBAction)specularRSliderValueChanged:(UISlider *)sender {
    KSColor color = self.openGLView.specular;
    color.r = sender.value;
    self.openGLView.specular = color;
}

- (IBAction)specularGSliderValueChanged:(UISlider *)sender {
    KSColor color = self.openGLView.specular;
    color.g = sender.value;
    self.openGLView.specular = color;
}

- (IBAction)specularBSliderValueChanged:(UISlider *)sender {
    KSColor color = self.openGLView.specular;
    color.b = sender.value;
    self.openGLView.specular = color;
}

- (IBAction)shininessSliderValueChanged:(UISlider *)sender {
    self.openGLView.shininess = sender.value;
}

- (IBAction)segmentSelectionChanged:(UISegmentedControl *)sender {
    [self.openGLView setCurrentSurface:(int)sender.selectedSegmentIndex];
}

- (IBAction)polygonButtonClicked:(UIButton *)sender {
    NSString *text = sender.titleLabel.text;
    
    if ([text compare:@"Polygon"] == NSOrderedSame) {
        [sender setTitle:@"Off" forState:UIControlStateNormal];
        self.openGLView.enablePolygonOffset = true;
    } else {
        [sender setTitle:@"Polygon" forState:UIControlStateNormal];
        self.openGLView.enablePolygonOffset = false;
    }
}
@end

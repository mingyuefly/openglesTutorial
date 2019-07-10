//
//  OpenGLView.h
//  Tutorial03
//
//  Created by Gguomingyue on 2017/11/23.
//  Copyright © 2017年 guomingyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import "ksMatrix.h"

@interface OpenGLView : UIView
{
    CAEAGLLayer* _eaglLayer;
    EAGLContext* _context;
    GLuint _colorRenderBuffer;
    GLuint _frameBuffer;
    
    GLuint _programHandle;
    GLuint _positionSlot;
    GLint _modelViewSlot;
    GLint _projectionSlot;
    
    ksMatrix4 _modelViewMatrix;  //模型视图变换矩阵
    ksMatrix4 _projectionMatrix;//投影视图变换矩阵
}

@property (nonatomic, assign) float posX;
@property (nonatomic, assign) float posY;
@property (nonatomic, assign) float posZ;

@property (nonatomic, assign) float scaleZ;
@property (nonatomic, assign) float rotateX;

- (void)resetTransform;
- (void)render;
- (void)cleanup;
- (void)toggleDisplayLink;

@end

//
//  OpenGLView.h
//  Tutorial05
//
//  Created by Gguomingyue on 2017/11/28.
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
    GLuint _colorSlot;
    
    ksMatrix4 _modelViewMatrix;
    ksMatrix4 _projectionMatrix;
    
    float _rotateShoulder;
    float _rotateElbow;
}

@property (nonatomic, assign) float rotateShoulder;
@property (nonatomic, assign) float rotateElbow;

- (void)render;
- (void)cleanup;
- (void)toggleDisplayLink;
- (void)resetTransform;

@end

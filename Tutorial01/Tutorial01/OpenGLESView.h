//
//  OpenGLESView.h
//  Tutorial01
//
//  Created by Gguomingyue on 2017/11/21.
//  Copyright © 2017年 guomingyue. All rights reserved.
//  https://blog.csdn.net/kesalin/article/details/8221393

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/ES2/glext.h>
#import <OpenGLES/ES2/gl.h>

@interface OpenGLESView : UIView
{
    CAEAGLLayer* _eaglLayer;
    EAGLContext* _context;
    GLuint _colorRenderBuffer;
    GLuint _frameBuffer;
}

@end

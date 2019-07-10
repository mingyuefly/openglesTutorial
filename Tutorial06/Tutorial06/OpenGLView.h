//
//  OpenGLView.h
//  Tutorial06
//
//  Created by Gguomingyue on 2017/11/30.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import "GLESMath.h"
//#include "GLESMath.h"

@interface DrawableVBO : NSObject
{
    @public
    GLuint vertexBuffer;
}
@property (nonatomic, assign) GLuint vertexBuffer;//顶点数据的顶点缓存对象
@property (nonatomic, assign) GLuint lineIndexBuffer;//索引数据的顶点缓存对象
@property (nonatomic, assign) GLuint triangleIndexBuffer;//索引数据的顶点缓存对象
@property (nonatomic, assign) int vertexSize;
@property (nonatomic, assign) int lineIndexCount;
@property (nonatomic, assign) int triangleIndexCount;

-(void)cleanup;

@end

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
    
    KSMatrix4 _modelViewMatrix;
    KSMatrix4 _projectionMatrix;
}

- (void)render;
- (void)cleanup;

- (void)setCurrentSurface:(int)index;

@end

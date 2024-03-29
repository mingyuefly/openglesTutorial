//
//  OpenGLView.h
//  Tutorial07
//
//  Created by Gguomingyue on 2017/12/5.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import "GLESMath.h"

@interface DrawableVBO: NSObject

@property (nonatomic, assign) GLuint vertexBuffer;
@property (nonatomic, assign) GLuint lineIndexBuffer;
@property (nonatomic, assign) GLuint triangleIndexBuffer;
@property (nonatomic, assign) int vertexSize;
@property (nonatomic, assign) int lineIndexCount;
@property (nonatomic, assign) int triangleIndexCount;

- (void) cleanup;

@end


@interface OpenGLView : UIView
{
    CAEAGLLayer *_eaglLayer;
    EAGLContext *_context;
    
    GLuint _colorRenderBuffer;
    GLuint _depthRenderBuffer;
    GLuint _frameBuffer;
    
    GLuint _programHandle;
    GLuint _positionSlot;
    GLuint _modelViewSlot;
    GLuint _projectionSlot;
    GLuint _normalMatrixSlot;
    GLuint _lightPositionSlot;
    
    GLint _normalSlot;
    GLint _ambientSlot;
    GLint _diffuseSlot;
    GLint _specularSlot;
    GLint _shininessSlot;
    
    KSMatrix4 _modelViewMatrix;
    KSMatrix4 _projectionMatrix;
    
    KSVec3 _lightPosition;
    KSColor _ambient;
    KSColor _diffuse;
    KSColor _specular;
    
    GLfloat _shininess;
    
    Boolean _enablePolygonOffset;
}

-(void)render;
-(void)cleanup;
-(void)setCurrentSurface:(int)index;

@property (nonatomic, assign) KSVec3 lightPosition;
@property (nonatomic, assign) KSColor ambient;
@property (nonatomic, assign) KSColor diffuse;
@property (nonatomic, assign) KSColor specular;
@property (nonatomic, assign) GLfloat shininess;

@property (nonatomic, assign) Boolean enablePolygonOffset;

@end

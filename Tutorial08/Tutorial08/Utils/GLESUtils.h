//
//  GLESUtils.h
//  Tutorial03
//
//  Created by Gguomingyue on 2017/11/23.
//  Copyright © 2017年 guomingyue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES2/gl.h>

@interface GLESUtils : NSObject

+(GLuint)loadShader:(GLenum)type withString:(NSString *)shaderString;
+(GLuint)loadShader:(GLenum)type withFilepath:(NSString *)shaderFilepath;
+(GLuint)loadProgram:(NSString *)vertexShaderFilepath withFragmentShaderFilepath:(NSString *)fragmentShaderFilepath;

@end

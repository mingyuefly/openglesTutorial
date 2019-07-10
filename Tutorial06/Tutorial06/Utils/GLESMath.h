//
//  GLESMath.h
//  Tutorial06
//
//  Created by Gguomingyue on 2017/12/1.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#ifndef GLESMath_h
#define GLESMath_h

#import <OpenGLES/ES2/gl.h>
#include <stdio.h>
#include <math.h>

#ifndef M_PI
#define M_PI 3.1415926535897932384626433832795f
#endif

#define DEG2RAD( a ) (((a) * M_PI) / 180.0f)
#define RAD2DEG( a ) (((a) * 180.f) / M_PI)

// angle indexes
#define    PITCH              0        // up / down
#define    YAW                1        // left / right
#define    ROLL               2        // fall over

typedef unsigned char         byte;

typedef struct
{
    float m[3][3];
}KSMatrix3;

typedef struct
{
    float   m[4][4];
}KSMatrix4;

typedef struct KSVec3 {
    GLfloat x;
    GLfloat y;
    GLfloat z;
}KSVec3;

typedef struct KSVec4 {
    GLfloat x;
    GLfloat y;
    GLfloat z;
    GLfloat w;
}KSVec4;

typedef struct {
    GLfloat r;
    GLfloat g;
    GLfloat b;
    GLfloat a;
}KSColor;


#ifdef __cplusplus
extern "C" {// 表示这是一个在c++中使用的c文件，告诉编译器要以c的方式来重载
#endif
unsigned int ksNextPot(unsigned int n);

void ksCopyMatrix4(KSMatrix4 * target, const KSMatrix4 * src);

void ksMatrix4ToMatrix3(KSMatrix3 * target, const KSMatrix4 * src);

/// multiply matrix specified by result with a scaling matrix and return new matrix in result
/// result Specifies the input matrix.  Scaled matrix is returned in result.
/// sx, sy, sz Scale factors along the x, y and z axes respectively
//
void ksScale(KSMatrix4 * result, float sx, float sy, float sz);

/// multiply matrix specified by result with a translation matrix and return new matrix in result
/// result Specifies the input matrix.  Translated matrix is returned in result.
/// tx, ty, tz Scale factors along the x, y and z axes respectively
//
void ksTranslate(KSMatrix4 * result, float tx, float ty, float tz);

//
/// multiply matrix specified by result with a rotation matrix and return new matrix in result
/// result Specifies the input matrix.  Rotated matrix is returned in result.
/// angle Specifies the angle of rotation, in degrees.
/// x, y, z Specify the x, y and z coordinates of a vector, respectively
//
void ksRotate(KSMatrix4 * result, float angle, float x, float y, float z);

/// perform the following operation - result matrix = srcA matrix * srcB matrix
/// result Returns multiplied matrix
/// srcA, srcB Input matrices to be multiplied
//
void ksMatrixMultiply(KSMatrix4 * result, const KSMatrix4 *srcA, const KSMatrix4 *srcB);

//
//// return an identity matrix
//// result returns identity matrix
//
void ksMatrixLoadIdentity(KSMatrix4 * result);

//
/// multiply matrix specified by result with a perspective matrix and return new matrix in result
/// result Specifies the input matrix.  new matrix is returned in result.
/// fovy Field of view y angle in degrees
/// aspect Aspect ratio of screen
/// nearZ Near plane distance
/// farZ Far plane distance
//
void ksPerspective(KSMatrix4 * result, float fovy, float aspect, float nearZ, float farZ);

//
/// multiply matrix specified by result with a perspective matrix and return new matrix in result
/// result Specifies the input matrix.  new matrix is returned in result.
/// left, right Coordinates for the left and right vertical clipping planes
/// bottom, top Coordinates for the bottom and top horizontal clipping planes
/// nearZ, farZ Distances to the near and far depth clipping planes.  These values are negative if plane is behind the viewer
//
void ksOrtho(KSMatrix4 * result, float left, float right, float bottom, float top, float nearZ, float farZ);

// multiply matrix specified by result with a perspective matrix and return new matrix in result
/// result Specifies the input matrix.  new matrix is returned in result.
/// left, right Coordinates for the left and right vertical clipping planes
/// bottom, top Coordinates for the bottom and top horizontal clipping planes
/// nearZ, farZ Distances to the near and far depth clipping planes.  Both distances must be positive.
//
void ksFrustum(KSMatrix4 * result, float left, float right, float bottom, float top, float nearZ, float farZ);
    
#ifdef __cplusplus
}
#endif

#endif /* GLESMath_h */

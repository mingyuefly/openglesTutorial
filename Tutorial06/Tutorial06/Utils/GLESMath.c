//
//  GLESMath.c
//  Tutorial06
//
//  Created by Gguomingyue on 2017/12/1.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#include "GLESMath.h"
#include <math.h>

void * memcpy(void *, const void *, size_t);
void * memset(void *, int, size_t);

unsigned int ksNextPot(unsigned int n)
{
    n--;
    n |= n >> 1; n |= n >> 2;
    n |= n >> 4; n |= n >> 8;
    n |= n >> 16;
    n++;
    return n;
}

// Matrix math utility
void ksScale(KSMatrix4 * result, float sx, float sy, float sz)
{
    result->m[0][0] *= sx;
    result->m[0][1] *= sx;
    result->m[0][2] *= sx;
    result->m[0][3] *= sx;
    
    result->m[1][0] *= sy;
    result->m[1][1] *= sy;
    result->m[1][2] *= sy;
    result->m[1][3] *= sy;
    
    result->m[2][0] *= sz;
    result->m[2][1] *= sz;
    result->m[2][2] *= sz;
    result->m[2][3] *= sz;
}

void ksTranslate(KSMatrix4 * result, float tx, float ty, float tz)
{
    result->m[3][0] += (result->m[0][0] * tx + result->m[1][0] * ty + result->m[2][0] * tz);
    result->m[3][1] += (result->m[0][1] * tx + result->m[1][1] * ty + result->m[2][1] * tz);
    result->m[3][2] += (result->m[0][2] * tx + result->m[1][2] * ty + result->m[2][2] * tz);
    result->m[3][3] += (result->m[0][3] * tx + result->m[1][3] * ty + result->m[2][3] * tz);
}

void ksRotate(KSMatrix4 * result, float angle, float x, float y, float z)
{
    float sinAngle, cosAngle;
    float mag = sqrtf(x * x + y * y + z * z);
    
    sinAngle = sinf ( angle * M_PI / 180.0f );
    cosAngle = cosf ( angle * M_PI / 180.0f );
    if ( mag > 0.0f )
    {
        float xx, yy, zz, xy, yz, zx, xs, ys, zs;
        float oneMinusCos;
        KSMatrix4 rotMat;
        
        x /= mag;
        y /= mag;
        z /= mag;
        
        xx = x * x;
        yy = y * y;
        zz = z * z;
        xy = x * y;
        yz = y * z;
        zx = z * x;
        xs = x * sinAngle;
        ys = y * sinAngle;
        zs = z * sinAngle;
        oneMinusCos = 1.0f - cosAngle;
        
        rotMat.m[0][0] = (oneMinusCos * xx) + cosAngle;
        rotMat.m[0][1] = (oneMinusCos * xy) - zs;
        rotMat.m[0][2] = (oneMinusCos * zx) + ys;
        rotMat.m[0][3] = 0.0F;
        
        rotMat.m[1][0] = (oneMinusCos * xy) + zs;
        rotMat.m[1][1] = (oneMinusCos * yy) + cosAngle;
        rotMat.m[1][2] = (oneMinusCos * yz) - xs;
        rotMat.m[1][3] = 0.0F;
        
        rotMat.m[2][0] = (oneMinusCos * zx) - ys;
        rotMat.m[2][1] = (oneMinusCos * yz) + xs;
        rotMat.m[2][2] = (oneMinusCos * zz) + cosAngle;
        rotMat.m[2][3] = 0.0F;
        
        rotMat.m[3][0] = 0.0F;
        rotMat.m[3][1] = 0.0F;
        rotMat.m[3][2] = 0.0F;
        rotMat.m[3][3] = 1.0F;
        
        ksMatrixMultiply( result, &rotMat, result );
    }
}

// result[x][y] = a[x][0]*b[0][y]+a[x][1]*b[1][y]+a[x][2]*b[2][y]+a[x][3]*b[3][y];
void ksMatrixMultiply(KSMatrix4 * result, const KSMatrix4 *a, const KSMatrix4 *b)
{
    KSMatrix4 tmp;
    int i;
    
    for (i = 0; i < 4; i++)
    {
        tmp.m[i][0] = (a->m[i][0] * b->m[0][0]) +
        (a->m[i][1] * b->m[1][0]) +
        (a->m[i][2] * b->m[2][0]) +
        (a->m[i][3] * b->m[3][0]) ;
        
        tmp.m[i][1] = (a->m[i][0] * b->m[0][1]) +
        (a->m[i][1] * b->m[1][1]) +
        (a->m[i][2] * b->m[2][1]) +
        (a->m[i][3] * b->m[3][1]) ;
        
        tmp.m[i][2] = (a->m[i][0] * b->m[0][2]) +
        (a->m[i][1] * b->m[1][2]) +
        (a->m[i][2] * b->m[2][2]) +
        (a->m[i][3] * b->m[3][2]) ;
        
        tmp.m[i][3] = (a->m[i][0] * b->m[0][3]) +
        (a->m[i][1] * b->m[1][3]) +
        (a->m[i][2] * b->m[2][3]) +
        (a->m[i][3] * b->m[3][3]) ;
    }
    
    memcpy(result, &tmp, sizeof(KSMatrix4));
}

void ksCopyMatrix4(KSMatrix4 * target, const KSMatrix4 * src)
{
    memcpy(target, src, sizeof(KSMatrix4));
}

void ksMatrix4ToMatrix3(KSMatrix3 * result, const KSMatrix4 * src)
{
    result->m[0][0] = src->m[0][0];
    result->m[0][1] = src->m[0][1];
    result->m[0][2] = src->m[0][2];
    result->m[1][0] = src->m[1][0];
    result->m[1][1] = src->m[1][1];
    result->m[1][2] = src->m[1][2];
    result->m[2][0] = src->m[2][0];
    result->m[2][1] = src->m[2][1];
    result->m[2][2] = src->m[2][2];
}

void ksMatrixLoadIdentity(KSMatrix4 * result)
{
    memset(result, 0x0, sizeof(KSMatrix4));
    
    result->m[0][0] = 1.0f;
    result->m[1][1] = 1.0f;
    result->m[2][2] = 1.0f;
    result->m[3][3] = 1.0f;
}

void ksFrustum(KSMatrix4 * result, float left, float right, float bottom, float top, float nearZ, float farZ)
{
    float       deltaX = right - left;
    float       deltaY = top - bottom;
    float       deltaZ = farZ - nearZ;
    KSMatrix4    frust;
    
    if ( (nearZ <= 0.0f) || (farZ <= 0.0f) ||
        (deltaX <= 0.0f) || (deltaY <= 0.0f) || (deltaZ <= 0.0f) )
        return;
    
    frust.m[0][0] = 2.0f * nearZ / deltaX;
    frust.m[0][1] = frust.m[0][2] = frust.m[0][3] = 0.0f;
    
    frust.m[1][1] = 2.0f * nearZ / deltaY;
    frust.m[1][0] = frust.m[1][2] = frust.m[1][3] = 0.0f;
    
    frust.m[2][0] = (right + left) / deltaX;
    frust.m[2][1] = (top + bottom) / deltaY;
    frust.m[2][2] = -(nearZ + farZ) / deltaZ;
    frust.m[2][3] = -1.0f;
    
    frust.m[3][2] = -2.0f * nearZ * farZ / deltaZ;
    frust.m[3][0] = frust.m[3][1] = frust.m[3][3] = 0.0f;
    
    ksMatrixMultiply(result, &frust, result);
}

void ksPerspective(KSMatrix4 * result, float fovy, float aspect, float nearZ, float farZ)
{
    float frustumW, frustumH;
    
    frustumH = tanf( fovy / 360.0f * M_PI ) * nearZ;
    frustumW = frustumH * aspect;
    
    ksFrustum(result, -frustumW, frustumW, -frustumH, frustumH, nearZ, farZ);
}

void ksOrtho(KSMatrix4 * result, float left, float right, float bottom, float top, float nearZ, float farZ)
{
    float       deltaX = right - left;
    float       deltaY = top - bottom;
    float       deltaZ = farZ - nearZ;
    KSMatrix4    ortho;
    
    if ((deltaX == 0.0f) || (deltaY == 0.0f) || (deltaZ == 0.0f))
        return;
    
    ksMatrixLoadIdentity(&ortho);
    ortho.m[0][0] = 2.0f / deltaX;
    ortho.m[3][0] = -(right + left) / deltaX;
    ortho.m[1][1] = 2.0f / deltaY;
    ortho.m[3][1] = -(top + bottom) / deltaY;
    ortho.m[2][2] = -2.0f / deltaZ;
    ortho.m[3][2] = -(nearZ + farZ) / deltaZ;
    
    ksMatrixMultiply(result, &ortho, result);
}


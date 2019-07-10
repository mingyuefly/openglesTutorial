//
//  ksVector.h
//  Tutorial03
//
//  Created by Gguomingyue on 2017/11/23.
//  Copyright © 2017年 guomingyue. All rights reserved.
//

#ifndef ksVector_h
#define ksVector_h

#include <stdio.h>

typedef struct
{
    float x;
    float y;
    float z;
} ksVec3;

typedef struct
{
    float x;
    float y;
    float z;
    float w;
} ksVec4;

typedef struct
{
    float r;
    float g;
    float b;
    float a;
} ksColor;

typedef unsigned char byte;

void ksVectorCopy(ksVec3 * out, const ksVec3 * in);
void ksVectorAdd(ksVec3 * out, const ksVec3 * a, const ksVec3 * b);
void ksVectorSubtract(ksVec3 * out, const ksVec3 * a, const ksVec3 * b);
void ksVectorLerp(ksVec3 * out, const ksVec3 * a, const ksVec3 * b, float t);
void ksCrossProduct(ksVec3 * out, const ksVec3 * a, const ksVec3 * b);
float ksDotProduct(const ksVec3 * a, const ksVec3 * b);

float ksVectorLengthSquared(const ksVec3 * in);
float ksVectorDistanceSquared(const ksVec3 * a, const ksVec3 * b);

void ksVectorScale(ksVec3 * v, float scale);
void ksVectorNormalize(ksVec3 * v);
void ksVectorInverse(ksVec3 * v);

int ksVectorCompare(const ksVec3 * a, const ksVec3 * b);
float ksVectorLength(const ksVec3 * in);
float ksVectorDistance(const ksVec3 * a, const ksVec3 * b);

#endif /* ksVector_h */

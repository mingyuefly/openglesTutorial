
//
uniform mat4 projection;
uniform mat4 modelView;
attribute vec4 vPosition;

uniform mat3 normalMatrix;
attribute vec3 vNormal;

uniform vec3 vLightPosition;
uniform vec3 vAmbientMaterial;
uniform vec3 vSpecularMaterial;
attribute vec3 vDiffuseMaterial;
uniform float shininess;

varying vec4 vDestinationColor;

void main(void)
{
    gl_Position = projection * modelView * vPosition;
    
    // vNormal为传入的顶点法线坐标，normalMatrix为法线仿射变换矩阵，同modelView（无齐次坐标）
    vec3 N = normalMatrix * vNormal;
    vec3 L = normalize(vLightPosition);//光线转换为单位矩阵
    vec3 E = vec3(0, 0, 1);
    vec3 H = normalize(L + E);
    
    float df = max(0.0, dot(N, L));
    float sf = max(0.0, dot(N, H));
    sf = pow(sf, shininess);// sf的shininess次方
    
    vec3 color = vAmbientMaterial + df * vDiffuseMaterial + sf * vSpecularMaterial;
    vDestinationColor = vec4(color, 1);
}

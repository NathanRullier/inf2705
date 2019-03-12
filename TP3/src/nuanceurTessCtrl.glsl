// ==> Les variables en commentaires ci-dessous sont déclarées implicitement:
// in int gl_PatchVerticesIn;
// in int gl_PrimitiveID;
// in int gl_InvocationID;
// in gl_PerVertex
// {
//   vec4 gl_Position;
//   float gl_PointSize;
//   float gl_ClipDistance[];
// } gl_in[gl_MaxPatchVertices];

// patch out float gl_TessLevelOuter[4];
// patch out float gl_TessLevelInner[2];
// out gl_PerVertex
// {
//   vec4 gl_Position;
//   float gl_PointSize;
//   float gl_ClipDistance[];
// } gl_out[];
#version 410
layout(vertices = 4) out;

uniform float TessLevelInner;
uniform float TessLevelOuter;

in Attribs {
    vec4 couleur;
    vec3 N;
    vec3 L[3];
    vec3 O;
    vec4 TexCoord;
} AttribsIn[];

out Attribs {
    vec4 couleur;
    vec3 N;
    vec3 L[3];
    vec3 O;
    vec4 TexCoord;
} AttribsOut[];

void main()
{
    gl_out[gl_InvocationID].gl_Position = gl_in[gl_InvocationID].gl_Position;

    if ( gl_InvocationID == 0 )
    {
        gl_TessLevelInner[0] = TessLevelInner;
        gl_TessLevelInner[1] = TessLevelInner;
        gl_TessLevelOuter[0] = TessLevelOuter;
        gl_TessLevelOuter[1] = TessLevelOuter;
        gl_TessLevelOuter[2] = TessLevelOuter;
        gl_TessLevelOuter[3] = TessLevelOuter; 
    }

    AttribsOut[gl_InvocationID].couleur = AttribsIn[gl_InvocationID].couleur;
    AttribsOut[gl_InvocationID].N = AttribsIn[gl_InvocationID].N;
    AttribsOut[gl_InvocationID].L = AttribsIn[gl_InvocationID].L;
    AttribsOut[gl_InvocationID].O = AttribsIn[gl_InvocationID].O;
    AttribsOut[gl_InvocationID].TexCoord = AttribsIn[gl_InvocationID].TexCoord;
}
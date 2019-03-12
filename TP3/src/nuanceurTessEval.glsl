// ==> Les variables en commentaires ci-dessous sont déclarées implicitement:
// in vec3 gl_TessCoord;
// in int gl_PatchVerticesIn;
// in int gl_PrimitiveID;
// patch in float gl_TessLevelOuter[4];
// patch in float gl_TessLevelInner[2];
// in gl_PerVertex
// {
//   vec4 gl_Position;
//   float gl_PointSize;
//   float gl_ClipDistance[];
// } gl_in[gl_MaxPatchVertices];

// out gl_PerVertex
// {
//   vec4 gl_Position;
//   float gl_PointSize;
//   float gl_ClipDistance[];
// };
#version 410
layout(quads) in;

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
} AttribsOut;

float interpole( float v0, float v1, float v2, float v3 )
{
    // mix( x, y, f ) = x * (1-f) + y * f.
    float v01 = mix( v0, v1, gl_TessCoord.x );
    float v32 = mix( v3, v2, gl_TessCoord.x );
    return mix( v01, v32, gl_TessCoord.y );
}
vec2 interpole( vec2 v0, vec2 v1, vec2 v2, vec2 v3 )
{
    // mix( x, y, f ) = x * (1-f) + y * f.
    vec2 v01 = mix( v0, v1, gl_TessCoord.x );
    vec2 v32 = mix( v3, v2, gl_TessCoord.x );
    return mix( v01, v32, gl_TessCoord.y );
}
vec3 interpole( vec3 v0, vec3 v1, vec3 v2, vec3 v3 )
{
    // mix( x, y, f ) = x * (1-f) + y * f.
    vec3 v01 = mix( v0, v1, gl_TessCoord.x );
    vec3 v32 = mix( v3, v2, gl_TessCoord.x );
    return mix( v01, v32, gl_TessCoord.y );
}
vec4 interpole( vec4 v0, vec4 v1, vec4 v2, vec4 v3 )
{
    // mix( x, y, f ) = x * (1-f) + y * f.
    vec4 v01 = mix( v0, v1, gl_TessCoord.x );
    vec4 v32 = mix( v3, v2, gl_TessCoord.x );
    return mix( v01, v32, gl_TessCoord.y );
}

void main()
{
    gl_Position = interpole( gl_in[0].gl_Position, gl_in[1].gl_Position, gl_in[2].gl_Position, gl_in[3].gl_Position );
    // gl_Position.z = 1.0 - length( gl_Position.xy );
    // gl_Position.xyz = normalize( gl_Position.xyz );
    AttribsOut.couleur = interpole( AttribsIn[0].couleur, AttribsIn[1].couleur, AttribsIn[2].couleur, AttribsIn[3].couleur );
    AttribsOut.N = interpole( AttribsIn[0].N, AttribsIn[1].N, AttribsIn[2].N, AttribsIn[3].N );
    AttribsOut.L[0] = interpole( AttribsIn[0].L[0], AttribsIn[1].L[0], AttribsIn[2].L[0], AttribsIn[3].L[0] );
    AttribsOut.L[1] = interpole( AttribsIn[0].L[1], AttribsIn[1].L[1], AttribsIn[2].L[1], AttribsIn[3].L[1] );
    AttribsOut.L[2] = interpole( AttribsIn[0].L[2], AttribsIn[1].L[2], AttribsIn[2].L[2], AttribsIn[3].L[2] );
    AttribsOut.O = interpole( AttribsIn[0].O, AttribsIn[1].O, AttribsIn[2].O, AttribsIn[3].O );
    AttribsOut.TexCoord = interpole( AttribsIn[0].TexCoord, AttribsIn[1].TexCoord, AttribsIn[2].TexCoord, AttribsIn[3].TexCoord );
}
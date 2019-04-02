#version 410

layout(points) in;
layout(triangle_strip, max_vertices = 4) out;
//layout(points, max_vertices = 1) out;

in Attribs {
    vec4 couleur;
    float tempsDeVieRestant;
    //float sens; // du vol
} AttribsIn[];

out Attribs {
    vec2 texCoord;
    vec4 couleur;
} AttribsOut;

uniform mat4 matrProj;
uniform int texnumero;

void main()
{
    vec2 coins[4];
    coins[0] = vec2( -0.5,  0.5 );
    coins[1] = vec2( -0.5, -0.5 );
    coins[2] = vec2(  0.5,  0.5 );
    coins[3] = vec2(  0.5, -0.5 );
    for ( int i = 0 ; i < 4 ; ++i ) {

        float fact = gl_in[0].gl_PointSize / 50;
        vec2 decalage = coins[i]; // on positionne successivement aux quatre coins
        vec4 pos = vec4( gl_in[0].gl_Position.xy + fact * decalage, gl_in[0].gl_Position.zw );
        gl_Position = matrProj * pos;    // on termine la transformation débutée dans le nuanceur de sommets

        if (texnumero == 1)
        {
            float angle = 6.0f*AttribsIn[0].tempsDeVieRestant;
            mat2 trans = mat2(cos(angle),-sin(angle),sin(angle),cos(angle));
            coins[i] = coins[i]*trans;
        }

        // assigner la taille des points (en pixels)
        gl_PointSize = fact;

        AttribsOut.texCoord =  coins[i] + vec2(0.5,0.5);

        // assigner la couleur courante
        AttribsOut.couleur = AttribsIn[0].couleur;

        EmitVertex();
    }

}

#version 410

// Définition des paramètres des sources de lumière
layout (std140) uniform LightSourceParameters
{
    vec4 ambient;
    vec4 diffuse;
    vec4 specular;
    vec4 position[3];      // dans le repère du monde
    float constantAttenuation;
    float linearAttenuation;
    float quadraticAttenuation;
} LightSource;

// Définition des paramètres des matériaux
layout (std140) uniform MaterialParameters
{
    vec4 emission;
    vec4 ambient;
    vec4 diffuse;
    vec4 specular;
    float shininess;
} FrontMaterial;

// Définition des paramètres globaux du modèle de lumière
layout (std140) uniform LightModelParameters
{
    vec4 ambient;       // couleur ambiante
    bool localViewer;   // observateur local ou à l'infini?
    bool twoSide;       // éclairage sur les deux côtés ou un seul?
} LightModel;

layout (std140) uniform varsUnif
{
    // partie 1: illumination
    int typeIllumination;     // 0:Gouraud, 1:Phong
    bool utiliseBlinn;        // indique si on veut utiliser modèle spéculaire de Blinn ou Phong
    bool afficheNormales;     // indique si on utilise les normales comme couleurs (utile pour le débogage)
    // partie 2: texture
    int numTexCoul;           // numéro de la texture de couleurs appliquée
    int numTexNorm;           // numéro de la texture de normales appliquée
    bool utiliseCouleur;      // doit-on utiliser la couleur de base de l'objet en plus de celle de la texture?
    int afficheTexelFonce;    // un texel foncé doit-il être affiché 0:normalement, 1:mi-coloré, 2:transparent?
};

uniform mat4 matrModel;
uniform mat4 matrVisu;
uniform mat4 matrProj;
uniform mat3 matrNormale;

/////////////////////////////////////////////////////////////////

layout(location=0) in vec4 Vertex;
layout(location=2) in vec3 Normal;
layout(location=3) in vec4 Color;
layout(location=8) in vec4 TexCoord;

out Attribs {
    vec4 couleur;
    vec3 N;
    vec3 L[3];
    vec3 O;
    vec4 TexCoord;
} AttribsOut;

vec4 calculerReflexion( in vec3 L, in vec3 N, in vec3 O )
{
    vec4 grisUniforme = vec4(0.7,0.7,0.7,1.0);
    return( grisUniforme );
}

void main( void )
{
    // transformation standard du sommet
    gl_Position = matrProj * matrVisu * matrModel * Vertex;
    AttribsOut.TexCoord = TexCoord;

    vec3 N = normalize( matrNormale * Normal );
    AttribsOut.N = matrNormale * Normal;
    vec3 pos = ( matrVisu * matrModel * Vertex ).xyz;
    vec3 O = normalize(-pos); // vecteur qui pointe vers le (0,0,0), c'est-à-dire vers la caméra
    AttribsOut.O = O;
    AttribsOut.couleur = FrontMaterial.emission + FrontMaterial.ambient * LightModel.ambient;
    //Gouraud
    if (typeIllumination == 0 ) {
        vec3 halfV;
        vec3 L;
        float NdotL;
        float NdotHV;
        for(int i = 0; i < 3; i++) {
            L = normalize(((matrVisu * LightSource.position[i]).xyz) - pos);
            // composante diffuse 
            NdotL = max(0.0, dot(N,L));
            AttribsOut.couleur += FrontMaterial.diffuse * LightSource.diffuse * NdotL;

            // composante spéculaire
            if (utiliseBlinn){
                halfV = normalize(vec3(O + L));
                NdotHV = max( dot(N,halfV), 0.0 );
            } else {
                NdotHV = max(0.0, dot(reflect(-L, N), O));
            }
            AttribsOut.couleur += FrontMaterial.specular * LightSource.specular * pow(NdotHV, FrontMaterial.shininess);

            // composante ambiante
            AttribsOut.couleur += FrontMaterial.ambient * LightSource.ambient;
        }
    } 
      
    for(int i = 0; i < 3; i++){
        AttribsOut.L[i] = normalize(((matrVisu * LightSource.position[i]).xyz) - pos);
    }
    


    // couleur du sommet
    //AttribsOut.couleur = calculerReflexion( L, N, O );
}

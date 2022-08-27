Shader "Custom/Aula2Shader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _X ("Size X",Float) = 1.0
        _Y ("Size Y",Float) = 1.0
    }
    SubShader
    {   
        Pass
        {
            CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                float4 _Color;
                float _X;
                float _Y;

                float4 vert(float4 vertexPos:POSITION) :SV_POSITION
                {
                    return UnityObjectToClipPos(float4(_X,_Y,1,1)*
                    vertexPos);
                }
                float4 frag() :Color
                {
                    return _Color;
                }
            ENDCG
        }    
    }
    FallBack "Diffuse"
}

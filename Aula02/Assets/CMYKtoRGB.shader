Shader "Custom/CMYKtoRGB"
{
    Properties
    {
        _C ("C", Float) = 1.0
        _M ("M", Float) = 1.0
        _Y ("Y", Float) = 1.0
        _K ("K", Float) = 1.0
    }
    SubShader
    {
        Pass {
            CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag

                float _C, _M, _Y, _K, _Alpha;

                float CYMKToRGB(float color) {
                    return 1.0 * (1 - color / 1.0) * (1 - _K / 1.0);
                }

                float4 vert(float4 vertexP:POSITION): SV_POSITION {
                    return UnityObjectToClipPos(vertexP);
                }

                float4 frag(): Color {
                    float r = CYMKToRGB(_C);
                    float g = CYMKToRGB(_M);
                    float b = CYMKToRGB(_Y);

                    return float4(r, g, b, _K);
                }
            ENDCG
        }
    }
    FallBack "Diffuse"
}

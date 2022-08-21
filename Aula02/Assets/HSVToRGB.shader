Shader "Custom/HSVToRGB"
{
    Properties
    {
        _H ("Hue", Float)        = 1.0
        _S ("Saturation", Float) = 1.0
        _V ("Value", Float)      = 1.0
    }
    SubShader
    {
        Pass {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            float _H, _S, _V;

            float3 HSVtoRGB(float h, float s, float v) {
                if (s == 0) {
                    return float3(v, v, v);
                }

                float Hi = (h / 60.0) % 6.0;
                float f = (h / 60.0) - Hi;
                float p = v * (1.0 - s);
                float q = v * (1.0 - f * s);
                float t = v * (1 - (1 - f) * s);

                switch (Hi) {
                    case 0:
                        return float3(v, t, p);
                    case 1:
                        return float3(q, v, p);
                    case 2:
                        return float3(p, v, t);
                    case 3:
                        return float3(p, q, v);
                    case 4:
                        return float3(t, p, v);
                    case 5:
                        return float3(v, p, q);
                    default:
                        return float3(0.0, 0.0, 0.0);
                }
            }

            float4 vert(float4 vertexP: POSITION): SV_POSITION {
                return UnityObjectToClipPos(vertexP);
            }

            float3 frag(): Color {
                return HSVtoRGB(_H, _S, _V);
            }

            ENDCG
        }
    }
    FallBack "Diffuse"
}

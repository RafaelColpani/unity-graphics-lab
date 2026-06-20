Shader "Custom/Fundamentals/Unlit/Lerp"
{
    Properties
    {
        [MainColor] _BaseColor01("Color 01", Color) = (1, 0, 0, 1)
        [MainColor] _BaseColor02("Color 02", Color) = (0, 0, 1, 1)
        [Space(10)]
        _LerpBlend("Lerp Blend", Range(0, 1)) = 0
    }

    SubShader
    {
        Tags
        {
            "RenderType" = "Opaque"
            "RenderPipeline" = "UniversalPipeline"
        }

        Pass
        {
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            struct Attributes
            {
                float4 positionOS : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct Varyings
            {
                float4 positionHCS : SV_POSITION;
                float2 uv : TEXCOORD0;
            };
            
            CBUFFER_START(UnityPerMaterial)
                half4 _BaseColor01;
                half4 _BaseColor02;
                half _LerpBlend;
            CBUFFER_END

            Varyings vert(Attributes IN)
            {
                Varyings OUT;

                OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);
                OUT.uv = IN.uv;
                
                return OUT;
            }


            half4 frag(Varyings IN) : SV_Target
            {
                half4 color = lerp(_BaseColor01,_BaseColor02,_LerpBlend);

                return color;
            }
            ENDHLSL
        }
    }
}
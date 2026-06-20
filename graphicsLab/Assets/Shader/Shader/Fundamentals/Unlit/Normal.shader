Shader "Custom/Fundamentals/Unlit/Normal"
{
    Properties
    {
        [Toggle] _VisualizeNormal("Visualize Normal", Float) = 0
        [NormalTexture] _NormalMap("Normal Map", 2D) = "bump" {}
        _NormalIntensity("Normal Intensity", Float) = 0
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
                float3 normalOS   : NORMAL;
                float2 uv         : TEXCOORD0;
            };

            struct Varyings
            {
                float4 positionHCS : SV_POSITION;
                float3 normalWS    : TEXCOORD0;
                float2 uvNormal    : TEXCOORD1;
            };
            
            TEXTURE2D(_NormalMap);
            SAMPLER(sampler_NormalMap);

            CBUFFER_START(UnityPerMaterial)
            
                float4 _NormalMap_ST;

                half _VisualizeNormal;
                half _NormalIntensity;
            CBUFFER_END

            Varyings vert(Attributes IN)
            {
                Varyings OUT;

                OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);
                OUT.normalWS = TransformObjectToWorldNormal(IN.normalOS);
                OUT.uvNormal = TRANSFORM_TEX(IN.uv, _NormalMap);

                return OUT;
            }

            half4 frag(Varyings IN) : SV_Target
            {
                // Mesh normal visualization
                float3 meshNormal = normalize(IN.normalWS);
                float3 meshNormalColor = meshNormal * 0.5 + 0.5;

                // Normal map visualization
                float3 normalTS = UnpackNormal(SAMPLE_TEXTURE2D(_NormalMap, sampler_NormalMap, IN.uvNormal)) * _NormalIntensity;
                float3 normalMapColor = normalTS * 0.5 + 0.5;

                if (_VisualizeNormal > 0.5)
                {
                    return half4(meshNormalColor, 1);
                }

                return half4(normalMapColor, 1);
            }

            ENDHLSL
        }
    }
}
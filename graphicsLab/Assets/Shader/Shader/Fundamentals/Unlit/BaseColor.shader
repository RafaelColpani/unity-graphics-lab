Shader "Custom/Fundamentals/Unlit/BaseColor"
{
	Properties
	{
		[MainColor] _BaseColor("Base Color", Color) = (1,1,1,1) //White RGBA
	}

	SubShader
	{
		Tags
		{
			"RenderPipeline" = "UniversalPipeline"
            "RenderType" = "Opaque"
		}

		Pass 
		{
			Name "Forward"
			
			HLSLPROGRAM

			#pragma vertex Vert
			#pragma fragment Frag

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

			//============================
			//Vertex Input
			//============================

			struct Attributes
			{
				float4 positionOS : POSITION;
				float2 uv		  : TEXCOORD0;
			};

			//===========================
			//Vertex To Fragment
			//===========================

			struct Varyings
			{
				float4 positionHCS : SV_POSITION;
				float2 uv		   : TEXCOORD0;
			};

			//==========================
			//Material Resources
			//==========================

			CBUFFER_START(UnityPerMaterial)
				half4 _BaseColor;
			CBUFFER_END

			//==========================
			//Vertex Shader
			//==========================

			Varyings Vert(Attributes IN)
			{
					Varyings OUT;

					OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);
					OUT.uv = IN.uv;
					
					return OUT;
			}

			//==========================
			//Frag Shader 
			//==========================

			half4 Frag(Varyings IN) : SV_Target
			{
				half4 color = _BaseColor;
				return color;
			}

			ENDHLSL
		}
	}
}
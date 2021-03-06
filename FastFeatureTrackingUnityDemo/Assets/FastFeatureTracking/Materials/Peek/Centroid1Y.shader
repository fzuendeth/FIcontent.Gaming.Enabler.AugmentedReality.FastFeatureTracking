Shader "Custom/Centroid1Y" {
	Properties {
		_MainTex ("Base (RG)", 2D) = "white" {}
		_Color ("Reference (RGB)", Color) = (0,0,0)
	}
	SubShader {
		Tags { "RenderType"="Opaque"  "IgnoreProjector"="True" "ForceNoShadowCasting"="True" }
		LOD 200
		Pass {
		ZTest Always Cull Off ZWrite Off
	  	Fog { Mode off }   
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#pragma target 2.0
		#pragma fragmentoption ARB_precision_hint_fastest
		
		#include "UnityCG.cginc"
		
		uniform sampler2D _MainTex;
		uniform fixed2 _MainTex_ST;
		fixed3 _Color;
		fixed4 offsets;

		struct v2f 
		{
			float4 pos : POSITION;
			fixed4 uv01 : TEXCOORD1;
			fixed4 uv23 : TEXCOORD2;
			fixed4 uv45 : TEXCOORD3;
			fixed4 uv67 : TEXCOORD4;
		};

		v2f vert (appdata_base v)
		{
			v2f o;
			o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
		
			o.uv01 =  v.texcoord.xyxy + offsets * fixed4(0,0,0,1);
			o.uv23 =  v.texcoord.xyxy + offsets * fixed4(0,2,0,3);
			o.uv45 =  v.texcoord.xyxy + offsets * fixed4(0,4,0,5);
			o.uv67 =  v.texcoord.xyxy + offsets * fixed4(0,6,0,7);
	
		    return o;
		}

		fixed4 frag (v2f i) : COLOR 
		{
 			fixed2 dv = tex2D(_MainTex, i.uv01.xy).rg;
			dv += tex2D(_MainTex, i.uv01.zw).rg;
			dv += tex2D(_MainTex, i.uv23.xy).rg;
			dv += tex2D(_MainTex, i.uv23.zw).rg;
			dv += tex2D(_MainTex, i.uv45.xy).rg;
			dv += tex2D(_MainTex, i.uv45.zw).rg;	
			dv += tex2D(_MainTex, i.uv67.xy).rg;
			dv += tex2D(_MainTex, i.uv67.zw).rg;
			dv*=0.125;

  			return fixed4(dv.x,dv.y,0,1);
 		}
 		
 		ENDCG
		}
	} 
	FallBack "Diffuse"
}

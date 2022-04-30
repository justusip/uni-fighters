Shader "TransitionShader"
{
    Properties
    {
        _CutOff("CutOff", Float) = 0.5
        [NoScaleOffset]_TransitionTex("TransitionTex", 2D) = "white" {}

        _StencilComp("Stencil Comparison", Float) = 8
        _Stencil("Stencil ID", Float) = 0
        _StencilOp("Stencil Operation", Float) = 0
        _StencilWriteMask("Stencil Write Mask", Float) = 255
        _StencilReadMask("Stencil Read Mask", Float) = 255

        _ColorMask("Color Mask", Float) = 15

        [Toggle(UNITY_UI_ALPHACLIP)] _UseUIAlphaClip("Use Alpha Clip", Float) = 0

    }
    SubShader
    {
        Tags
        {
            "RenderPipeline" = "LightweightPipeline"
            "Queue" = "Transparent"
            "IgnoreProjector" = "True"
            "RenderType" = "Transparent"
            "PreviewType" = "Plane"
            "CanUseSpriteAtlas" = "True"
        }

        Stencil
        {
            Ref[_Stencil]
            Comp[_StencilComp]
            Pass[_StencilOp]
            ReadMask[_StencilReadMask]
            WriteMask[_StencilWriteMask]
        }

        Cull Off
        Lighting Off
        ZWrite Off
        ZTest[unity_GUIZTestMode]
        Blend SrcAlpha OneMinusSrcAlpha
        ColorMask[_ColorMask]

            Pass
            {
                Name "Sprite Lit"
                Tags
                {
                    "LightMode" = "Universal2D"
                }
            
                // Render State
                Cull Off
                Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
                ZTest LEqual
                ZWrite Off
            
                // Debug
                // <None>
            
                // --------------------------------------------------
                // Pass
            
                HLSLPROGRAM
            
                // Pragmas
                #pragma target 2.0
                #pragma exclude_renderers d3d11_9x
                #pragma vertex vert
                #pragma fragment frag
            
                // DotsInstancingOptions: <None>
                // HybridV1InjectedBuiltinProperties: <None>
            
                // Keywords
                #pragma multi_compile _ USE_SHAPE_LIGHT_TYPE_0
                #pragma multi_compile _ USE_SHAPE_LIGHT_TYPE_1
                #pragma multi_compile _ USE_SHAPE_LIGHT_TYPE_2
                #pragma multi_compile _ USE_SHAPE_LIGHT_TYPE_3
                #pragma multi_compile_fragment _ DEBUG_DISPLAY
                // GraphKeywords: <None>
            
                // Defines
                #define _SURFACE_TYPE_TRANSPARENT 1
                #define ATTRIBUTES_NEED_NORMAL
                #define ATTRIBUTES_NEED_TANGENT
                #define ATTRIBUTES_NEED_TEXCOORD0
                #define ATTRIBUTES_NEED_COLOR
                #define VARYINGS_NEED_POSITION_WS
                #define VARYINGS_NEED_TEXCOORD0
                #define VARYINGS_NEED_COLOR
                #define VARYINGS_NEED_SCREENPOSITION
                #define FEATURES_GRAPH_VERTEX
                /* WARNING: $splice Could not find named fragment 'PassInstancing' */
                #define SHADERPASS SHADERPASS_SPRITELIT
                /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
            
                // Includes
                /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreInclude' */
            
                #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Shaders/2D/Include/LightingUtility.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
            
                // --------------------------------------------------
                // Structs and Packing
            
                /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
            
                struct Attributes
                {
                     float3 positionOS : POSITION;
                     float3 normalOS : NORMAL;
                     float4 tangentOS : TANGENT;
                     float4 uv0 : TEXCOORD0;
                     float4 color : COLOR;
                    #if UNITY_ANY_INSTANCING_ENABLED
                     uint instanceID : INSTANCEID_SEMANTIC;
                    #endif
                };
                struct Varyings
                {
                     float4 positionCS : SV_POSITION;
                     float3 positionWS;
                     float4 texCoord0;
                     float4 color;
                     float4 screenPosition;
                    #if UNITY_ANY_INSTANCING_ENABLED
                     uint instanceID : CUSTOM_INSTANCE_ID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                     uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                     uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                     FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                    #endif
                };
                struct SurfaceDescriptionInputs
                {
                     float4 uv0;
                };
                struct VertexDescriptionInputs
                {
                     float3 ObjectSpaceNormal;
                     float3 ObjectSpaceTangent;
                     float3 ObjectSpacePosition;
                };
                struct PackedVaryings
                {
                     float4 positionCS : SV_POSITION;
                     float3 interp0 : INTERP0;
                     float4 interp1 : INTERP1;
                     float4 interp2 : INTERP2;
                     float4 interp3 : INTERP3;
                    #if UNITY_ANY_INSTANCING_ENABLED
                     uint instanceID : CUSTOM_INSTANCE_ID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                     uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                     uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                     FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                    #endif
                };
            
                PackedVaryings PackVaryings (Varyings input)
                {
                    PackedVaryings output;
                    ZERO_INITIALIZE(PackedVaryings, output);
                    output.positionCS = input.positionCS;
                    output.interp0.xyz =  input.positionWS;
                    output.interp1.xyzw =  input.texCoord0;
                    output.interp2.xyzw =  input.color;
                    output.interp3.xyzw =  input.screenPosition;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    output.instanceID = input.instanceID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    output.cullFace = input.cullFace;
                    #endif
                    return output;
                }
                
                Varyings UnpackVaryings (PackedVaryings input)
                {
                    Varyings output;
                    output.positionCS = input.positionCS;
                    output.positionWS = input.interp0.xyz;
                    output.texCoord0 = input.interp1.xyzw;
                    output.color = input.interp2.xyzw;
                    output.screenPosition = input.interp3.xyzw;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    output.instanceID = input.instanceID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    output.cullFace = input.cullFace;
                    #endif
                    return output;
                }
                
            
                // --------------------------------------------------
                // Graph
            
                // Graph Properties
                CBUFFER_START(UnityPerMaterial)
                float _CutOff;
                float4 _TransitionTex_TexelSize;
                CBUFFER_END
                
                // Object and Global properties
                SAMPLER(SamplerState_Linear_Repeat);
                TEXTURE2D(_TransitionTex);
                SAMPLER(sampler_TransitionTex);
            
                // Graph Includes
                // GraphIncludes: <None>
            
                // -- Property used by ScenePickingPass
                #ifdef SCENEPICKINGPASS
                float4 _SelectionID;
                #endif
            
                // -- Properties used by SceneSelectionPass
                #ifdef SCENESELECTIONPASS
                int _ObjectId;
                int _PassValue;
                #endif
            
                // Graph Functions
                
                void Unity_Comparison_GreaterOrEqual_float(float A, float B, out float Out)
                {
                    Out = A >= B ? 1 : 0;
                }
                
                void Unity_Branch_float(float Predicate, float True, float False, out float Out)
                {
                    Out = Predicate ? True : False;
                }
            
                /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
            
                // Graph Vertex
                struct VertexDescription
                {
                    float3 Position;
                    float3 Normal;
                    float3 Tangent;
                };
                
                VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                {
                    VertexDescription description = (VertexDescription)0;
                    description.Position = IN.ObjectSpacePosition;
                    description.Normal = IN.ObjectSpaceNormal;
                    description.Tangent = IN.ObjectSpaceTangent;
                    return description;
                }
            
                #ifdef FEATURES_GRAPH_VERTEX
            Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
            {
            return output;
            }
            #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
            #endif
            
                // Graph Pixel
                struct SurfaceDescription
                {
                    float3 BaseColor;
                    float Alpha;
                    float4 SpriteMask;
                };
                
                SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                {
                    SurfaceDescription surface = (SurfaceDescription)0;
                    float _Property_fc38a8c67b81424fb7e2d251879451e7_Out_0 = _CutOff;
                    UnityTexture2D _Property_f889f43edfb14ebaa8f078865747f901_Out_0 = UnityBuildTexture2DStructNoScale(_TransitionTex);
                    float4 _SampleTexture2D_c662eab8662d4a7f90ff1a9b02f4b470_RGBA_0 = SAMPLE_TEXTURE2D(_Property_f889f43edfb14ebaa8f078865747f901_Out_0.tex, _Property_f889f43edfb14ebaa8f078865747f901_Out_0.samplerstate, _Property_f889f43edfb14ebaa8f078865747f901_Out_0.GetTransformedUV(IN.uv0.xy));
                    float _SampleTexture2D_c662eab8662d4a7f90ff1a9b02f4b470_R_4 = _SampleTexture2D_c662eab8662d4a7f90ff1a9b02f4b470_RGBA_0.r;
                    float _SampleTexture2D_c662eab8662d4a7f90ff1a9b02f4b470_G_5 = _SampleTexture2D_c662eab8662d4a7f90ff1a9b02f4b470_RGBA_0.g;
                    float _SampleTexture2D_c662eab8662d4a7f90ff1a9b02f4b470_B_6 = _SampleTexture2D_c662eab8662d4a7f90ff1a9b02f4b470_RGBA_0.b;
                    float _SampleTexture2D_c662eab8662d4a7f90ff1a9b02f4b470_A_7 = _SampleTexture2D_c662eab8662d4a7f90ff1a9b02f4b470_RGBA_0.a;
                    float _Comparison_56e1cfffa137400b8c88d2bc63c68aa8_Out_2;
                    Unity_Comparison_GreaterOrEqual_float(_Property_fc38a8c67b81424fb7e2d251879451e7_Out_0, _SampleTexture2D_c662eab8662d4a7f90ff1a9b02f4b470_R_4, _Comparison_56e1cfffa137400b8c88d2bc63c68aa8_Out_2);
                    float _Branch_b9790e2365d44884a0232b592578bfb0_Out_3;
                    Unity_Branch_float(_Comparison_56e1cfffa137400b8c88d2bc63c68aa8_Out_2, 1, 0, _Branch_b9790e2365d44884a0232b592578bfb0_Out_3);
                    surface.BaseColor = IsGammaSpace() ? float3(0, 0, 0) : SRGBToLinear(float3(0, 0, 0));
                    surface.Alpha = _Branch_b9790e2365d44884a0232b592578bfb0_Out_3;
                    surface.SpriteMask = IsGammaSpace() ? float4(1, 1, 1, 1) : float4 (SRGBToLinear(float3(1, 1, 1)), 1);
                    return surface;
                }
            
                // --------------------------------------------------
                // Build Graph Inputs
            
                VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
                {
                    VertexDescriptionInputs output;
                    ZERO_INITIALIZE(VertexDescriptionInputs, output);
                
                    output.ObjectSpaceNormal =                          input.normalOS;
                    output.ObjectSpaceTangent =                         input.tangentOS.xyz;
                    output.ObjectSpacePosition =                        input.positionOS;
                
                    return output;
                }
                
                SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
                {
                    SurfaceDescriptionInputs output;
                    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
                
                    
                
                
                
                
                
                    output.uv0 =                                        input.texCoord0;
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN                output.FaceSign =                                   IS_FRONT_VFACE(input.cullFace, true, false);
                #else
                #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                #endif
                #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                
                    return output;
                }
                
            
                // --------------------------------------------------
                // Main
            
                #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/2D/ShaderGraph/Includes/SpriteLitPass.hlsl"
            
                ENDHLSL
            }
            Pass
            {
                Name "Sprite Normal"
                Tags
                {
                    "LightMode" = "NormalsRendering"
                }
            
                // Render State
                Cull Off
                Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
                ZTest LEqual
                ZWrite Off
            
                // Debug
                // <None>
            
                // --------------------------------------------------
                // Pass
            
                HLSLPROGRAM
            
                // Pragmas
                #pragma target 2.0
                #pragma exclude_renderers d3d11_9x
                #pragma vertex vert
                #pragma fragment frag
            
                // DotsInstancingOptions: <None>
                // HybridV1InjectedBuiltinProperties: <None>
            
                // Keywords
                // PassKeywords: <None>
                // GraphKeywords: <None>
            
                // Defines
                #define _SURFACE_TYPE_TRANSPARENT 1
                #define ATTRIBUTES_NEED_NORMAL
                #define ATTRIBUTES_NEED_TANGENT
                #define ATTRIBUTES_NEED_TEXCOORD0
                #define VARYINGS_NEED_NORMAL_WS
                #define VARYINGS_NEED_TANGENT_WS
                #define VARYINGS_NEED_TEXCOORD0
                #define FEATURES_GRAPH_VERTEX
                /* WARNING: $splice Could not find named fragment 'PassInstancing' */
                #define SHADERPASS SHADERPASS_SPRITENORMAL
                /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
            
                // Includes
                /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreInclude' */
            
                #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Shaders/2D/Include/NormalsRenderingShared.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
            
                // --------------------------------------------------
                // Structs and Packing
            
                /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
            
                struct Attributes
                {
                     float3 positionOS : POSITION;
                     float3 normalOS : NORMAL;
                     float4 tangentOS : TANGENT;
                     float4 uv0 : TEXCOORD0;
                    #if UNITY_ANY_INSTANCING_ENABLED
                     uint instanceID : INSTANCEID_SEMANTIC;
                    #endif
                };
                struct Varyings
                {
                     float4 positionCS : SV_POSITION;
                     float3 normalWS;
                     float4 tangentWS;
                     float4 texCoord0;
                    #if UNITY_ANY_INSTANCING_ENABLED
                     uint instanceID : CUSTOM_INSTANCE_ID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                     uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                     uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                     FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                    #endif
                };
                struct SurfaceDescriptionInputs
                {
                     float3 TangentSpaceNormal;
                     float4 uv0;
                };
                struct VertexDescriptionInputs
                {
                     float3 ObjectSpaceNormal;
                     float3 ObjectSpaceTangent;
                     float3 ObjectSpacePosition;
                };
                struct PackedVaryings
                {
                     float4 positionCS : SV_POSITION;
                     float3 interp0 : INTERP0;
                     float4 interp1 : INTERP1;
                     float4 interp2 : INTERP2;
                    #if UNITY_ANY_INSTANCING_ENABLED
                     uint instanceID : CUSTOM_INSTANCE_ID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                     uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                     uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                     FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                    #endif
                };
            
                PackedVaryings PackVaryings (Varyings input)
                {
                    PackedVaryings output;
                    ZERO_INITIALIZE(PackedVaryings, output);
                    output.positionCS = input.positionCS;
                    output.interp0.xyz =  input.normalWS;
                    output.interp1.xyzw =  input.tangentWS;
                    output.interp2.xyzw =  input.texCoord0;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    output.instanceID = input.instanceID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    output.cullFace = input.cullFace;
                    #endif
                    return output;
                }
                
                Varyings UnpackVaryings (PackedVaryings input)
                {
                    Varyings output;
                    output.positionCS = input.positionCS;
                    output.normalWS = input.interp0.xyz;
                    output.tangentWS = input.interp1.xyzw;
                    output.texCoord0 = input.interp2.xyzw;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    output.instanceID = input.instanceID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    output.cullFace = input.cullFace;
                    #endif
                    return output;
                }
                
            
                // --------------------------------------------------
                // Graph
            
                // Graph Properties
                CBUFFER_START(UnityPerMaterial)
                float _CutOff;
                float4 _TransitionTex_TexelSize;
                CBUFFER_END
                
                // Object and Global properties
                SAMPLER(SamplerState_Linear_Repeat);
                TEXTURE2D(_TransitionTex);
                SAMPLER(sampler_TransitionTex);
            
                // Graph Includes
                // GraphIncludes: <None>
            
                // -- Property used by ScenePickingPass
                #ifdef SCENEPICKINGPASS
                float4 _SelectionID;
                #endif
            
                // -- Properties used by SceneSelectionPass
                #ifdef SCENESELECTIONPASS
                int _ObjectId;
                int _PassValue;
                #endif
            
                // Graph Functions
                
                void Unity_Comparison_GreaterOrEqual_float(float A, float B, out float Out)
                {
                    Out = A >= B ? 1 : 0;
                }
                
                void Unity_Branch_float(float Predicate, float True, float False, out float Out)
                {
                    Out = Predicate ? True : False;
                }
            
                /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
            
                // Graph Vertex
                struct VertexDescription
                {
                    float3 Position;
                    float3 Normal;
                    float3 Tangent;
                };
                
                VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                {
                    VertexDescription description = (VertexDescription)0;
                    description.Position = IN.ObjectSpacePosition;
                    description.Normal = IN.ObjectSpaceNormal;
                    description.Tangent = IN.ObjectSpaceTangent;
                    return description;
                }
            
                #ifdef FEATURES_GRAPH_VERTEX
            Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
            {
            return output;
            }
            #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
            #endif
            
                // Graph Pixel
                struct SurfaceDescription
                {
                    float3 BaseColor;
                    float Alpha;
                    float3 NormalTS;
                };
                
                SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                {
                    SurfaceDescription surface = (SurfaceDescription)0;
                    float _Property_fc38a8c67b81424fb7e2d251879451e7_Out_0 = _CutOff;
                    UnityTexture2D _Property_f889f43edfb14ebaa8f078865747f901_Out_0 = UnityBuildTexture2DStructNoScale(_TransitionTex);
                    float4 _SampleTexture2D_c662eab8662d4a7f90ff1a9b02f4b470_RGBA_0 = SAMPLE_TEXTURE2D(_Property_f889f43edfb14ebaa8f078865747f901_Out_0.tex, _Property_f889f43edfb14ebaa8f078865747f901_Out_0.samplerstate, _Property_f889f43edfb14ebaa8f078865747f901_Out_0.GetTransformedUV(IN.uv0.xy));
                    float _SampleTexture2D_c662eab8662d4a7f90ff1a9b02f4b470_R_4 = _SampleTexture2D_c662eab8662d4a7f90ff1a9b02f4b470_RGBA_0.r;
                    float _SampleTexture2D_c662eab8662d4a7f90ff1a9b02f4b470_G_5 = _SampleTexture2D_c662eab8662d4a7f90ff1a9b02f4b470_RGBA_0.g;
                    float _SampleTexture2D_c662eab8662d4a7f90ff1a9b02f4b470_B_6 = _SampleTexture2D_c662eab8662d4a7f90ff1a9b02f4b470_RGBA_0.b;
                    float _SampleTexture2D_c662eab8662d4a7f90ff1a9b02f4b470_A_7 = _SampleTexture2D_c662eab8662d4a7f90ff1a9b02f4b470_RGBA_0.a;
                    float _Comparison_56e1cfffa137400b8c88d2bc63c68aa8_Out_2;
                    Unity_Comparison_GreaterOrEqual_float(_Property_fc38a8c67b81424fb7e2d251879451e7_Out_0, _SampleTexture2D_c662eab8662d4a7f90ff1a9b02f4b470_R_4, _Comparison_56e1cfffa137400b8c88d2bc63c68aa8_Out_2);
                    float _Branch_b9790e2365d44884a0232b592578bfb0_Out_3;
                    Unity_Branch_float(_Comparison_56e1cfffa137400b8c88d2bc63c68aa8_Out_2, 1, 0, _Branch_b9790e2365d44884a0232b592578bfb0_Out_3);
                    surface.BaseColor = IsGammaSpace() ? float3(0, 0, 0) : SRGBToLinear(float3(0, 0, 0));
                    surface.Alpha = _Branch_b9790e2365d44884a0232b592578bfb0_Out_3;
                    surface.NormalTS = IN.TangentSpaceNormal;
                    return surface;
                }
            
                // --------------------------------------------------
                // Build Graph Inputs
            
                VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
                {
                    VertexDescriptionInputs output;
                    ZERO_INITIALIZE(VertexDescriptionInputs, output);
                
                    output.ObjectSpaceNormal =                          input.normalOS;
                    output.ObjectSpaceTangent =                         input.tangentOS.xyz;
                    output.ObjectSpacePosition =                        input.positionOS;
                
                    return output;
                }
                
                SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
                {
                    SurfaceDescriptionInputs output;
                    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
                
                    
                
                
                
                    output.TangentSpaceNormal =                         float3(0.0f, 0.0f, 1.0f);
                
                
                    output.uv0 =                                        input.texCoord0;
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN                output.FaceSign =                                   IS_FRONT_VFACE(input.cullFace, true, false);
                #else
                #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                #endif
                #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                
                    return output;
                }
                
            
                // --------------------------------------------------
                // Main
            
                #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/2D/ShaderGraph/Includes/SpriteNormalPass.hlsl"
            
                ENDHLSL
            }
            Pass
            {
                Name "SceneSelectionPass"
                Tags
                {
                    "LightMode" = "SceneSelectionPass"
                }
            
                // Render State
                Cull Off
            
                // Debug
                // <None>
            
                // --------------------------------------------------
                // Pass
            
                HLSLPROGRAM
            
                // Pragmas
                #pragma target 2.0
                #pragma exclude_renderers d3d11_9x
                #pragma vertex vert
                #pragma fragment frag
            
                // DotsInstancingOptions: <None>
                // HybridV1InjectedBuiltinProperties: <None>
            
                // Keywords
                // PassKeywords: <None>
                // GraphKeywords: <None>
            
                // Defines
                #define _SURFACE_TYPE_TRANSPARENT 1
                #define ATTRIBUTES_NEED_NORMAL
                #define ATTRIBUTES_NEED_TANGENT
                #define ATTRIBUTES_NEED_TEXCOORD0
                #define VARYINGS_NEED_TEXCOORD0
                #define FEATURES_GRAPH_VERTEX
                /* WARNING: $splice Could not find named fragment 'PassInstancing' */
                #define SHADERPASS SHADERPASS_DEPTHONLY
                #define SCENESELECTIONPASS 1
                
                /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
            
                // Includes
                /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreInclude' */
            
                #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
            
                // --------------------------------------------------
                // Structs and Packing
            
                /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
            
                struct Attributes
                {
                     float3 positionOS : POSITION;
                     float3 normalOS : NORMAL;
                     float4 tangentOS : TANGENT;
                     float4 uv0 : TEXCOORD0;
                    #if UNITY_ANY_INSTANCING_ENABLED
                     uint instanceID : INSTANCEID_SEMANTIC;
                    #endif
                };
                struct Varyings
                {
                     float4 positionCS : SV_POSITION;
                     float4 texCoord0;
                    #if UNITY_ANY_INSTANCING_ENABLED
                     uint instanceID : CUSTOM_INSTANCE_ID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                     uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                     uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                     FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                    #endif
                };
                struct SurfaceDescriptionInputs
                {
                     float4 uv0;
                };
                struct VertexDescriptionInputs
                {
                     float3 ObjectSpaceNormal;
                     float3 ObjectSpaceTangent;
                     float3 ObjectSpacePosition;
                };
                struct PackedVaryings
                {
                     float4 positionCS : SV_POSITION;
                     float4 interp0 : INTERP0;
                    #if UNITY_ANY_INSTANCING_ENABLED
                     uint instanceID : CUSTOM_INSTANCE_ID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                     uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                     uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                     FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                    #endif
                };
            
                PackedVaryings PackVaryings (Varyings input)
                {
                    PackedVaryings output;
                    ZERO_INITIALIZE(PackedVaryings, output);
                    output.positionCS = input.positionCS;
                    output.interp0.xyzw =  input.texCoord0;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    output.instanceID = input.instanceID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    output.cullFace = input.cullFace;
                    #endif
                    return output;
                }
                
                Varyings UnpackVaryings (PackedVaryings input)
                {
                    Varyings output;
                    output.positionCS = input.positionCS;
                    output.texCoord0 = input.interp0.xyzw;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    output.instanceID = input.instanceID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    output.cullFace = input.cullFace;
                    #endif
                    return output;
                }
                
            
                // --------------------------------------------------
                // Graph
            
                // Graph Properties
                CBUFFER_START(UnityPerMaterial)
                float _CutOff;
                float4 _TransitionTex_TexelSize;
                CBUFFER_END
                
                // Object and Global properties
                SAMPLER(SamplerState_Linear_Repeat);
                TEXTURE2D(_TransitionTex);
                SAMPLER(sampler_TransitionTex);
            
                // Graph Includes
                // GraphIncludes: <None>
            
                // -- Property used by ScenePickingPass
                #ifdef SCENEPICKINGPASS
                float4 _SelectionID;
                #endif
            
                // -- Properties used by SceneSelectionPass
                #ifdef SCENESELECTIONPASS
                int _ObjectId;
                int _PassValue;
                #endif
            
                // Graph Functions
                
                void Unity_Comparison_GreaterOrEqual_float(float A, float B, out float Out)
                {
                    Out = A >= B ? 1 : 0;
                }
                
                void Unity_Branch_float(float Predicate, float True, float False, out float Out)
                {
                    Out = Predicate ? True : False;
                }
            
                /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
            
                // Graph Vertex
                struct VertexDescription
                {
                    float3 Position;
                    float3 Normal;
                    float3 Tangent;
                };
                
                VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                {
                    VertexDescription description = (VertexDescription)0;
                    description.Position = IN.ObjectSpacePosition;
                    description.Normal = IN.ObjectSpaceNormal;
                    description.Tangent = IN.ObjectSpaceTangent;
                    return description;
                }
            
                #ifdef FEATURES_GRAPH_VERTEX
            Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
            {
            return output;
            }
            #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
            #endif
            
                // Graph Pixel
                struct SurfaceDescription
                {
                    float Alpha;
                };
                
                SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                {
                    SurfaceDescription surface = (SurfaceDescription)0;
                    float _Property_fc38a8c67b81424fb7e2d251879451e7_Out_0 = _CutOff;
                    UnityTexture2D _Property_f889f43edfb14ebaa8f078865747f901_Out_0 = UnityBuildTexture2DStructNoScale(_TransitionTex);
                    float4 _SampleTexture2D_c662eab8662d4a7f90ff1a9b02f4b470_RGBA_0 = SAMPLE_TEXTURE2D(_Property_f889f43edfb14ebaa8f078865747f901_Out_0.tex, _Property_f889f43edfb14ebaa8f078865747f901_Out_0.samplerstate, _Property_f889f43edfb14ebaa8f078865747f901_Out_0.GetTransformedUV(IN.uv0.xy));
                    float _SampleTexture2D_c662eab8662d4a7f90ff1a9b02f4b470_R_4 = _SampleTexture2D_c662eab8662d4a7f90ff1a9b02f4b470_RGBA_0.r;
                    float _SampleTexture2D_c662eab8662d4a7f90ff1a9b02f4b470_G_5 = _SampleTexture2D_c662eab8662d4a7f90ff1a9b02f4b470_RGBA_0.g;
                    float _SampleTexture2D_c662eab8662d4a7f90ff1a9b02f4b470_B_6 = _SampleTexture2D_c662eab8662d4a7f90ff1a9b02f4b470_RGBA_0.b;
                    float _SampleTexture2D_c662eab8662d4a7f90ff1a9b02f4b470_A_7 = _SampleTexture2D_c662eab8662d4a7f90ff1a9b02f4b470_RGBA_0.a;
                    float _Comparison_56e1cfffa137400b8c88d2bc63c68aa8_Out_2;
                    Unity_Comparison_GreaterOrEqual_float(_Property_fc38a8c67b81424fb7e2d251879451e7_Out_0, _SampleTexture2D_c662eab8662d4a7f90ff1a9b02f4b470_R_4, _Comparison_56e1cfffa137400b8c88d2bc63c68aa8_Out_2);
                    float _Branch_b9790e2365d44884a0232b592578bfb0_Out_3;
                    Unity_Branch_float(_Comparison_56e1cfffa137400b8c88d2bc63c68aa8_Out_2, 1, 0, _Branch_b9790e2365d44884a0232b592578bfb0_Out_3);
                    surface.Alpha = _Branch_b9790e2365d44884a0232b592578bfb0_Out_3;
                    return surface;
                }
            
                // --------------------------------------------------
                // Build Graph Inputs
            
                VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
                {
                    VertexDescriptionInputs output;
                    ZERO_INITIALIZE(VertexDescriptionInputs, output);
                
                    output.ObjectSpaceNormal =                          input.normalOS;
                    output.ObjectSpaceTangent =                         input.tangentOS.xyz;
                    output.ObjectSpacePosition =                        input.positionOS;
                
                    return output;
                }
                
                SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
                {
                    SurfaceDescriptionInputs output;
                    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
                
                    
                
                
                
                
                
                    output.uv0 =                                        input.texCoord0;
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN                output.FaceSign =                                   IS_FRONT_VFACE(input.cullFace, true, false);
                #else
                #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                #endif
                #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                
                    return output;
                }
                
            
                // --------------------------------------------------
                // Main
            
                #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"
            
                ENDHLSL
            }
            Pass
            {
                Name "ScenePickingPass"
                Tags
                {
                    "LightMode" = "Picking"
                }
            
                // Render State
                Cull Back
            
                // Debug
                // <None>
            
                // --------------------------------------------------
                // Pass
            
                HLSLPROGRAM
            
                // Pragmas
                #pragma target 2.0
                #pragma exclude_renderers d3d11_9x
                #pragma vertex vert
                #pragma fragment frag
            
                // DotsInstancingOptions: <None>
                // HybridV1InjectedBuiltinProperties: <None>
            
                // Keywords
                // PassKeywords: <None>
                // GraphKeywords: <None>
            
                // Defines
                #define _SURFACE_TYPE_TRANSPARENT 1
                #define ATTRIBUTES_NEED_NORMAL
                #define ATTRIBUTES_NEED_TANGENT
                #define ATTRIBUTES_NEED_TEXCOORD0
                #define VARYINGS_NEED_TEXCOORD0
                #define FEATURES_GRAPH_VERTEX
                /* WARNING: $splice Could not find named fragment 'PassInstancing' */
                #define SHADERPASS SHADERPASS_DEPTHONLY
                #define SCENEPICKINGPASS 1
                
                /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
            
                // Includes
                /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreInclude' */
            
                #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
            
                // --------------------------------------------------
                // Structs and Packing
            
                /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
            
                struct Attributes
                {
                     float3 positionOS : POSITION;
                     float3 normalOS : NORMAL;
                     float4 tangentOS : TANGENT;
                     float4 uv0 : TEXCOORD0;
                    #if UNITY_ANY_INSTANCING_ENABLED
                     uint instanceID : INSTANCEID_SEMANTIC;
                    #endif
                };
                struct Varyings
                {
                     float4 positionCS : SV_POSITION;
                     float4 texCoord0;
                    #if UNITY_ANY_INSTANCING_ENABLED
                     uint instanceID : CUSTOM_INSTANCE_ID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                     uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                     uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                     FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                    #endif
                };
                struct SurfaceDescriptionInputs
                {
                     float4 uv0;
                };
                struct VertexDescriptionInputs
                {
                     float3 ObjectSpaceNormal;
                     float3 ObjectSpaceTangent;
                     float3 ObjectSpacePosition;
                };
                struct PackedVaryings
                {
                     float4 positionCS : SV_POSITION;
                     float4 interp0 : INTERP0;
                    #if UNITY_ANY_INSTANCING_ENABLED
                     uint instanceID : CUSTOM_INSTANCE_ID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                     uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                     uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                     FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                    #endif
                };
            
                PackedVaryings PackVaryings (Varyings input)
                {
                    PackedVaryings output;
                    ZERO_INITIALIZE(PackedVaryings, output);
                    output.positionCS = input.positionCS;
                    output.interp0.xyzw =  input.texCoord0;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    output.instanceID = input.instanceID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    output.cullFace = input.cullFace;
                    #endif
                    return output;
                }
                
                Varyings UnpackVaryings (PackedVaryings input)
                {
                    Varyings output;
                    output.positionCS = input.positionCS;
                    output.texCoord0 = input.interp0.xyzw;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    output.instanceID = input.instanceID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    output.cullFace = input.cullFace;
                    #endif
                    return output;
                }
                
            
                // --------------------------------------------------
                // Graph
            
                // Graph Properties
                CBUFFER_START(UnityPerMaterial)
                float _CutOff;
                float4 _TransitionTex_TexelSize;
                CBUFFER_END
                
                // Object and Global properties
                SAMPLER(SamplerState_Linear_Repeat);
                TEXTURE2D(_TransitionTex);
                SAMPLER(sampler_TransitionTex);
            
                // Graph Includes
                // GraphIncludes: <None>
            
                // -- Property used by ScenePickingPass
                #ifdef SCENEPICKINGPASS
                float4 _SelectionID;
                #endif
            
                // -- Properties used by SceneSelectionPass
                #ifdef SCENESELECTIONPASS
                int _ObjectId;
                int _PassValue;
                #endif
            
                // Graph Functions
                
                void Unity_Comparison_GreaterOrEqual_float(float A, float B, out float Out)
                {
                    Out = A >= B ? 1 : 0;
                }
                
                void Unity_Branch_float(float Predicate, float True, float False, out float Out)
                {
                    Out = Predicate ? True : False;
                }
            
                /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
            
                // Graph Vertex
                struct VertexDescription
                {
                    float3 Position;
                    float3 Normal;
                    float3 Tangent;
                };
                
                VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                {
                    VertexDescription description = (VertexDescription)0;
                    description.Position = IN.ObjectSpacePosition;
                    description.Normal = IN.ObjectSpaceNormal;
                    description.Tangent = IN.ObjectSpaceTangent;
                    return description;
                }
            
                #ifdef FEATURES_GRAPH_VERTEX
            Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
            {
            return output;
            }
            #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
            #endif
            
                // Graph Pixel
                struct SurfaceDescription
                {
                    float Alpha;
                };
                
                SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                {
                    SurfaceDescription surface = (SurfaceDescription)0;
                    float _Property_fc38a8c67b81424fb7e2d251879451e7_Out_0 = _CutOff;
                    UnityTexture2D _Property_f889f43edfb14ebaa8f078865747f901_Out_0 = UnityBuildTexture2DStructNoScale(_TransitionTex);
                    float4 _SampleTexture2D_c662eab8662d4a7f90ff1a9b02f4b470_RGBA_0 = SAMPLE_TEXTURE2D(_Property_f889f43edfb14ebaa8f078865747f901_Out_0.tex, _Property_f889f43edfb14ebaa8f078865747f901_Out_0.samplerstate, _Property_f889f43edfb14ebaa8f078865747f901_Out_0.GetTransformedUV(IN.uv0.xy));
                    float _SampleTexture2D_c662eab8662d4a7f90ff1a9b02f4b470_R_4 = _SampleTexture2D_c662eab8662d4a7f90ff1a9b02f4b470_RGBA_0.r;
                    float _SampleTexture2D_c662eab8662d4a7f90ff1a9b02f4b470_G_5 = _SampleTexture2D_c662eab8662d4a7f90ff1a9b02f4b470_RGBA_0.g;
                    float _SampleTexture2D_c662eab8662d4a7f90ff1a9b02f4b470_B_6 = _SampleTexture2D_c662eab8662d4a7f90ff1a9b02f4b470_RGBA_0.b;
                    float _SampleTexture2D_c662eab8662d4a7f90ff1a9b02f4b470_A_7 = _SampleTexture2D_c662eab8662d4a7f90ff1a9b02f4b470_RGBA_0.a;
                    float _Comparison_56e1cfffa137400b8c88d2bc63c68aa8_Out_2;
                    Unity_Comparison_GreaterOrEqual_float(_Property_fc38a8c67b81424fb7e2d251879451e7_Out_0, _SampleTexture2D_c662eab8662d4a7f90ff1a9b02f4b470_R_4, _Comparison_56e1cfffa137400b8c88d2bc63c68aa8_Out_2);
                    float _Branch_b9790e2365d44884a0232b592578bfb0_Out_3;
                    Unity_Branch_float(_Comparison_56e1cfffa137400b8c88d2bc63c68aa8_Out_2, 1, 0, _Branch_b9790e2365d44884a0232b592578bfb0_Out_3);
                    surface.Alpha = _Branch_b9790e2365d44884a0232b592578bfb0_Out_3;
                    return surface;
                }
            
                // --------------------------------------------------
                // Build Graph Inputs
            
                VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
                {
                    VertexDescriptionInputs output;
                    ZERO_INITIALIZE(VertexDescriptionInputs, output);
                
                    output.ObjectSpaceNormal =                          input.normalOS;
                    output.ObjectSpaceTangent =                         input.tangentOS.xyz;
                    output.ObjectSpacePosition =                        input.positionOS;
                
                    return output;
                }
                
                SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
                {
                    SurfaceDescriptionInputs output;
                    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
                
                    
                
                
                
                
                
                    output.uv0 =                                        input.texCoord0;
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN                output.FaceSign =                                   IS_FRONT_VFACE(input.cullFace, true, false);
                #else
                #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                #endif
                #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                
                    return output;
                }
                
            
                // --------------------------------------------------
                // Main
            
                #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"
            
                ENDHLSL
            }
            Pass
            {
                Name "Sprite Forward"
                Tags
                {
                    "LightMode" = "UniversalForward"
                }
            
                // Render State
                Cull Off
                Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
                ZTest LEqual
                ZWrite Off
            
                // Debug
                // <None>
            
                // --------------------------------------------------
                // Pass
            
                HLSLPROGRAM
            
                // Pragmas
                #pragma target 2.0
                #pragma exclude_renderers d3d11_9x
                #pragma vertex vert
                #pragma fragment frag
            
                // DotsInstancingOptions: <None>
                // HybridV1InjectedBuiltinProperties: <None>
            
                // Keywords
                #pragma multi_compile_fragment _ DEBUG_DISPLAY
                // GraphKeywords: <None>
            
                // Defines
                #define _SURFACE_TYPE_TRANSPARENT 1
                #define ATTRIBUTES_NEED_NORMAL
                #define ATTRIBUTES_NEED_TANGENT
                #define ATTRIBUTES_NEED_TEXCOORD0
                #define ATTRIBUTES_NEED_COLOR
                #define VARYINGS_NEED_POSITION_WS
                #define VARYINGS_NEED_TEXCOORD0
                #define VARYINGS_NEED_COLOR
                #define FEATURES_GRAPH_VERTEX
                /* WARNING: $splice Could not find named fragment 'PassInstancing' */
                #define SHADERPASS SHADERPASS_SPRITEFORWARD
                /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
            
                // Includes
                /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreInclude' */
            
                #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
            
                // --------------------------------------------------
                // Structs and Packing
            
                /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
            
                struct Attributes
                {
                     float3 positionOS : POSITION;
                     float3 normalOS : NORMAL;
                     float4 tangentOS : TANGENT;
                     float4 uv0 : TEXCOORD0;
                     float4 color : COLOR;
                    #if UNITY_ANY_INSTANCING_ENABLED
                     uint instanceID : INSTANCEID_SEMANTIC;
                    #endif
                };
                struct Varyings
                {
                     float4 positionCS : SV_POSITION;
                     float3 positionWS;
                     float4 texCoord0;
                     float4 color;
                    #if UNITY_ANY_INSTANCING_ENABLED
                     uint instanceID : CUSTOM_INSTANCE_ID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                     uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                     uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                     FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                    #endif
                };
                struct SurfaceDescriptionInputs
                {
                     float3 TangentSpaceNormal;
                     float4 uv0;
                };
                struct VertexDescriptionInputs
                {
                     float3 ObjectSpaceNormal;
                     float3 ObjectSpaceTangent;
                     float3 ObjectSpacePosition;
                };
                struct PackedVaryings
                {
                     float4 positionCS : SV_POSITION;
                     float3 interp0 : INTERP0;
                     float4 interp1 : INTERP1;
                     float4 interp2 : INTERP2;
                    #if UNITY_ANY_INSTANCING_ENABLED
                     uint instanceID : CUSTOM_INSTANCE_ID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                     uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                     uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                     FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                    #endif
                };
            
                PackedVaryings PackVaryings (Varyings input)
                {
                    PackedVaryings output;
                    ZERO_INITIALIZE(PackedVaryings, output);
                    output.positionCS = input.positionCS;
                    output.interp0.xyz =  input.positionWS;
                    output.interp1.xyzw =  input.texCoord0;
                    output.interp2.xyzw =  input.color;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    output.instanceID = input.instanceID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    output.cullFace = input.cullFace;
                    #endif
                    return output;
                }
                
                Varyings UnpackVaryings (PackedVaryings input)
                {
                    Varyings output;
                    output.positionCS = input.positionCS;
                    output.positionWS = input.interp0.xyz;
                    output.texCoord0 = input.interp1.xyzw;
                    output.color = input.interp2.xyzw;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    output.instanceID = input.instanceID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    output.cullFace = input.cullFace;
                    #endif
                    return output;
                }
                
            
                // --------------------------------------------------
                // Graph
            
                // Graph Properties
                CBUFFER_START(UnityPerMaterial)
                float _CutOff;
                float4 _TransitionTex_TexelSize;
                CBUFFER_END
                
                // Object and Global properties
                SAMPLER(SamplerState_Linear_Repeat);
                TEXTURE2D(_TransitionTex);
                SAMPLER(sampler_TransitionTex);
            
                // Graph Includes
                // GraphIncludes: <None>
            
                // -- Property used by ScenePickingPass
                #ifdef SCENEPICKINGPASS
                float4 _SelectionID;
                #endif
            
                // -- Properties used by SceneSelectionPass
                #ifdef SCENESELECTIONPASS
                int _ObjectId;
                int _PassValue;
                #endif
            
                // Graph Functions
                
                void Unity_Comparison_GreaterOrEqual_float(float A, float B, out float Out)
                {
                    Out = A >= B ? 1 : 0;
                }
                
                void Unity_Branch_float(float Predicate, float True, float False, out float Out)
                {
                    Out = Predicate ? True : False;
                }
            
                /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
            
                // Graph Vertex
                struct VertexDescription
                {
                    float3 Position;
                    float3 Normal;
                    float3 Tangent;
                };
                
                VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                {
                    VertexDescription description = (VertexDescription)0;
                    description.Position = IN.ObjectSpacePosition;
                    description.Normal = IN.ObjectSpaceNormal;
                    description.Tangent = IN.ObjectSpaceTangent;
                    return description;
                }
            
                #ifdef FEATURES_GRAPH_VERTEX
            Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
            {
            return output;
            }
            #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
            #endif
            
                // Graph Pixel
                struct SurfaceDescription
                {
                    float3 BaseColor;
                    float Alpha;
                    float3 NormalTS;
                };
                
                SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                {
                    SurfaceDescription surface = (SurfaceDescription)0;
                    float _Property_fc38a8c67b81424fb7e2d251879451e7_Out_0 = _CutOff;
                    UnityTexture2D _Property_f889f43edfb14ebaa8f078865747f901_Out_0 = UnityBuildTexture2DStructNoScale(_TransitionTex);
                    float4 _SampleTexture2D_c662eab8662d4a7f90ff1a9b02f4b470_RGBA_0 = SAMPLE_TEXTURE2D(_Property_f889f43edfb14ebaa8f078865747f901_Out_0.tex, _Property_f889f43edfb14ebaa8f078865747f901_Out_0.samplerstate, _Property_f889f43edfb14ebaa8f078865747f901_Out_0.GetTransformedUV(IN.uv0.xy));
                    float _SampleTexture2D_c662eab8662d4a7f90ff1a9b02f4b470_R_4 = _SampleTexture2D_c662eab8662d4a7f90ff1a9b02f4b470_RGBA_0.r;
                    float _SampleTexture2D_c662eab8662d4a7f90ff1a9b02f4b470_G_5 = _SampleTexture2D_c662eab8662d4a7f90ff1a9b02f4b470_RGBA_0.g;
                    float _SampleTexture2D_c662eab8662d4a7f90ff1a9b02f4b470_B_6 = _SampleTexture2D_c662eab8662d4a7f90ff1a9b02f4b470_RGBA_0.b;
                    float _SampleTexture2D_c662eab8662d4a7f90ff1a9b02f4b470_A_7 = _SampleTexture2D_c662eab8662d4a7f90ff1a9b02f4b470_RGBA_0.a;
                    float _Comparison_56e1cfffa137400b8c88d2bc63c68aa8_Out_2;
                    Unity_Comparison_GreaterOrEqual_float(_Property_fc38a8c67b81424fb7e2d251879451e7_Out_0, _SampleTexture2D_c662eab8662d4a7f90ff1a9b02f4b470_R_4, _Comparison_56e1cfffa137400b8c88d2bc63c68aa8_Out_2);
                    float _Branch_b9790e2365d44884a0232b592578bfb0_Out_3;
                    Unity_Branch_float(_Comparison_56e1cfffa137400b8c88d2bc63c68aa8_Out_2, 1, 0, _Branch_b9790e2365d44884a0232b592578bfb0_Out_3);
                    surface.BaseColor = IsGammaSpace() ? float3(0, 0, 0) : SRGBToLinear(float3(0, 0, 0));
                    surface.Alpha = _Branch_b9790e2365d44884a0232b592578bfb0_Out_3;
                    surface.NormalTS = IN.TangentSpaceNormal;
                    return surface;
                }
            
                // --------------------------------------------------
                // Build Graph Inputs
            
                VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
                {
                    VertexDescriptionInputs output;
                    ZERO_INITIALIZE(VertexDescriptionInputs, output);
                
                    output.ObjectSpaceNormal =                          input.normalOS;
                    output.ObjectSpaceTangent =                         input.tangentOS.xyz;
                    output.ObjectSpacePosition =                        input.positionOS;
                
                    return output;
                }
                
                SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
                {
                    SurfaceDescriptionInputs output;
                    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
                
                    
                
                
                
                    output.TangentSpaceNormal =                         float3(0.0f, 0.0f, 1.0f);
                
                
                    output.uv0 =                                        input.texCoord0;
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN                output.FaceSign =                                   IS_FRONT_VFACE(input.cullFace, true, false);
                #else
                #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                #endif
                #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                
                    return output;
                }
                
            
                // --------------------------------------------------
                // Main
            
                #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/2D/ShaderGraph/Includes/SpriteForwardPass.hlsl"
            
                ENDHLSL
            }
        }
        CustomEditor "UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI"
        FallBack "Hidden/Shader Graph/FallbackError"
    }
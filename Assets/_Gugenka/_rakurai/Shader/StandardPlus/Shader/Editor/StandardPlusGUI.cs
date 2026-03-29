// Unity C# reference source
// Copyright (c) Unity Technologies. For terms of use, see
// https://unity3d.com/legal/licenses/Unity_Reference_Only_License

using System;
using UnityEngine;
using UnityEditor;
using System.Linq;

namespace UnityEditor
{
    internal class StandardPlusGUI : ShaderGUI
    {
        private enum WorkflowMode
        {
            Specular,
            Metallic,
            Dielectric
        }

        public enum BlendMode
        {
            Opaque,
            Cutout,
            Fade,   // Old school alpha-blending mode, fresnel does not affect amount of transparency
            Transparent // Physically plausible transparency mode, implemented as alpha pre-multiply
        }

        public enum ToneMappingType
        {
            None,
            ACES,
            Reinhard,
            GT,
        }

        public enum SmoothnessMapChannel
        {
            SpecularMetallicAlpha,
            AlbedoAlpha,
        }

        private static class Styles
        {
            public static GUIContent uvSetLabel = EditorGUIUtility.TrTextContent("UV Set");

            public static GUIContent albedoText = EditorGUIUtility.TrTextContent("Albedo", "Albedo (RGB) and Transparency (A)");
            public static GUIContent alphaCutoffText = EditorGUIUtility.TrTextContent("Alpha Cutoff", "Threshold for alpha cutoff");
            public static GUIContent specularMapText = EditorGUIUtility.TrTextContent("Specular", "Specular (RGB) and Smoothness (A)");
            public static GUIContent metallicMapText = EditorGUIUtility.TrTextContent("Metallic", "Metallic (R) and Smoothness (A)");
            public static GUIContent smoothnessText = EditorGUIUtility.TrTextContent("Smoothness", "Smoothness value");
            public static GUIContent smoothnessScaleText = EditorGUIUtility.TrTextContent("Smoothness", "Smoothness scale factor");
            public static GUIContent smoothnessMapChannelText = EditorGUIUtility.TrTextContent("Source", "Smoothness texture and channel");
            public static GUIContent highlightsText = EditorGUIUtility.TrTextContent("Specular Highlights", "Specular Highlights");
            public static GUIContent reflectionsText = EditorGUIUtility.TrTextContent("Reflections", "Glossy Reflections");
            public static GUIContent forceBoxProjectionText = EditorGUIUtility.TrTextContent("Force BoxProjection", "Force BoxProjection");
            public static GUIContent normalMapText = EditorGUIUtility.TrTextContent("Normal Map", "Normal Map");
            public static GUIContent heightMapText = EditorGUIUtility.TrTextContent("Height Map", "Height Map (G)");
            public static GUIContent occlusionText = EditorGUIUtility.TrTextContent("Occlusion", "Occlusion (G)");
            public static GUIContent emissionText = EditorGUIUtility.TrTextContent("Color", "Emission (RGB)");
            public static GUIContent detailMaskText = EditorGUIUtility.TrTextContent("Detail Mask", "Mask for Secondary Maps (A)");
            public static GUIContent detailAlbedoText = EditorGUIUtility.TrTextContent("Detail Albedo x2", "Albedo (RGB) multiplied by 2");
            public static GUIContent detailNormalMapText = EditorGUIUtility.TrTextContent("Normal Map", "Normal Map");
            //public static GUIContent DarkMapText = EditorGUIUtility.TrTextContent("1stMap");
            //public static GUIContent LitMapText = EditorGUIUtility.TrTextContent("2ndMap");

            public static string primaryMapsText = "Main Maps";
            public static string secondaryMapsText = "Secondary Maps";
            public static string forwardText = "Forward Rendering Options";
            public static string renderingMode = "Rendering Mode";
            public static string advancedText = "Options";
            public static string cullModeText = "CullMode";
            public static string ToneMappingTypeText = "ToneMapping Type";
            public static readonly string[] blendNames = Enum.GetNames(typeof(BlendMode));
            public static readonly string[] ToneMappingTypes = Enum.GetNames(typeof(ToneMappingType));

            //Tab Styles
            private static GUIContent[] _tabToggles = null;
            public static GUIContent[] TabToggles
            {
                get
                {
                    if (_tabToggles == null)
                    {
                        _tabToggles = System.Enum.GetNames(typeof(Tab)).Select(x => new GUIContent(x)).ToArray();
                    }
                    return _tabToggles;
                }
            }

            public static readonly GUIStyle TabButtonStyle = "LargeButton";
            public static readonly GUI.ToolbarButtonSize TabButtonSize = GUI.ToolbarButtonSize.Fixed;
        }

        MaterialProperty blendMode = null;
        MaterialProperty cullMode = null;
        MaterialProperty albedoMap = null;
        MaterialProperty albedoColor = null;
        MaterialProperty alphaCutoff = null;
        MaterialProperty specularMap = null;
        MaterialProperty specularColor = null;
        MaterialProperty metallicMap = null;
        MaterialProperty metallic = null;
        MaterialProperty smoothness = null;
        MaterialProperty smoothnessScale = null;
        MaterialProperty smoothnessMapChannel = null;
        MaterialProperty highlights = null;
        MaterialProperty reflections = null;
        MaterialProperty bumpScale = null;
        MaterialProperty bumpMap = null;
        MaterialProperty occlusionStrength = null;
        MaterialProperty occlusionMap = null;
        MaterialProperty heigtMapScale = null;
        MaterialProperty heightMap = null;
        MaterialProperty emissionColorForRendering = null;
        MaterialProperty emissionMap = null;
        MaterialProperty detailMask = null;
        MaterialProperty detailAlbedoMap = null;
        MaterialProperty detailNormalMapScale = null;
        MaterialProperty detailNormalMap = null;
        MaterialProperty uvSetSecondary = null;

        MaterialProperty emissiveBoost = null;

        MaterialProperty UseToneMapping = null;
        MaterialProperty UseColorModifier = null;
        MaterialProperty ToneContrast = null;
        MaterialProperty Saturation = null;
        MaterialProperty HueShift = null;
        MaterialProperty Exposure = null;

        MaterialProperty GTMaxBrightness = null;
        MaterialProperty GTContrast;
        MaterialProperty GTLinearStart;
        MaterialProperty GTLinearLength;
        MaterialProperty GTBlack;

        MaterialProperty UseBakeOC = null;
        MaterialProperty BakeOCIntensity = null;
        MaterialProperty BakeOCPow = null;

        MaterialProperty StencilRef = null;

        MaterialProperty forceBoxProjection = null;

        MaterialProperty UsePlanarMappingAlbedo = null;
        MaterialProperty AlbedoPlanerTex = null;
        MaterialProperty AlbedoPlanarColor = null;
        MaterialProperty AlbedoPlanarUV = null;

        MaterialProperty UsePlanarMappingGloss = null;
        MaterialProperty GlossPlanerTex = null;
        MaterialProperty GlossPlanarUV = null;
        MaterialProperty GlossRemapMin = null;
        MaterialProperty GlossRemapMax = null;

        MaterialProperty UsePlanarMappingNormal = null;
        MaterialProperty NormalPlanerTex = null;
        MaterialProperty NormalPlanarUV = null;
        MaterialProperty NormalPlanarScale = null;

        //MaterialProperty UseOC = null;
        //MaterialProperty OCIntensity = null;
        //MaterialProperty OCPow = null;
        //MaterialProperty OCDirLerp = null;
        //MaterialProperty UseBakeOC = null;
        //MaterialProperty BakeOCIntensity = null;
        //MaterialProperty BakeOCPow = null;
        //MaterialProperty BakeOCDirLerp = null;
        //MaterialProperty BakedMapColor = null;
        //MaterialProperty BakedMapContrast = null;
        //MaterialProperty RealTimeMapColor = null;
        //MaterialProperty RealTimeMapContrast = null;
        //MaterialProperty UseCustomMap = null;
        //MaterialProperty DarkMap = null;
        //MaterialProperty DarkMapColor = null;
        //MaterialProperty LitMap = null;
        //MaterialProperty LitMapColor = null;
        //MaterialProperty Change = null;
        //MaterialProperty ToneBrightness = null;
        //MaterialProperty ToneBlack = null;


        MaterialEditor m_MaterialEditor;
        WorkflowMode m_WorkflowMode = WorkflowMode.Specular;

        bool m_FirstTimeApply = true;
        [SerializeField] bool ToneFold;
        //[SerializeField] bool GIOCFold;
        //[SerializeField] bool BakeOCFold;
        //[SerializeField] bool BakeMapEditFold;
        //[SerializeField] bool RealTimeMapEditFold;
        //[SerializeField] bool CustomMapEditFold;

        enum Tab
        {
            Base,
            Advanced,
        }

        private Tab _tab = Tab.Base;


        public void FindProperties(MaterialProperty[] props)
        {
            blendMode = FindProperty("_Mode", props);
            cullMode = FindProperty("_CullMode", props);
            albedoMap = FindProperty("_MainTex", props);
            albedoColor = FindProperty("_Color", props);
            alphaCutoff = FindProperty("_Cutoff", props);
            specularMap = FindProperty("_SpecGlossMap", props, false);
            specularColor = FindProperty("_SpecColor", props, false);
            metallicMap = FindProperty("_MetallicGlossMap", props, false);
            metallic = FindProperty("_Metallic", props, false);
            if (specularMap != null && specularColor != null)
                m_WorkflowMode = WorkflowMode.Specular;
            else if (metallicMap != null && metallic != null)
                m_WorkflowMode = WorkflowMode.Metallic;
            else
                m_WorkflowMode = WorkflowMode.Dielectric;
            smoothness = FindProperty("_Glossiness", props);
            smoothnessScale = FindProperty("_GlossMapScale", props, false);
            smoothnessMapChannel = FindProperty("_SmoothnessTextureChannel", props, false);
            highlights = FindProperty("_SpecularHighlights", props, false);
            reflections = FindProperty("_GlossyReflections", props, false);
            bumpScale = FindProperty("_BumpScale", props);
            bumpMap = FindProperty("_BumpMap", props);
            heigtMapScale = FindProperty("_Parallax", props);
            heightMap = FindProperty("_ParallaxMap", props);
            occlusionStrength = FindProperty("_OcclusionStrength", props);
            occlusionMap = FindProperty("_OcclusionMap", props);
            emissionColorForRendering = FindProperty("_EmissionColor", props);
            emissionMap = FindProperty("_EmissionMap", props);
            detailMask = FindProperty("_DetailMask", props);
            detailAlbedoMap = FindProperty("_DetailAlbedoMap", props);
            detailNormalMapScale = FindProperty("_DetailNormalMapScale", props);
            detailNormalMap = FindProperty("_DetailNormalMap", props);
            uvSetSecondary = FindProperty("_UVSec", props);

            emissiveBoost = FindProperty("_MetaPassEmissiveBoost", props);
            UseToneMapping = FindProperty("_UseToneMapping", props);
            UseColorModifier = FindProperty("_UseColorModifier", props);
            ToneContrast = FindProperty("_ToneContrast", props);
            Saturation = FindProperty("_Saturation", props);
            HueShift = FindProperty("_HueShift", props);
            Exposure = FindProperty("_Exposure", props);

            GTMaxBrightness = FindProperty("_GTMaxBrightness", props);
            GTContrast = FindProperty("_GTContrast", props);
            GTLinearStart = FindProperty("_GTLinearStart", props);
            GTLinearLength = FindProperty("_GTLinearLength", props);
            GTBlack = FindProperty("_GTBlack", props);

            UseBakeOC = FindProperty("_UseBakeOC", props);
            BakeOCIntensity = FindProperty("_BakeOCIntensity", props);
            BakeOCPow = FindProperty("_BakeOCPow", props);

            StencilRef = FindProperty("_Ref", props);

            forceBoxProjection = FindProperty("_ForceBoxProjection", props);

            UsePlanarMappingAlbedo = FindProperty("_UsePlanarMappingAlbedo", props);
            AlbedoPlanerTex = FindProperty("_AlbedoPlanerTex", props);
            AlbedoPlanarColor = FindProperty("_AlbedoPlanarColor", props);
            AlbedoPlanarUV = FindProperty("_AlbedoPlanarUV", props);

            UsePlanarMappingGloss = FindProperty("_UsePlanarMappingGloss", props);
            GlossPlanerTex = FindProperty("_GlossPlanerTex", props);
            GlossPlanarUV = FindProperty("_GlossPlanarUV", props);
            GlossRemapMin = FindProperty("_GlossRemapMin", props);
            GlossRemapMax = FindProperty("_GlossRemapMax", props);

            UsePlanarMappingNormal = FindProperty("_UsePlanarMappingNormal", props);
            NormalPlanerTex = FindProperty("_NormalPlanerTex", props);
            NormalPlanarUV = FindProperty("_NormalPlanarUV", props);
            NormalPlanarScale = FindProperty("_NormalPlanarScale", props);


            /*
            UseOC = FindProperty("_UseOC",props);
            OCIntensity = FindProperty("_OCIntensity",props);
            OCPow = FindProperty("_OCPow",props);
            OCDirLerp = FindProperty("_OCDirLerp",props);

            UseBakeOC = FindProperty("_UseBakeOC",props);
            BakeOCIntensity = FindProperty("_BakeOCIntensity",props);
            BakeOCPow = FindProperty("_BakeOCPow",props);
            BakeOCDirLerp = FindProperty("_BakeOCDirLerp",props);

            BakedMapColor = FindProperty("_BakedMapColor", props);
            BakedMapContrast = FindProperty("_BakedMapContrast", props);

            RealTimeMapColor = FindProperty("_RealTimeMapColor", props);
            RealTimeMapContrast = FindProperty("_RealTimeMapContrast", props);

            UseCustomMap = FindProperty("_UseCustomMap",props);
            DarkMap = FindProperty("_DarkMap",props);
            DarkMapColor = FindProperty("_DarkMapColor",props);
            LitMap = FindProperty("_LitMap",props);
            LitMapColor = FindProperty("_LitMapColor",props);
            Change = FindProperty("_Change",props);

            ToneBrightness = FindProperty("_ToneBrightness",props);
            ToneBlack = FindProperty("_ToneBlack",props);
            */

        }

        public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] props)
        {
            FindProperties(props); // MaterialProperties can be animated so we do not cache them but fetch them every event to ensure animated values are updated correctly
            m_MaterialEditor = materialEditor;
            Material material = materialEditor.target as Material;

            // Make sure that needed setup (ie keywords/renderqueue) are set up if we're switching some existing
            // material to a standard shader.
            // Do this before any GUI code has been issued to prevent layout issues in subsequent GUILayout statements (case 780071)
            if (m_FirstTimeApply)
            {
                MaterialChanged(material, m_WorkflowMode);
                m_FirstTimeApply = false;
            }

            ShaderPropertiesGUI(material,m_MaterialEditor,props);
        }

        public void ShaderPropertiesGUI(Material material,MaterialEditor materialEditor, MaterialProperty[] properties)
        {
            // Use default labelWidth
            EditorGUIUtility.labelWidth = 0f;
            bool blendModeChanged = false;

            // Detect any changes to the material
            EditorGUI.BeginChangeCheck();
            {
                using (new EditorGUILayout.HorizontalScope())
                {
                    GUILayout.FlexibleSpace();
                    // タブを描画する
                    _tab = (Tab)GUILayout.Toolbar((int)_tab, Styles.TabToggles, Styles.TabButtonStyle, Styles.TabButtonSize);
                    GUILayout.FlexibleSpace();
                }
                EditorGUILayout.Space();

                if(_tab == Tab.Base)
                {
                    EditorGUILayout.BeginVertical(GUI.skin.GetStyle("HelpBox"));
                    {
                        // Primary properties
                        GUILayout.Label(Styles.primaryMapsText, EditorStyles.boldLabel);
                        DoAlbedoArea(material);
                        DoSpecularMetallicArea();
                        DoNormalArea();
                        m_MaterialEditor.TexturePropertySingleLine(Styles.heightMapText, heightMap, heightMap.textureValue != null ? heigtMapScale : null);
                        m_MaterialEditor.TexturePropertySingleLine(Styles.occlusionText, occlusionMap, occlusionMap.textureValue != null ? occlusionStrength : null);
                        m_MaterialEditor.TexturePropertySingleLine(Styles.detailMaskText, detailMask);
                        DoEmissionArea(material);
                        EditorGUI.BeginChangeCheck();
                        m_MaterialEditor.TextureScaleOffsetProperty(albedoMap);
                        if (EditorGUI.EndChangeCheck())
                            emissionMap.textureScaleAndOffset = albedoMap.textureScaleAndOffset; // Apply the main texture scale and offset to the emission texture as well, for Enlighten's sake

                        EditorGUILayout.Space();

                        // Secondary properties
                        GUILayout.Label(Styles.secondaryMapsText, EditorStyles.boldLabel);
                        m_MaterialEditor.TexturePropertySingleLine(Styles.detailAlbedoText, detailAlbedoMap);
                        m_MaterialEditor.TexturePropertySingleLine(Styles.detailNormalMapText, detailNormalMap, detailNormalMapScale);
                        m_MaterialEditor.TextureScaleOffsetProperty(detailAlbedoMap);
                        m_MaterialEditor.ShaderProperty(uvSetSecondary, Styles.uvSetLabel.text);
                        EditorGUILayout.Space();
                    }
                    EditorGUILayout.EndVertical();
                    EditorGUILayout.Space();

                    EditorGUILayout.BeginVertical(GUI.skin.GetStyle("HelpBox"));
                    {
                        GUILayout.Label(Styles.forwardText, EditorStyles.boldLabel);
                        blendModeChanged = BlendModePopup();
                        m_MaterialEditor.ShaderProperty(cullMode, Styles.cullModeText);
                        EditorGUILayout.Space();
                        if (highlights != null)
                            m_MaterialEditor.ShaderProperty(highlights, Styles.highlightsText);
                        if (reflections != null)
                            m_MaterialEditor.ShaderProperty(reflections, Styles.reflectionsText);
                        if (forceBoxProjection != null)
                            m_MaterialEditor.ShaderProperty(forceBoxProjection, Styles.forceBoxProjectionText);
                        m_MaterialEditor.EnableInstancingField();
                        m_MaterialEditor.DoubleSidedGIField();
                        EditorGUILayout.Space();
                        m_MaterialEditor.ShaderProperty(StencilRef, "Stencil Ref");
                        m_MaterialEditor.RenderQueueField();
                    }
                    EditorGUILayout.EndVertical();

                }
                else if(_tab == Tab.Advanced)
                {
                    EditorGUILayout.BeginVertical(GUI.skin.GetStyle("HelpBox"));
                    {
                        GUILayout.Label("Planar Mapping(Albedo)", EditorStyles.boldLabel);
                        DoPlanarAlbedoArea(material);
                        EditorGUILayout.Space();

                        GUILayout.Label("Planar Mapping(Gloss)", EditorStyles.boldLabel);
                        DoPlanarGlossArea(material);
                        EditorGUILayout.Space();

                        GUILayout.Label("Planar Mapping(Normal)", EditorStyles.boldLabel);
                        DoPlanarNormalArea(material);
                        EditorGUILayout.Space();
                    }
                    EditorGUILayout.EndVertical();
                    EditorGUILayout.Space();

                    EditorGUILayout.BeginVertical(GUI.skin.GetStyle("HelpBox"));
                    {
                        GUILayout.Label("Color Modifier", EditorStyles.boldLabel);
                        DoToneMap();
                    }
                    EditorGUILayout.EndVertical();
                    EditorGUILayout.Space();

                    EditorGUILayout.BeginVertical(GUI.skin.GetStyle("HelpBox"));
                    {
                        GUILayout.Label("LightMap Occlusion", EditorStyles.boldLabel);
                        DoLightMapOCArea();
                    }
                    EditorGUILayout.EndVertical();
                }
                EditorGUILayout.Space();

                /*
                GUILayout.Label("LightMapEdit",EditorStyles.boldLabel);
                BakeMapEditFold = EditorGUILayout.Foldout(BakeMapEditFold,"BakedLightMap",true);
                if(BakeMapEditFold){
                    DoBakedMapEditArea();
                }
                EditorGUILayout.Space();

                RealTimeMapEditFold = EditorGUILayout.Foldout(RealTimeMapEditFold,"RealTimeLightMap",true);
                if(RealTimeMapEditFold){
                    DoRealTimeMapEditArea();
                }
                EditorGUILayout.Space();
                
                CustomMapEditFold = EditorGUILayout.Foldout(CustomMapEditFold,"CustomLightMap",true);
                if(CustomMapEditFold){
                    DoCustomMapArea();
                }
                EditorGUILayout.Space();

                GUILayout.Label("LightMapOcclusion",EditorStyles.boldLabel);
                BakeOCFold = EditorGUILayout.Foldout(BakeOCFold,"BakedOcclusion",true);
                if(BakeOCFold){
                    EditorGUILayout.HelpBox("Using Baked Lightmap", MessageType.Info);
                    DoBakeAOArea(materialEditor,properties);
                }
                EditorGUILayout.Space();
                GIOCFold = EditorGUILayout.Foldout(GIOCFold,"RealTimeOcclusion",true);
                if(GIOCFold){
                    EditorGUILayout.HelpBox("Using RealTime Lightmap", MessageType.Info);
                    DoAOArea(materialEditor,properties);
                }
                */


            }
            
            if (EditorGUI.EndChangeCheck())
            {
                foreach (var obj in blendMode.targets)
                    SetMaterialKeywords((Material)obj, m_WorkflowMode);
            }
            

            if (blendModeChanged)
            {
                foreach (var obj in blendMode.targets)
                    MaterialChanged((Material)obj, m_WorkflowMode);
            }

  
        }

        internal void DetermineWorkflow(MaterialProperty[] props)
        {
            if (FindProperty("_SpecGlossMap", props, false) != null && FindProperty("_SpecColor", props, false) != null)
                m_WorkflowMode = WorkflowMode.Specular;
            else if (FindProperty("_MetallicGlossMap", props, false) != null && FindProperty("_Metallic", props, false) != null)
                m_WorkflowMode = WorkflowMode.Metallic;
            else
                m_WorkflowMode = WorkflowMode.Dielectric;
        }

        public override void AssignNewShaderToMaterial(Material material, Shader oldShader, Shader newShader)
        {
            // _Emission property is lost after assigning Standard shader to the material
            // thus transfer it before assigning the new shader
            if (material.HasProperty("_Emission"))
            {
                material.SetColor("_EmissionColor", material.GetColor("_Emission"));
            }

            base.AssignNewShaderToMaterial(material, oldShader, newShader);

            if (oldShader == null || !oldShader.name.Contains("Legacy Shaders/"))
            {
                SetupMaterialWithBlendMode(material, (BlendMode)material.GetFloat("_Mode"));
                return;
            }

            BlendMode blendMode = BlendMode.Opaque;
            if (oldShader.name.Contains("/Transparent/Cutout/"))
            {
                blendMode = BlendMode.Cutout;
            }
            else if (oldShader.name.Contains("/Transparent/"))
            {
                // NOTE: legacy shaders did not provide physically based transparency
                // therefore Fade mode
                blendMode = BlendMode.Fade;
            }
            material.SetFloat("_Mode", (float)blendMode);

            DetermineWorkflow(MaterialEditor.GetMaterialProperties(new Material[] { material }));
            MaterialChanged(material, m_WorkflowMode);
        }

        void DrawProperties(MaterialProperty toggle, string keyword, MaterialEditor materialEditor, MaterialProperty[] properties)
        {
            materialEditor.ShaderProperty (toggle, toggle.displayName);
            if (toggle.floatValue == 1f) {
            var subProps = properties
                .Where (x => x.name.Contains (keyword))
                .Where (x => x.name != toggle.name);

            foreach (var prop in subProps) {
                materialEditor.ShaderProperty (prop, prop.displayName);
            }
        }

        }

        bool BlendModePopup()
        {
            bool result = false;
            EditorGUI.showMixedValue = blendMode.hasMixedValue;
            var mode = (BlendMode)blendMode.floatValue;

            EditorGUI.BeginChangeCheck();
            mode = (BlendMode)EditorGUILayout.Popup(Styles.renderingMode, (int)mode, Styles.blendNames);
            if (EditorGUI.EndChangeCheck())
            {
                result = true;
                m_MaterialEditor.RegisterPropertyChangeUndo("Rendering Mode");
                blendMode.floatValue = (float)mode;
            }

            EditorGUI.showMixedValue = false;
            return result;
        }

        void DoToneMap()
        {
            EditorGUI.showMixedValue = UseToneMapping.hasMixedValue;
            var type = (ToneMappingType)UseToneMapping.floatValue;

            EditorGUI.BeginChangeCheck();
            type = (ToneMappingType)EditorGUILayout.Popup(Styles.ToneMappingTypeText, (int)type, Styles.ToneMappingTypes);
            if(type == ToneMappingType.GT)
            {
                m_MaterialEditor.ShaderProperty(GTMaxBrightness, "GT MaxBrightness");
                m_MaterialEditor.ShaderProperty(GTContrast, "GT Contrast");
                m_MaterialEditor.ShaderProperty(GTLinearStart, "GT LinearStart");
                m_MaterialEditor.ShaderProperty(GTLinearLength, "GT LinearLength");
                m_MaterialEditor.ShaderProperty(GTBlack, "GT Black");
            }
            if (EditorGUI.EndChangeCheck())
            {
                m_MaterialEditor.RegisterPropertyChangeUndo("ToneMapping Type");
                UseToneMapping.floatValue = (float)type;
            }
            EditorGUILayout.Space(10);

            m_MaterialEditor.ShaderProperty(UseColorModifier, "Use ColorModifier");
            m_MaterialEditor.ShaderProperty(Exposure, "Exposure");
            m_MaterialEditor.ShaderProperty(HueShift, "Hue Shift");
            m_MaterialEditor.ShaderProperty(Saturation, "Saturation");
            m_MaterialEditor.ShaderProperty(ToneContrast, "Contrast");

            /*
            ToneFold = EditorGUILayout.Foldout(ToneFold, "Tonemap", true);
            if (ToneFold)
            {
                EditorGUI.showMixedValue = UseToneMapping.hasMixedValue;
                var type = (ToneMappingType)UseToneMapping.floatValue;

                EditorGUI.BeginChangeCheck();
                type = (ToneMappingType)EditorGUILayout.Popup(Styles.ToneMappingTypeText, (int)type, Styles.ToneMappingTypes);
                if (EditorGUI.EndChangeCheck())
                {
                    m_MaterialEditor.RegisterPropertyChangeUndo("ToneMapping Type");
                    UseToneMapping.floatValue = (float)type;
                }

                m_MaterialEditor.ShaderProperty(ToneContrast, "Contrast");
            }
            */

        }

        void DoLightMapOCArea()
        {

            m_MaterialEditor.ShaderProperty(UseBakeOC, "Use LightMap Occlusion");
            m_MaterialEditor.ShaderProperty(BakeOCIntensity, "Occlusion Intensity");
            m_MaterialEditor.ShaderProperty(BakeOCPow, "Occlusion Contrast");
        }

        void DoPlanarAlbedoArea(Material material)
        {
            m_MaterialEditor.ShaderProperty(UsePlanarMappingAlbedo, "Use PlanarMapping");
            if(material.GetFloat("_UsePlanarMappingAlbedo") == 1)
            {
                m_MaterialEditor.TexturePropertySingleLine(new GUIContent("Texture"), AlbedoPlanerTex, AlbedoPlanarColor);
                m_MaterialEditor.ShaderProperty(AlbedoPlanarUV, "Tiling And Scroll");
            }
        }

        void DoPlanarGlossArea(Material material)
        {
            m_MaterialEditor.ShaderProperty(UsePlanarMappingGloss, "Use PlanarMapping");
            if (material.GetFloat("_UsePlanarMappingGloss") == 1)
            {
                m_MaterialEditor.TexturePropertySingleLine(new GUIContent("Texture"), GlossPlanerTex);
                m_MaterialEditor.ShaderProperty(GlossPlanarUV, "Tiling And Scroll");
                m_MaterialEditor.ShaderProperty(GlossRemapMin, "GlossTex RemapMin");
                m_MaterialEditor.ShaderProperty(GlossRemapMax, "GlossTex RemapMax");
            }
        }

        void DoPlanarNormalArea(Material material)
        {
            m_MaterialEditor.ShaderProperty(UsePlanarMappingNormal, "Use PlanarMapping");
            if (material.GetFloat("_UsePlanarMappingNormal") == 1)
            {
                m_MaterialEditor.TexturePropertySingleLine(new GUIContent("Texture"), NormalPlanerTex, NormalPlanerTex.textureValue != null ? NormalPlanarScale : null);
                m_MaterialEditor.ShaderProperty(NormalPlanarUV, "Tiling And Scroll");

            }
        }

        void DoNormalArea()
        {
            m_MaterialEditor.TexturePropertySingleLine(Styles.normalMapText, bumpMap, bumpMap.textureValue != null ? bumpScale : null);
            if (bumpScale.floatValue != 1 && UnityEditorInternal.InternalEditorUtility.IsMobilePlatform(EditorUserBuildSettings.activeBuildTarget))
                if (m_MaterialEditor.HelpBoxWithButton(
                    EditorGUIUtility.TrTextContent("Bump scale is not supported on mobile platforms"),
                    EditorGUIUtility.TrTextContent("Fix Now")))
                {
                    bumpScale.floatValue = 1;
                }
        }

        void DoAlbedoArea(Material material)
        {
            m_MaterialEditor.TexturePropertySingleLine(Styles.albedoText, albedoMap, albedoColor);
            if (((BlendMode)material.GetFloat("_Mode") == BlendMode.Cutout))
            {
                m_MaterialEditor.ShaderProperty(alphaCutoff, Styles.alphaCutoffText.text, MaterialEditor.kMiniTextureFieldLabelIndentLevel + 1);
            }
        }

        /*
        void DoBakedMapEditArea()
        {
            m_MaterialEditor.ShaderProperty(BakedMapColor, "BakedMapColor");
            m_MaterialEditor.ShaderProperty(BakedMapContrast, "BakedMapContrast");
        }

        void DoRealTimeMapEditArea()
        {
            m_MaterialEditor.ShaderProperty(RealTimeMapColor, "RealTimeMapColor");
            m_MaterialEditor.ShaderProperty(RealTimeMapContrast, "RealTimeMapContrast");
        }

        void DoCustomMapArea()
        {

           m_MaterialEditor.ShaderProperty(UseCustomMap, "UseCustomLightMap");
           m_MaterialEditor.TexturePropertySingleLine(Styles.DarkMapText,DarkMap,DarkMapColor);
           m_MaterialEditor.TexturePropertySingleLine(Styles.LitMapText,LitMap,LitMapColor);
           m_MaterialEditor.ShaderProperty(Change, "LerpTexture");
        }

        void DoAOArea(MaterialEditor materialEditor, MaterialProperty[] properties)
        {
            //var AOToggle = UseOC;
            //DrawProperties (AOToggle, "_AOT", materialEditor, properties);

            m_MaterialEditor.ShaderProperty(UseOC, "RealTimeOcclusion");
            m_MaterialEditor.ShaderProperty(OCIntensity, "OcclusionIntensity");
            m_MaterialEditor.ShaderProperty(OCPow, "OcclusionContrast");
            m_MaterialEditor.ShaderProperty(OCDirLerp, "NormalInfluence");
        }

        void DoBakeAOArea(MaterialEditor materialEditor, MaterialProperty[] properties)
        {

            m_MaterialEditor.ShaderProperty(UseBakeOC, "BakedOcclusion");
            m_MaterialEditor.ShaderProperty(BakeOCIntensity, "OcclusionIntensity");
            m_MaterialEditor.ShaderProperty(BakeOCPow, "OcclusionContrast");
            m_MaterialEditor.ShaderProperty(BakeOCDirLerp, "NormalInfluence");
        }
   
        */

        void DoEmissionArea(Material material)
        {
            // Emission for GI?
            if (m_MaterialEditor.EmissionEnabledProperty())
            {
                bool hadEmissionTexture = emissionMap.textureValue != null;

                // Texture and HDR color controls
                m_MaterialEditor.TexturePropertyWithHDRColor(Styles.emissionText, emissionMap, emissionColorForRendering, false);

                // If texture was assigned and color was black set color to white
                float brightness = emissionColorForRendering.colorValue.maxColorComponent;
                if (emissionMap.textureValue != null && !hadEmissionTexture && brightness <= 0f)
                    emissionColorForRendering.colorValue = Color.white;

                // change the GI flag and fix it up with emissive as black if necessary
                m_MaterialEditor.LightmapEmissionFlagsProperty(MaterialEditor.kMiniTextureFieldLabelIndentLevel, true);
                m_MaterialEditor.FloatProperty(emissiveBoost, "GI Emissive boost");
            }
        }

        void DoSpecularMetallicArea()
        {
            bool hasGlossMap = false;
            if (m_WorkflowMode == WorkflowMode.Specular)
            {
                hasGlossMap = specularMap.textureValue != null;
                m_MaterialEditor.TexturePropertySingleLine(Styles.specularMapText, specularMap, hasGlossMap ? null : specularColor);
            }
            else if (m_WorkflowMode == WorkflowMode.Metallic)
            {
                hasGlossMap = metallicMap.textureValue != null;
                m_MaterialEditor.TexturePropertySingleLine(Styles.metallicMapText, metallicMap, hasGlossMap ? null : metallic);
            }

            bool showSmoothnessScale = hasGlossMap;
            if (smoothnessMapChannel != null)
            {
                int smoothnessChannel = (int)smoothnessMapChannel.floatValue;
                if (smoothnessChannel == (int)SmoothnessMapChannel.AlbedoAlpha)
                    showSmoothnessScale = true;
            }

            int indentation = 2; // align with labels of texture properties
            m_MaterialEditor.ShaderProperty(showSmoothnessScale ? smoothnessScale : smoothness, showSmoothnessScale ? Styles.smoothnessScaleText : Styles.smoothnessText, indentation);

            ++indentation;
            if (smoothnessMapChannel != null)
                m_MaterialEditor.ShaderProperty(smoothnessMapChannel, Styles.smoothnessMapChannelText, indentation);
        }

        public static void SetupMaterialWithBlendMode(Material material, BlendMode blendMode)
        {

            switch (blendMode)
            {
                case BlendMode.Opaque:
                    material.SetOverrideTag("RenderType", "");
                    material.SetInt("_SrcBlend", (int)UnityEngine.Rendering.BlendMode.One);
                    material.SetInt("_DstBlend", (int)UnityEngine.Rendering.BlendMode.Zero);
                    material.SetInt("_ZWrite", 1);
                    material.DisableKeyword("_ALPHATEST_ON");
                    material.DisableKeyword("_ALPHABLEND_ON");
                    material.DisableKeyword("_ALPHAPREMULTIPLY_ON");
                    material.renderQueue = -1;
                    break;
                case BlendMode.Cutout:
                    material.SetOverrideTag("RenderType", "TransparentCutout");
                    material.SetInt("_SrcBlend", (int)UnityEngine.Rendering.BlendMode.One);
                    material.SetInt("_DstBlend", (int)UnityEngine.Rendering.BlendMode.Zero);
                    material.SetInt("_ZWrite", 1);
                    material.EnableKeyword("_ALPHATEST_ON");
                    material.DisableKeyword("_ALPHABLEND_ON");
                    material.DisableKeyword("_ALPHAPREMULTIPLY_ON");
                    material.renderQueue = (int)UnityEngine.Rendering.RenderQueue.AlphaTest;
                    break;
                case BlendMode.Fade:
                    material.SetOverrideTag("RenderType", "Transparent");
                    material.SetInt("_SrcBlend", (int)UnityEngine.Rendering.BlendMode.SrcAlpha);
                    material.SetInt("_DstBlend", (int)UnityEngine.Rendering.BlendMode.OneMinusSrcAlpha);
                    material.SetInt("_ZWrite", 0);
                    material.DisableKeyword("_ALPHATEST_ON");
                    material.EnableKeyword("_ALPHABLEND_ON");
                    material.DisableKeyword("_ALPHAPREMULTIPLY_ON");
                    material.renderQueue = (int)UnityEngine.Rendering.RenderQueue.Transparent;
                    break;
                case BlendMode.Transparent:
                    material.SetOverrideTag("RenderType", "Transparent");
                    material.SetInt("_SrcBlend", (int)UnityEngine.Rendering.BlendMode.One);
                    material.SetInt("_DstBlend", (int)UnityEngine.Rendering.BlendMode.OneMinusSrcAlpha);
                    material.SetInt("_ZWrite", 0);
                    material.DisableKeyword("_ALPHATEST_ON");
                    material.DisableKeyword("_ALPHABLEND_ON");
                    material.EnableKeyword("_ALPHAPREMULTIPLY_ON");
                    material.renderQueue = (int)UnityEngine.Rendering.RenderQueue.Transparent;
                    break;
            }
        }

        static SmoothnessMapChannel GetSmoothnessMapChannel(Material material)
        {
            int ch = (int)material.GetFloat("_SmoothnessTextureChannel");
            if (ch == (int)SmoothnessMapChannel.AlbedoAlpha)
                return SmoothnessMapChannel.AlbedoAlpha;
            else
                return SmoothnessMapChannel.SpecularMetallicAlpha;
        }

        static void SetMaterialKeywords(Material material, WorkflowMode workflowMode)
        {
            // Note: keywords must be based on Material value not on MaterialProperty due to multi-edit & material animation
            // (MaterialProperty value might come from renderer material property block)
            SetKeyword(material, "_NORMALMAP", material.GetTexture("_BumpMap") || material.GetTexture("_DetailNormalMap") || material.GetTexture("_NormalPlanerTex"));
            if (workflowMode == WorkflowMode.Specular)
                SetKeyword(material, "_SPECGLOSSMAP", material.GetTexture("_SpecGlossMap"));
            else if (workflowMode == WorkflowMode.Metallic)
                SetKeyword(material, "_METALLICGLOSSMAP", material.GetTexture("_MetallicGlossMap"));
            SetKeyword(material, "_PARALLAXMAP", material.GetTexture("_ParallaxMap"));
            SetKeyword(material, "_DETAIL_MULX2", material.GetTexture("_DetailAlbedoMap") || material.GetTexture("_DetailNormalMap"));

            // A material's GI flag internally keeps track of whether emission is enabled at all, it's enabled but has no effect
            // or is enabled and may be modified at runtime. This state depends on the values of the current flag and emissive color.
            // The fixup routine makes sure that the material is in the correct state if/when changes are made to the mode or color.
            MaterialEditor.FixupEmissiveFlag(material);
            bool shouldEmissionBeEnabled = (material.globalIlluminationFlags & MaterialGlobalIlluminationFlags.EmissiveIsBlack) == 0;
            SetKeyword(material, "_EMISSION", shouldEmissionBeEnabled);

            if (material.HasProperty("_SmoothnessTextureChannel"))
            {
                SetKeyword(material, "_SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A", GetSmoothnessMapChannel(material) == SmoothnessMapChannel.AlbedoAlpha);
            }
        }

        static void MaterialChanged(Material material, WorkflowMode workflowMode)
        {
            SetupMaterialWithBlendMode(material, (BlendMode)material.GetFloat("_Mode"));

            SetMaterialKeywords(material, workflowMode);
        }

        static void SetKeyword(Material m, string keyword, bool state)
        {
            if (state)
                m.EnableKeyword(keyword);
            else
                m.DisableKeyword(keyword);
        }
       
    }
} // namespace UnityEditor
RSRC                    VisualShader            
8'�                                             L      resource_local_to_scene    resource_name    output_port_for_preview    default_input_values    expanded_output_ports    linked_parent_graph_frame    parameter_name 
   qualifier    default_value_enabled    default_value    script    op_type 	   operator 	   function    hint    min    max    step    source    texture    texture_type    input_name    color_default    texture_filter    texture_repeat    texture_source    code    graph_offset    mode    modes/blend    flags/skip_vertex_transform    flags/unshaded    flags/light_only    flags/world_vertex_coords    nodes/vertex/0/position    nodes/vertex/connections    nodes/fragment/0/position    nodes/fragment/2/node    nodes/fragment/2/position    nodes/fragment/3/node    nodes/fragment/3/position    nodes/fragment/4/node    nodes/fragment/4/position    nodes/fragment/6/node    nodes/fragment/6/position    nodes/fragment/7/node    nodes/fragment/7/position    nodes/fragment/8/node    nodes/fragment/8/position    nodes/fragment/9/node    nodes/fragment/9/position    nodes/fragment/10/node    nodes/fragment/10/position    nodes/fragment/11/node    nodes/fragment/11/position    nodes/fragment/12/node    nodes/fragment/12/position    nodes/fragment/13/node    nodes/fragment/13/position    nodes/fragment/connections    nodes/light/0/position    nodes/light/connections    nodes/start/0/position    nodes/start/connections    nodes/process/0/position    nodes/process/connections    nodes/collide/0/position    nodes/collide/connections    nodes/start_custom/0/position    nodes/start_custom/connections     nodes/process_custom/0/position !   nodes/process_custom/connections    nodes/sky/0/position    nodes/sky/connections    nodes/fog/0/position    nodes/fog/connections    
   Texture2D 4   res://assets/sprites/ability_holder_shader_mask.png Ց8�J[�d   ,   local://VisualShaderNodeVec2Parameter_wdrw2 k
      '   local://VisualShaderNodeVectorOp_f4emv �
      %   local://VisualShaderNodeUVFunc_u3deg <      -   local://VisualShaderNodeColorParameter_3srpy c      '   local://VisualShaderNodeVectorOp_00jbp �      -   local://VisualShaderNodeFloatParameter_8ksrc e      &   local://VisualShaderNodeTexture_vvtbr �      &   local://VisualShaderNodeFloatOp_a8eip       $   local://VisualShaderNodeInput_m78xw B      1   local://VisualShaderNodeTexture2DParameter_5kj5q y      &   local://VisualShaderNodeTexture_0pmbp �      D   res://shaders/opponent_character_ability_aura_shader_visualtres.res +         VisualShaderNodeVec2Parameter             Speed          	   
   )\�=)\�=
         VisualShaderNodeVectorOp                    
                 
                              
         VisualShaderNodeUVFunc    
         VisualShaderNodeColorParameter                          
   AuraColor          	      jL�>n�+?      �?
         VisualShaderNodeVectorOp                                                                                  
         VisualShaderNodeFloatParameter          
   Intensity          	      
׋@
         VisualShaderNodeTexture                                 
         VisualShaderNodeFloatOp             
         VisualShaderNodeInput             time 
      #   VisualShaderNodeTexture2DParameter             Texture2DParameter                   
         VisualShaderNodeTexture                             
         VisualShader          ?  shader_type canvas_item;
render_mode blend_mix;

uniform vec4 AuraColor : source_color = vec4(0.297458, 0.670493, 0.000000, 1.000000);
uniform float Intensity = 4.36999988555908;
uniform vec2 Speed = vec2(0.070000, 0.070000);
uniform sampler2D Texture2DParameter : filter_nearest, repeat_enable;
uniform sampler2D tex_frg_9;



void fragment() {
// ColorParameter:6
	vec4 n_out6p0 = AuraColor;


// FloatParameter:8
	float n_out8p0 = Intensity;


// VectorOp:7
	vec4 n_out7p0 = n_out6p0 * vec4(n_out8p0);


// Input:11
	float n_out11p0 = TIME;


// Vector2Parameter:2
	vec2 n_out2p0 = Speed;


// VectorOp:3
	vec2 n_out3p0 = vec2(n_out11p0) * n_out2p0;


// UVFunc:4
	vec2 n_in4p1 = vec2(1.00000, 1.00000);
	vec2 n_out4p0 = n_out3p0 * n_in4p1 + UV;


	vec4 n_out13p0;
// Texture2D:13
	n_out13p0 = texture(Texture2DParameter, n_out4p0);
	float n_out13p1 = n_out13p0.r;


// Texture2D:9
	vec4 n_out9p0 = texture(tex_frg_9, UV);
	float n_out9p1 = n_out9p0.r;


// FloatOp:10
	float n_out10p0 = n_out13p1 * n_out9p1;


// Output:0
	COLOR.rgb = vec3(n_out7p0.xyz);
	COLOR.a = n_out10p0;


}
                     %             &   
     ��  HC'            (   
   �k�� nb@)            *   
    ���   �+            ,   
     ��  ��-            .   
     \C  ��/            0   
     �  ��1            2   
     �  �C3            4   
   �_��čC5            6   
    ���  �A7         	   8   
     ��  �C9         
   :   
   Ģ]�B;       ,                                                                                                        
                     	      
      
              
      RSRC
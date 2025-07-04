RSRC                    VisualShader            �X����?                                            K      resource_local_to_scene    resource_name    output_port_for_preview    default_input_values    expanded_output_ports    linked_parent_graph_frame    input_name    script    parameter_name 
   qualifier    hint    min    max    step    default_value_enabled    default_value    op_type 	   operator    code    graph_offset    mode    modes/blend    modes/depth_draw    modes/cull    modes/diffuse    modes/specular    flags/depth_prepass_alpha    flags/depth_test_disabled    flags/sss_mode_skin    flags/unshaded    flags/wireframe    flags/skip_vertex_transform    flags/world_vertex_coords    flags/ensure_correct_normals    flags/shadows_disabled    flags/ambient_light_disabled    flags/shadow_to_opacity    flags/vertex_lighting    flags/particle_trails    flags/alpha_to_coverage     flags/alpha_to_coverage_and_one    flags/debug_shadow_splits    flags/fog_disabled    nodes/vertex/0/position    nodes/vertex/2/node    nodes/vertex/2/position    nodes/vertex/3/node    nodes/vertex/3/position    nodes/vertex/4/node    nodes/vertex/4/position    nodes/vertex/5/node    nodes/vertex/5/position    nodes/vertex/6/node    nodes/vertex/6/position    nodes/vertex/connections    nodes/fragment/0/position    nodes/fragment/2/node    nodes/fragment/2/position    nodes/fragment/connections    nodes/light/0/position    nodes/light/connections    nodes/start/0/position    nodes/start/connections    nodes/process/0/position    nodes/process/connections    nodes/collide/0/position    nodes/collide/connections    nodes/start_custom/0/position    nodes/start_custom/connections     nodes/process_custom/0/position !   nodes/process_custom/connections    nodes/sky/0/position    nodes/sky/connections    nodes/fog/0/position    nodes/fog/connections        $   local://VisualShaderNodeInput_pfyp4 �      -   local://VisualShaderNodeFloatParameter_dlirl 2	      '   local://VisualShaderNodeVectorOp_garjb �	      $   local://VisualShaderNodeInput_encq3 �	      '   local://VisualShaderNodeVectorOp_nrqfb �	      -   local://VisualShaderNodeColorParameter_ygcsg (
      "   res://shaders/hull_outline_3d.res m
         VisualShaderNodeInput             normal          VisualShaderNodeFloatParameter             OutlineSize                ��L=         VisualShaderNodeVectorOp                      VisualShaderNodeInput             vertex          VisualShaderNodeVectorOp             VisualShaderNodeColorParameter          
   BaseColor          VisualShader          z  shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_front, diffuse_lambert, specular_schlick_ggx;

uniform float OutlineSize = 0.05000000074506;
uniform vec4 BaseColor : source_color;



void vertex() {
// FloatParameter:3
	float n_out3p0 = OutlineSize;


// VectorOp:4
	vec3 n_in4p0 = vec3(0.00000, 0.00000, 0.00000);
	vec3 n_out4p0 = n_in4p0 * vec3(n_out3p0);


// VectorOp:6
	vec3 n_in6p1 = vec3(0.00000, 0.00000, 0.00000);
	vec3 n_out6p0 = n_out4p0 + n_in6p1;


// Output:0
	VERTEX = n_out6p0;


}

void fragment() {
// ColorParameter:2
	vec4 n_out2p0 = BaseColor;


// Output:0
	ALBEDO = vec3(n_out2p0.xyz);


}
          ,             -   
   �@�l��B.            /   
   �@Ķ^[C0            1   
   �mö^C2            3   
   ���[��C4            5   
   ��+B[��C6                                                    7   
    ��D  pB8            9   
     \D  �B:                               RSRC
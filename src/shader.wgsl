@vertex
fn vs_main(@builtin(vertex_index) vertex_index: u32) -> @builtin(position) vec4<f32> {
    var pos = array<vec2<f32>, 3>(
        vec2<f32>(-1.0, -3.0),
        vec2<f32>(3.0, 1.0),
        vec2<f32>(-1.0, 1.0),
    );
    return vec4<f32>(pos[vertex_index], 0.0, 1.0);
}
@fragment
fn fs_main(@builtin(position) coord: vec4<f32>) -> @location(0) vec4<f32> {
    // Assuming your canvas size is passed as a uniform
    let resolution = vec2<f32>(800.0, 600.0); // Replace with actual resolution
    let uv = (coord.xy / resolution) * 2.0 - vec2<f32>(1.0, 1.0); // Now in [-1, 1]

    let center = vec2<f32>(0.0, 0.0);
    let d = distance(uv, center);

    let outerRing = smoothstep(0.45, 0.46, d) - smoothstep(0.49, 0.5, d);
    let innerRing = smoothstep(0.2, 0.21, d) - smoothstep(0.4, 0.41, d);
    let centerCircle = smoothstep(0.0, 0.19, d);

    var col = vec3<f32>(0.9, 0.9, 0.9); 

    if (outerRing > 0.0) {
        col = vec3<f32>(0.0, 0.7, 0.0);
    } else if (innerRing > 0.0) {
        col = vec3<f32>(0.0, 0.8, 0.0);
    } else if (centerCircle > 0.0) {
        col = vec3<f32>(0.0, 0.9, 0.0);
    }

    let angle = atan2(uv.y, uv.x);
    let numRays = 100.0;
    let ray = cos(angle * numRays * 0.5) * 0.5 + 0.5;
    let rayMask = step(0.9, ray) * smoothstep(0.5, 0.0, d);
    col = mix(col, vec3<f32>(1.0), rayMask * 0.7);

    return vec4<f32>(col, 1.0);
}


#!/bin/bash
# QuishesOS Animation Configuration
# Adaptive timing for 60Hz, 100Hz, and 120Hz displays

# Detect current refresh rate
get_refresh_rate() {
    local rate=$(hyprctl monitors -j | jq -r '.[0].refreshRate' | cut -d'.' -f1)
    echo "${rate:-60}"
}

# Calculate animation duration based on refresh rate
# Args: base_duration_ms refresh_rate
calc_duration() {
    local base=$1
    local hz=$2
    
    # Scale durations for higher refresh rates
    # 60Hz = 1.0x, 100Hz = 0.85x, 120Hz = 0.75x
    case $hz in
        120)
            echo "$(echo "$base * 0.75" | bc | cut -d'.' -f1)"
            ;;
        100)
            echo "$(echo "$base * 0.85" | bc | cut -d'.' -f1)"
            ;;
        *)
            echo "$base"
            ;;
    esac
}

# Generate Hyprland animation config for current refresh rate
generate_hyprland_animations() {
    local hz=$(get_refresh_rate)
    local config="$HOME/.config/hypr/animations_$hz.conf"
    
    # Base durations (for 60Hz)
    local window_duration=$(calc_duration 250 $hz)
    local workspace_duration=$(calc_duration 300 $hz)
    local fade_duration=$(calc_duration 200 $hz)
    
    cat > "$config" << EOF
# QuishesOS Animations - Optimized for ${hz}Hz
# Generated automatically - do not edit manually

animations {
    enabled = true
    first_launch_animation = true

    # Custom bezier curves for liquid glass feel
    bezier = liquid, 0.25, 0.46, 0.45, 0.94
    bezier = macOS, 0.32, 0.64, 0.45, 1.0
    bezier = smoothPop, 0.68, -0.55, 0.265, 1.55
    bezier = glass, 0.42, 0, 0.58, 1.0

    # Window animations (${window_duration}ms base)
    animation = windows, 1, $(echo "$window_duration / 100" | bc -l), liquid, slide
    animation = windowsIn, 1, $(echo "$window_duration / 100" | bc -l), liquid, popin 94%
    animation = windowsOut, 1, $(echo "$window_duration / 100" | bc -l), smoothPop, popin 94%
    animation = windowsMove, 1, $(echo "$window_duration / 100" | bc -l), glass, slide

    # Border & fade (${fade_duration}ms base)
    animation = border, 1, $(echo "$fade_duration / 80" | bc -l), glass
    animation = borderangle, 1, 50, glass, loop
    animation = fade, 1, $(echo "$fade_duration / 100" | bc -l), glass
    animation = fadeDim, 1, $(echo "$fade_duration / 100" | bc -l), glass
    animation = fadeSwitch, 1, $(echo "$fade_duration / 100" | bc -l), glass
    animation = fadeShadow, 1, $(echo "$fade_duration / 100" | bc -l), glass
    animation = fadeLayersIn, 1, $(echo "$fade_duration / 100" | bc -l), glass
    animation = fadeLayersOut, 1, $(echo "$fade_duration / 100" | bc -l), glass

    # Workspace animations (${workspace_duration}ms base)
    animation = workspaces, 1, $(echo "$workspace_duration / 100" | bc -l), liquid, slide
    animation = specialWorkspace, 1, $(echo "$workspace_duration / 100" | bc -l), liquid, slidevert
}
EOF

    echo "Generated animations for ${hz}Hz: $config"
}

# Generate eww CSS animation variables
generate_eww_animations() {
    local hz=$(get_refresh_rate)
    local css="$HOME/.config/eww/animations_$hz.scss"
    
    # Base durations (for 60Hz)
    local quick=$(calc_duration 150 $hz)
    local normal=$(calc_duration 250 $hz)
    local slow=$(calc_duration 400 $hz)
    
    cat > "$css" << EOF
// QuishesOS eww Animations - Optimized for ${hz}Hz
// Generated automatically

\$anim-quick: ${quick}ms;
\$anim-normal: ${normal}ms;
\$anim-slow: ${slow}ms;

\$ease-liquid: cubic-bezier(0.25, 0.46, 0.45, 0.94);
\$ease-glass: cubic-bezier(0.42, 0, 0.58, 1);
\$ease-bounce: cubic-bezier(0.68, -0.55, 0.265, 1.55);

@mixin smooth-transition(\$property: all, \$duration: \$anim-normal) {
  transition: \$property \$duration \$ease-glass;
  will-change: \$property;
}

@mixin hover-lift {
  @include smooth-transition(transform, \$anim-quick);
  &:hover {
    transform: translateY(-2px) scale(1.05);
  }
}

@mixin slide-in(\$direction: right) {
  animation: slide-\$direction \$anim-normal \$ease-liquid;
}

@keyframes slide-right {
  from { transform: translateX(100%); opacity: 0; }
  to { transform: translateX(0); opacity: 1; }
}

@keyframes slide-left {
  from { transform: translateX(-100%); opacity: 0; }
  to { transform: translateX(0); opacity: 1; }
}

@keyframes slide-up {
  from { transform: translateY(20px); opacity: 0; }
  to { transform: translateY(0); opacity: 1; }
}

@keyframes fade-in {
  from { opacity: 0; }
  to { opacity: 1; }
}

@keyframes pop-in {
  0% { transform: scale(0.8); opacity: 0; }
  50% { transform: scale(1.05); }
  100% { transform: scale(1); opacity: 1; }
}
EOF

    echo "Generated eww animations for ${hz}Hz: $css"
}

# Apply animations for current refresh rate
apply_animations() {
    generate_hyprland_animations
    generate_eww_animations
    
    local hz=$(get_refresh_rate)
    
    # Link generated configs to active configs
    ln -sf "$HOME/.config/hypr/animations_$hz.conf" "$HOME/.config/hypr/animations.conf"
    ln -sf "$HOME/.config/eww/animations_$hz.scss" "$HOME/.config/eww/animations.scss"
    
    # Reload Hyprland config
    hyprctl reload
    
    echo "Applied animations for ${hz}Hz display"
}

# Main execution
case "${1:-apply}" in
    generate-hyprland)
        generate_hyprland_animations
        ;;
    generate-eww)
        generate_eww_animations
        ;;
    apply)
        apply_animations
        ;;
    detect)
        echo "Current refresh rate: $(get_refresh_rate)Hz"
        ;;
    *)
        echo "Usage: $0 {generate-hyprland|generate-eww|apply|detect}"
        exit 1
        ;;
esac

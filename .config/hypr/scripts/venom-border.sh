#!/bin/bash

# Venom symbiote heartbeat border - stationary with smooth pulse

while true; do
    # FIRST BEAT (LUB) - rise to peak
    for i in {0..100..8}; do
        bright=$((155 + i))
        mid=$((100 + i / 2))
        dark=$((50 + i / 3))
        
        bright_hex=$(printf '%02x' $((bright > 255 ? 255 : bright)))
        mid_hex=$(printf '%02x' $mid)
        dark_hex=$(printf '%02x' $dark)
        
        hyprctl keyword general:col.active_border "rgba(${bright_hex}0000ff) rgba(${mid_hex}0000ff) rgba(${dark_hex}0000ff) rgba(${mid_hex}0000ff) rgba(${bright_hex}0000ff) 45deg"
        sleep 0.08
    done
    
    # Fade down quickly
    for i in {100..50..20}; do
        bright=$((155 + i))
        mid=$((100 + i / 2))
        dark=$((50 + i / 3))
        
        bright_hex=$(printf '%02x' $((bright > 255 ? 255 : bright)))
        mid_hex=$(printf '%02x' $mid)
        dark_hex=$(printf '%02x' $dark)
        
        hyprctl keyword general:col.active_border "rgba(${bright_hex}0000ff) rgba(${mid_hex}0000ff) rgba(${dark_hex}0000ff) rgba(${mid_hex}0000ff) rgba(${bright_hex}0000ff) 45deg"
        sleep 0.04
    done
    
    # Short pause
    sleep 0.12
    
    # SECOND BEAT (dub) - smaller pulse
    for i in {0..70..10}; do
        bright=$((155 + i))
        mid=$((100 + i / 2))
        dark=$((50 + i / 3))
        
        bright_hex=$(printf '%02x' $((bright > 255 ? 255 : bright)))
        mid_hex=$(printf '%02x' $mid)
        dark_hex=$(printf '%02x' $dark)
        
        hyprctl keyword general:col.active_border "rgba(${bright_hex}0000ff) rgba(${mid_hex}0000ff) rgba(${dark_hex}0000ff) rgba(${mid_hex}0000ff) rgba(${bright_hex}0000ff) 45deg"
        sleep 0.08
    done
    
    # Fade to resting state
    for i in {70..0..10}; do
        bright=$((155 + i))
        mid=$((100 + i / 2))
        dark=$((50 + i / 3))
        
        bright_hex=$(printf '%02x' $((bright > 255 ? 255 : bright)))
        mid_hex=$(printf '%02x' $mid)
        dark_hex=$(printf '%02x' $dark)
        
        hyprctl keyword general:col.active_border "rgba(${bright_hex}0000ff) rgba(${mid_hex}0000ff) rgba(${dark_hex}0000ff) rgba(${mid_hex}0000ff) rgba(${bright_hex}0000ff) 45deg"
        sleep 0.08
    done
    
    # Long pause between heartbeats
    sleep 0.6
done

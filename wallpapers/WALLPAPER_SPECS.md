# QuishesOS Wallpaper Specifications

## Overview

Each of the 6 QuishesOS themes has a matching wallpaper with soft gradient colors designed to bleed through the frosted glass UI elements. Wallpapers are abstract gradients with diagonal flow, slightly out of focus for the glass blur effect.

**Resolution**: 2560x1440 (1440p) recommended, scalable to 1920x1080 or 3840x2160

---

## 1. Liquid Pastel (Default)

**Color Stops** (diagonal top-left to bottom-right):
- Position 0%: `#fff5f0` (warm cream white)
- Position 25%: `#ffe6dc` (peachy beige)
- Position 50%: `#ffd4ca` (soft coral)
- Position 75%: `#ffccc0` (coral pink)
- Position 100%: `#ffb8a8` (rose coral)

**Direction**: 135° (diagonal from top-left)  
**Blur**: Gaussian blur 8-12px for soft focus  
**Style**: Pastel, dreamy, soft, warm

**CSS Linear Gradient**:
```css
background: linear-gradient(135deg, #fff5f0 0%, #ffe6dc 25%, #ffd4ca 50%, #ffccc0 75%, #ffb8a8 100%);
```

---

## 2. Nordic Frost

**Color Stops** (diagonal):
- Position 0%: `#eceff4` (ice white)
- Position 25%: `#e5e9f0` (pale blue-gray)
- Position 50%: `#d8dee9` (light steel blue)
- Position 75%: `#c2d0e0` (soft steel blue)
- Position 100%: `#b0c4de` (light steel blue)

**Direction**: 135°  
**Blur**: Gaussian blur 6-10px  
**Style**: Cool, minimal, Scandinavian, crisp

**CSS Linear Gradient**:
```css
background: linear-gradient(135deg, #eceff4 0%, #e5e9f0 25%, #d8dee9 50%, #c2d0e0 75%, #b0c4de 100%);
```

---

## 3. Sakura Dream

**Color Stops** (diagonal):
- Position 0%: `#fff0f5` (pale pink)
- Position 25%: `#ffe6f0` (blush white)
- Position 50%: `#ffdce8` (light pink)
- Position 75%: `#ffc8e0` (rose pink)
- Position 100%: `#ffb4d8` (cherry blossom pink)

**Direction**: 135°  
**Blur**: Gaussian blur 10-14px for dreamy effect  
**Style**: Romantic, soft, delicate, Japanese-inspired

**CSS Linear Gradient**:
```css
background: linear-gradient(135deg, #fff0f5 0%, #ffe6f0 25%, #ffdce8 50%, #ffc8e0 75%, #ffb4d8 100%);
```

---

## 4. Forest Mist

**Color Stops** (diagonal):
- Position 0%: `#f0f8f0` (pale mint)
- Position 25%: `#e6f2e6` (light sage)
- Position 50%: `#dce8dc` (soft sage)
- Position 75%: `#c8dcc8` (sage green)
- Position 100%: `#b4d0b4` (forest sage)

**Direction**: 135°  
**Blur**: Gaussian blur 7-11px  
**Style**: Natural, calm, earthy, tranquil

**CSS Linear Gradient**:
```css
background: linear-gradient(135deg, #f0f8f0 0%, #e6f2e6 25%, #dce8dc 50%, #c8dcc8 75%, #b4d0b4 100%);
```

---

## 5. Sunset Amber

**Color Stops** (diagonal):
- Position 0%: `#fff5eb` (warm cream)
- Position 25%: `#ffe8d0` (light peach)
- Position 50%: `#ffdcb4` (soft amber)
- Position 75%: `#ffc898` (golden amber)
- Position 100%: `#ffb47c` (rich amber orange)

**Direction**: 135°  
**Blur**: Gaussian blur 6-10px  
**Style**: Warm, cozy, golden hour, inviting

**CSS Linear Gradient**:
```css
background: linear-gradient(135deg, #fff5eb 0%, #ffe8d0 25%, #ffdcb4 50%, #ffc898 75%, #ffb47c 100%);
```

---

## 6. Aurora Glass (Dark)

**Color Stops** (diagonal with holographic effect):
- Position 0%: `#0d0d0f` (near-black)
- Position 20%: `#1a1a22` (dark blue-black)
- Position 40%: `#1f2533` (dark slate)
- Position 60%: `#243044` (midnight blue)
- Position 80%: `#2a3b55` (deep blue)
- Position 100%: `#304666` (steel blue)

**Overlay (holographic aurora effect)**:
- Add soft cyan-to-purple gradient overlay at 15-25% opacity
- Cyan `#00d4ff` → Magenta `#ff00aa` → Purple `#b759ff`
- Use radial or diagonal gradient with blur

**Direction**: 135°  
**Blur**: Gaussian blur 10-15px for soft holographic glow  
**Style**: Dark, futuristic, iridescent oil-slick, premium

**CSS Linear Gradient (base + overlay)**:
```css
background: 
  linear-gradient(135deg, rgba(0, 212, 255, 0.2) 0%, rgba(255, 0, 170, 0.15) 50%, rgba(183, 89, 255, 0.2) 100%),
  linear-gradient(135deg, #0d0d0f 0%, #1a1a22 20%, #1f2533 40%, #243044 60%, #2a3b55 80%, #304666 100%);
```

---

## Generation Methods

### Method 1: CSS Gradient (Web Preview)
Create an HTML file with full-screen gradient and take screenshot at 2560x1440:

```html
<!DOCTYPE html>
<html><head><style>
body { margin: 0; height: 100vh; background: [INSERT GRADIENT]; filter: blur(10px); }
</style></head><body></body></html>
```

### Method 2: GIMP
1. Create new image: 2560x1440
2. Tools → Blend (Gradient)
3. Set FG/BG colors to start/end colors
4. Use custom gradient with 5 color stops
5. Drag diagonally (top-left to bottom-right)
6. Filters → Blur → Gaussian Blur (8-12px radius)
7. Export as PNG

### Method 3: ImageMagick (Command Line)
```bash
convert -size 2560x1440 gradient:"#fff5f0-#ffb8a8" \
  -rotate 135 \
  -blur 0x10 \
  liquid-pastel-wallpaper.png
```

### Method 4: Python (Pillow)
```python
from PIL import Image, ImageDraw, ImageFilter

img = Image.new('RGB', (2560, 1440))
draw = ImageDraw.Draw(img)

# Create gradient (requires gradient library or manual pixel iteration)
# Apply gaussian blur
img = img.filter(ImageFilter.GaussianBlur(10))
img.save('wallpaper.png')
```

---

## Installation

1. Generate or download wallpapers
2. Place in `~/Pictures/Wallpapers/QuishesOS/`
3. Set via `~/.config/hypr/hyprland.conf`:

```conf
exec-once = swaybg -i ~/Pictures/Wallpapers/QuishesOS/liquid-pastel.png -m fill
```

Or use theme manager to auto-switch wallpaper with theme.

---

## Design Principles

1. **Soft Focus**: Slight blur (8-12px) prevents sharp edges that would distract from glass UI
2. **Diagonal Flow**: 135° angle creates dynamic movement without being jarring
3. **Color Bleeding**: Colors are chosen to bleed pleasantly through 40-55px backdrop blur
4. **No Shapes**: Pure gradients only - no objects, patterns, or geometric shapes
5. **2560x1440**: Native 1440p ensures crisp display on modern monitors

---

## Theme-Wallpaper Pairing

| Theme | Wallpaper | Mood |
|-------|-----------|------|
| Liquid Pastel | Coral peach gradients | Warm, dreamy, soft |
| Nordic Frost | Ice blue steel tones | Cool, minimal, clean |
| Sakura Dream | Cherry blossom pink | Romantic, delicate, airy |
| Forest Mist | Sage green earth tones | Calm, natural, peaceful |
| Sunset Amber | Golden amber orange | Warm, cozy, inviting |
| Aurora Glass | Dark holographic aurora | Futuristic, premium, dramatic |

# 🎨 Draya (دراية) — Design System & Handoff Tokens

This document contains the core visual tokens, color codes, border definitions, and typography scales extracted directly from the **Draya (دراية)** codebase. Use this package to initialize the theme in frontend (web) and native mobile (iOS/Android) environments.

---

## 1. Brand Color Palette (HEX Values)

### 🟢 Primary Teal Scale (Core Brand Identity)
Used for primary buttons, core branding elements, navigation states, and general page layouts:
- **`primary-900`**: `#0F4F49` — Footer backgrounds, dark branding accents, high-emphasis banners.
- **`primary-800`**: `#145A53` — Card hover borders, secondary high-contrast labels.
- **`primary-700`**: `#1B6D63` — **Brand Core Accent**. Primary button backgrounds, active link text.
- **`primary-600`**: `#228174` — Medium teal highlight.
- **`primary-500`**: `#2D9B8A` — Standard focus rings, input highlight borders.
- **`primary-400`**: `#52B6A8` — Scrollbar hover thumbs, lighter UI accent fills.
- **`primary-300`**: `#83D1C7` — Soft borders.
- **`primary-200`**: `#B7E8E1` — Disabled/selected tinted icons.
- **`primary-100`**: `#DDF5F1` — Hover backdrops behind cards or menu lists.
- **`primary-5`**:  `#F5FCFB` — Page sub-banners background.

### 🔮 AI Violet Scale (AI-Powered Smart Modules)
Used exclusively for AI Exam Builders, AI-generated reports, analytics charts, and smart badges:
- **`ai-900`**: `#5B21B6` — High-emphasis text in AI cards.
- **`ai-700`**: `#7C3AED` — **AI Core Accent**. Badges, prompt borders, AI report builders.
- **`ai-500`**: `#8B5CF6` — Purple charts progress bars.
- **`ai-300`**: `#C4B5FD` — Weakness breakdown indicator fills.
- **`ai-100`**: `#EDE9FE` — Soft Purple background tags.
- **`ai-50`**:  `#F7F3FF` — Highlight boxes background.

### 🎨 Academic Subject Semantics
Used to categorize dashboard items and progress metrics:
- **Math/Physics**: `#3B82F6` (Blue) or `#F59E0B` (Amber)
- **Chemistry/Biology**: `#22C55E` (Emerald) or `#06B6D4` (Cyan)
- **Humanities**: `#EC4899` (Rose/Pink)

---

## 2. Global Theme Surfaces & Borders

### 🏛️ Surface Hierarchy
- **`bg-base`**: `#FAFAF8` — **Global Layout Background** (warm, premium, editorial off-white).
- **`bg-surface`**: `#FFFFFF` — Primary white cards, dropdown panels, and modal containers.
- **`bg-secondary`**: `#F8FBFA` — Inner lists, secondary tables, and subtle sidebars.
- **`bg-muted`**: `#F4F8F7` — Gray-teal muted elements, empty states.
- **`bg-accent`**: `#EFF8F6` — Selected checklist boxes.

### 📐 Borders & Outlines
- **`border`**: `#EBEFEF` — Standard separator lines, flat card borders, accordion dividers.
- **`border-strong`**: `#DDE4E2` — Input field borders, inactive selector borders.
- **Contrast Rule**: Standard cards are designed flat. Elevation shadows are disabled (`shadow: none`) and replaced with thin `1.5px solid #EBEFEF` borders.

---

## 3. Neutral Typography Scale (Arabic-First)

### ✍️ Font Families
- **Primary Web/App Font**: `'Cairo', 'IBM Plex Sans Arabic', system-ui, sans-serif` (RTL-optimized, sans-serif).
- **Numbers rendering**: Explicitly forced to Western Arabic (lining numbers) in CSS:
  ```css
  -webkit-locale: 'ar-u-nu-latn';
  font-variant-numeric: lining-nums;
  ```

### 📏 Typography Hierarchy
| Level | Font Size | Weight | Line Height | Usage |
| :--- | :--- | :--- | :--- | :--- |
| **`h1`** | `2.00rem` (`32px`) | `800` (Extra Bold) | `1.25` | Main page titles, hero titles |
| **`h2`** | `1.50rem` (`24px`) | `700` (Bold) | `1.33` | Section headings, modal titles |
| **`h3`** | `1.125rem` (`18px`) | `600` (Semi Bold) | `1.44` | Card titles, analytics group labels |
| **`h4`** | `1.00rem` (`16px`) | `500` (Medium) | `1.50` | Body subheaders |
| **`body`** | `0.9375rem` (`15px`) | `400` (Regular) | `1.50` | Paragraphs, dropdown texts |
| **`button`** | `0.9375rem` (`15px`) | `600` (Semi Bold) | `1.50` | Button actions, chip badges |
| **`label`** | `0.8125rem` (`13px`) | `600` (Semi Bold) | `1.50` | Input form labels |

---

## 4. UI Layout Specifications

### 🔲 Corner Radii
- **`radius-sm`**: `8px` — Input fields, small badges, dropdown menus.
- **`radius-md`**: `12px` — Standard action buttons, small cards, checkmarks.
- **`radius-lg`**: `16px` — Dashboard cards, modular lists, popup modals.
- **`radius-full`**: `999px` — Pill badges, tab switches, profile avatar frames.

### ⏱️ Transitions & Animation Durations
- **Hover/Scale Transitions**: `all 200ms cubic-bezier(0.16, 1, 0.3, 1)` (applied to cards, links, and buttons).
- **Scale Interaction**: Buttons shrink slightly to `scale-[0.98]` on active click.
- **Sidebar Slide Drawers**: `right 300ms ease-in-out` (mobile slide-out panels).

### 🥞 Elevation Layers (Z-Index)
- **`z-sticky`**: `100` — Sticky charts filters or sidebar widgets.
- **`z-header`**: `500` — Main sticky navigation headers.
- **`z-dropdown`**: `800` — Select inputs overlay lists, contextual options.
- **`z-modal`**: `1000` — Backdrop covers, dialog screens.
- **`z-toast`**: `1200` — Floating feedback toast notices.

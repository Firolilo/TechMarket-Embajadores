# Resumen de vision y diseno - TechMarket

## 1) Vision del producto
TechMarket se plantea como un ecosistema tecnologico especializado que conecta clientes, empresas y embajadores en una misma plataforma.

Objetivo de experiencia:
- Hacer que la exploracion de productos y servicios tech se sienta clara, confiable y moderna.
- Transmitir una identidad digital de "precision tecnica + cercania de uso".
- Priorizar flujos directos para login/registro y entrada rapida segun tipo de usuario.

## 2) Direccion visual general
La interfaz sigue una estetica "tech-futurista" sobria:
- Base oscura profunda con gradientes atmosfericos.
- Acentos cyan/azules brillantes para acciones y foco.
- Superficies en capas para dar profundidad sin ruido visual.
- Uso de bordes suaves, sombras controladas y glow ligero.

Esto genera una sensacion de plataforma avanzada, pero usable para publico amplio.

## 3) Sistema de color (tokens actuales)
Paleta base definida en CSS variables:
- background: #041325
- background-soft: #0a1d36
- surface: #0f2a4a
- surface-strong: #12355f
- foreground: #e7f2ff
- muted: #9bb7d4
- primary: #27b0ff
- primary-strong: #0a7dff
- accent: #59e3ff
- line: #2a4f79

Uso recomendado:
- Fondo principal: background/background-soft.
- Tarjetas y paneles: surface/surface-strong con transparencias.
- CTA principales: primary + primary-strong en gradiente.
- Elementos de apoyo y resalte: accent.
- Texto secundario y ayudas: muted.

## 4) Tipografia y tono
Tipografias activas:
- Space Grotesk: tipografia principal para interfaz y headings.
- JetBrains Mono: detalles tecnicos, labels de sistema y micro-copy de estado.

Tono de contenido:
- Claro, directo, funcional.
- Vocabulario tecnologico sin exceso de complejidad.
- Prioridad en acciones concretas (ingresar, crear cuenta, explorar).

## 5) Patrones de UI que se repiten
Componentes y estilos recurrentes:
- Hero principal con gradiente y borde luminoso suave.
- Chips para categorizar contexto.
- Cards modulares con profundidad y jerarquia de texto.
- Botones primarios con gradiente azul y secundarios tipo glass oscuro.
- Top nav semitransparente con blur para continuidad visual.
- Scrollbars custom alineadas al look cyan/blue.

## 6) Movimiento e interaccion
- Animacion base fadeRise para entradas progresivas.
- Hover sutil con translateY(-1px) en elementos clicables.
- Estados activos marcados por gradiente brillante y contraste alto.
- Focus visible en inputs con halo azul para accesibilidad funcional.

## 7) Layout y responsive
- Contenedor principal reusable (.tech-shell) para consistencia de ancho.
- Estructuras grid adaptativas para auth y cards.
- Breakpoints principales:
  - <=860px: ajuste de margenes del shell.
  - >=920px: layout de auth en dos columnas.

## 8) Principios practicos para mantener consistencia
- Reusar tokens de color antes de introducir nuevos hex.
- Mantener contraste alto texto/fondo en toda vista.
- Reservar gradientes mas intensos para CTA o estado activo.
- Evitar saturar con demasiados brillos simultaneos.
- Mantener microinteracciones cortas y coherentes (180ms aprox.).

## 9) Referencias internas usadas para este resumen
- frontend/app/globals.css
- frontend/app/layout.tsx
- frontend/app/page.tsx
